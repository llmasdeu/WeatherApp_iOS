//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lluís Masdeu on 23/11/2019.
//  Copyright © 2019 Lluís Masdeu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Lottie

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var currentDayPageControl: UIPageControl!
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var responseData: ResponseData?
    private var workItem: DispatchWorkItem?
    private var isDataLoaded: Bool! = false
    private var currentItem: Int = 0
    private var days: [String] = []
    private var previousSearch: PreviousSearch?
    
    //
    // Function in charge of doing the initial tasks when the view has loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checking if the location manager is initialized
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        // Defines the keyboard type for the city text field
        cityTextField.delegate = self
        cityTextField.keyboardType = UIKeyboardType.webSearch
        cityTextField.returnKeyType = .done
        
        // Clearing the weather interface
        clearWeatherInterface()
        
        // Changing the animation view
        changeAsyncAnimationView(animation: "193-material-loading")
        
        // Defining the delegate for the location manager
        locationManager!.delegate = self
        
        // Requesting the authorization for the device's location, in case it hasn't been
        // previously done
        locationManager!.requestAlwaysAuthorization()

        // Setting the initial forecast
        setInitialForecast()
        
        // Creating the swipe gestures recognizer
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    //
    // Function in charge of controlling the 'Done' button of the keyboard for the city
    // text field
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCityWeatherForecast()
        textField.resignFirstResponder()
        
        return true
    }
    
    //
    // Function in charge of
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        // Updates the current item identifier
        if gesture.direction == .right {
            print("Swipe Right")
            
            if self.currentItem == 0 {
                self.currentItem = 4
            } else {
                self.currentItem -= 1
            }
        } else if gesture.direction == .left {
            print("Swipe Left")
            
            if self.currentItem == 4 {
                self.currentItem = 0
            } else {
                self.currentItem += 1
            }
        }
        
        self.currentDayPageControl.currentPage = self.currentItem
        
        // Updates the weather information
        self.displayWeatherInformation()
    }
    
    //
    // Function in charge of controlling the search button
    //
    @IBAction func onSearchButtonPressed(_ sender: UIButton) {
        // Searching the weather forecast for the city
        searchCityWeatherForecast()
    }
    
    //
    // Function in charge of controlling the current location button
    //
    @IBAction func onCheckMyCurrentLocationButtonPressed(_ sender: UIButton) {
        // Searching the forecast for the current location
        searchCurrentLocationForecast()
    }
    //
    // Function in charge of setting the initial forecast
    //
    func setInitialForecast() {
        // Checks if there's previous search data stored
        getFromLocal()
        
        if (previousSearch == nil) {
            // Searching the weather forecast for the current location
            searchCurrentLocationForecast()
        } else {
            searchWeatherForecastByCoordinates(latitude: previousSearch!.latitude, longitude: previousSearch!.longitude)
        }
    }
    
    //
    // Function in charge of searching the weather forecast for the city
    //
    func searchCityWeatherForecast() {
        // Checking if the input is valid
        if cityTextField.text! != "" {
            searchWeatherForecastByCity(city: cityTextField.text!)
            clearCityTextField()
            
            // Hides the keyboard
            self.view.endEditing(true)
        }
    }
    
    //
    // Function in charge of searching the weather forecast for the current location
    //
    func searchCurrentLocationForecast() {
        // Links:
        // https://latitudelongitude.org
        // Coordinates of Barcelona: 41.38879, 2.15899
        
        // Checking if there's been any error, and retrieving the coordinates of the current location
        let (found, latitude, longitude) = getCurrentLocation()
        
        // Checking if there's been any error
        if found == true {
            searchWeatherForecastByCoordinates(latitude: latitude, longitude: longitude)
        } else {
            // Removing the weather interface
            clearWeatherInterface()
            
            // Changing the animation view
            changeAsyncAnimationView(animation: "1424-no-connection")
        }
    }
    
    //
    // Function in charge of getting the current location (latitude, longitude) of the device
    //
    func getCurrentLocation() -> (Bool, Double, Double) {
        // Requesting the current location
        locationManager!.requestLocation()
        currentLocation = locationManager!.location
        
        // Checking if something wrong has happened
        if (currentLocation == nil) {
            print("Nothing found")
        } else {
            return (true, (currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
        }
        
        return (false, 0.0, 0.0)
    }

    //
    // Function in charge of searching the weather forecast by the coordinates of the current
    // location
    //
    func searchWeatherForecastByCoordinates(latitude: Double, longitude: Double) {
        print("Start loading")
        APIManager.shared.requestWeatherForCoordinates(latitude: latitude, longitude: longitude) { (response) in
            print("Stop loading")
            self.responseData = response
            print(response)
            
            // Setting the weather results
            DispatchQueue.main.async {
                self.setWeatherResults()
            }
        }
    }
    
    //
    // Function in charge of searching the weather forecast by the name of the location
    //
    func searchWeatherForecastByCity(city: String) {
        print("Start loading")
        APIManager.shared.requestWeatherForCity(city: city) { (response) in
            print("Stop loading")
            self.responseData = response
            print(response)
            
            // Setting the weather results
            DispatchQueue.main.async {
                self.setWeatherResults()
            }
        }
    }
    
    //
    // Function in charge of setting the weather results
    //
    func setWeatherResults() {
        // Setting today as primary weather information display
        self.currentItem = 0
        self.currentDayPageControl.currentPage = self.currentItem
        
        if responseData?.responseCode! == "200" {
            // Updating the previous search data
            if previousSearch == nil {
                previousSearch = PreviousSearch(latitude: 0.0, longitude: 0.0)
            }
            
            // Sets the coordinates for the previous search
            previousSearch!.latitude = (self.responseData?.city?.coordinates?.latitude)!
            previousSearch!.longitude = (self.responseData?.city?.coordinates?.longitude)!
            
            // Shows the current day page control
            currentDayPageControl.isHidden = false
            
            // Saves the previous search data
            saveToLocal()
            
            // Removing all days
            self.days.removeAll()
            
            // Getting all days
            self.getDays()
            
            // Setting the internal variable that will tell us that some data is available
            self.isDataLoaded = true
            
            // Displays the weather information of this day
            self.displayWeatherInformation()
        } else {
            // Setting the internal variable that will tell us that some data is unavailable
            self.isDataLoaded = false
            
            // Clearing the weather interface
            clearWeatherInterface()
            
            // Changing the animation view
            changeAsyncAnimationView(animation: "4970-unapproved-cross")
        }
    }
    
    //
    // Function in charge of getting the days of the weather forecast
    //
    func getDays() {
        var current: Int = -1
        let len = 10
        
        for item in (self.responseData?.list)! {
            if current == -1 {
                current += 1
                self.days.append(String((item.dateTimeCalculation)!.prefix(len)))
            } else if String((item.dateTimeCalculation)!.prefix(len)) != days[current] {
                current += 1
                self.days.append(String((item.dateTimeCalculation)!.prefix(len)))
            }
        }
        
        print(self.days)
    }
    
    //
    // Function in charge of displaying the weather information of a day
    //
    func displayWeatherInformation() {
        let id = getCurrentId()
        
        // Setting the information on the display
        self.cityLabel.text = self.responseData?.city?.name
        self.temperatureLabel.text = "\((self.responseData?.list[id].main?.temperature)!) ºC"
        self.weatherLabel.text = self.responseData?.list[id].weather.first?.main
        self.dayLabel.text = self.days[self.currentItem]
        
        // Changing the animation view
        changeAsyncAnimationView(animation: self.getWeatherAnimation(weather: weatherLabel!.text!))
    }
    
    //
    // Function in charge of getting the ID of the current item
    //
    func getCurrentId() -> Int {
        var i: Int = 0
        var flag: Bool = false
        let len = 10
        
        while flag == false {
            if self.days[self.currentItem] == String((self.responseData?.list[i].dateTimeCalculation)!.prefix(len)) {
                flag = true
            } else {
                i += 1
            }
        }
        
        return i
    }
    
    //
    // Function in charge of getting the weather animation
    //
    func getWeatherAnimation(weather: String) -> String {
        switch weather {
            case "Clear":
                return "4804-weather-sunny"

            case "Clouds":
                return "4800-weather-partly-cloudy"
            
            case "Rain":
                return "4803-weather-storm"
            
            case "Snow":
                return "4793-weather-snow"
            
            case "Sunny":
                return "4804-weather-sunny"
            
            default:
                return "4975-question-mark"
        }
    }
    
    //
    // Function in charge of clearing the text field for the city search
    //
    func clearCityTextField() {
        cityTextField.text = ""
    }
    
    //
    // Function in charge of clearing the weather interface
    //
    func clearWeatherInterface() {
        clearCityTextField()
        cityLabel.text = ""
        temperatureLabel.text = ""
        weatherLabel.text = ""
        dayLabel.text = ""
        currentDayPageControl.isHidden = true
    }
    
    //
    // Function in charge of delegating the animation view change to the dispatch queue
    //
    func changeAsyncAnimationView(animation: String) {
        if workItem?.isCancelled == false {
            // Cancelling the previous task
            workItem?.cancel()
        }
        
        // Sending to the dispatch queue the task of changing the animation
        workItem = DispatchWorkItem(block: {
            self.setAnimation(animation: animation)
        })
        
        // Activating the task in the dispatch queue
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem!)
    }
    
    //
    // Function in charge of setting the animation path to the animation view
    //
    func setAnimation(animation: String) {
        if animationView == nil {
            animationView! = AnimationView()
        }
        
        animationView!.animation = Animation.named(animation)
        startAnimation()
    }

    //
    // Function in charge of starting the animation of the animation view
    //
    func startAnimation() {
        animationView!.loopMode = .loop
        animationView!.play()
    }

    //
    // Function in charge of stopping the animation of the animation view
    //
    func stopAnimation() {
        animationView!.stop()
    }
    
    //
    // Function in charge of saving the persistant data
    //
    func saveToLocal() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(previousSearch!.latitude, forKey: "previousSearchLat")
        userDefaults.set(previousSearch!.longitude, forKey: "previousSearchLon")
        userDefaults.synchronize()
    }
    
    //
    // Function in charge of getting the persistant data
    //
    func getFromLocal() {
        let userDefaults = UserDefaults.standard
        if let previousSearchLat = userDefaults.object(forKey: "previousSearchLat") as? Double {
            if let previousSearchLon = userDefaults.object(forKey: "previousSearchLon") as? Double {
                previousSearch = PreviousSearch(latitude: previousSearchLat, longitude: previousSearchLon)
            }
        }
    }
}

//
// Extension of the class ViewController
//
extension ViewController: CLLocationManagerDelegate {
    //
    // Function in charge of getting the current location search result
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 { return }
        
        let location = locations.first!
    }
    
    //
    // Function in charge of notifying the error during the current location search
    //
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did failed with error: \(error.localizedDescription)")
    }
}

// Struct for the previous search
struct PreviousSearch {
    var latitude: Double
    var longitude: Double
}
