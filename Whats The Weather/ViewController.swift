//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Calvin Cheng on 28/2/15.
//  Copyright (c) 2015 Hello HQ Pte Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userCity: UITextField!
    
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var userCityName = ""
        
        if userCity.text.isEmpty {
            
            showError()
        
        } else {
        
            userCityName = userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
            
        }
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCityName  + "/forecasts/latest")
        
        if url != nil {
            
            var urlError = false
            
            var weather = ""
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
                
                if error == nil {
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    //print(urlContent)
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    print(urlContentArray.count)
                    if urlContentArray.count > 1 {
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        weather = weatherArray[0] as String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                    }
                } else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    println("calling main thread")
                    if urlError == true || weather.isEmpty {
                        self.showError()
                    } else {
                        self.resultLabel.text = weather
                    }
                })
                
            } // end task definition
            
            task.resume()
            println("task started")
            
        } else {
            
            showError()
            
        }
        
    }
    
    func showError() {
        println("show error " + userCity.text)
        resultLabel.text = "Was not able to find weather for " + userCity.text +  ". Please try again."
    }
    
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.numberOfLines = 0


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

