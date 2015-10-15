//
//  CommonUtil.swift
//  BeijingAirWatch
//
//  Created by Di Wu on 10/15/15.
//  Copyright © 2015 Beijing Air Watch. All rights reserved.
//

import Foundation

let TIME_OUT_LIMIT: Double = 10.0;

func parseAQI(data: String) -> Int {
    let escapedString: String? = data.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    if let unwrapped = escapedString {
        let arr = unwrapped.componentsSeparatedByString("%20AQI%0D%0A")
        for s in arr {
            let subArr = s.componentsSeparatedByString("%09%09%09%09%09%09%09%09%09")
            if let tmp = subArr.last {
                if Int(tmp) > 1 {
                    return Int(tmp)!
                }
            }
        }
    }
    return -1
}

func parseConcentration(data: String) -> Double {
    let escapedString: String? = data.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    if let unwrapped = escapedString {
        let arr = unwrapped.componentsSeparatedByString("%20%C3%82%C2%B5g%2Fm%C3%82%C2%B3%20%0D%0A%09%09%09%09%09%09%09%09")
        for s in arr {
            let subArr = s.componentsSeparatedByString("%09%09%09%09%09%09%09%09%09")
            if let tmp = subArr.last {
                if Double(tmp) > 1 {
                    return Double(tmp)!
                }
            }
        }
    }
    return -1.0
}

func sharedSessionForIOS() -> NSURLSession {
    let session = NSURLSession.sharedSession()
    session.configuration.timeoutIntervalForRequest = TIME_OUT_LIMIT
    session.configuration.timeoutIntervalForResource = TIME_OUT_LIMIT
    return session
}

func sessionForWatchExtension() -> NSURLSession {
    let session = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    session.configuration.timeoutIntervalForRequest = TIME_OUT_LIMIT
    session.configuration.timeoutIntervalForResource = TIME_OUT_LIMIT
    return session
}

func httpGet(session: NSURLSession?, request: NSURLRequest!, callback: (String, String?) -> Void) {
    let task = session?.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            callback("", error!.localizedDescription)
        } else {
            let result = NSString(data: data!, encoding:
                NSASCIIStringEncoding)!
            callback(result as String, nil)
        }
    }
    task?.resume()
}

func createRequest() -> NSURLRequest {
    return NSMutableURLRequest(URL: NSURL(string: "http://www.stateair.net/web/post/1/1.html")!)
}