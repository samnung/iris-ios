//
//  API.swift
//  iRIS
//
//  Created by Roman Kříž on 20/11/15.
//  Copyright © 2015 Roman Kříž. All rights reserved.
//

import Foundation

enum ServerResult<T> {
    case Ok(T)
    case Error(ErrorType)
}

enum ServerError: ErrorType {
    case MissingKeyInJson(String, Any)
    case InvalidTypeOfKeyInJson(String, Any)
    case ParsingJson
}


typealias JSONObject = [String: AnyObject]

extension Dictionary where Key: StringLiteralConvertible {
    func get<T>(key: Key) throws -> T {
        guard let rawValue = self[key] else {
            throw ServerError.MissingKeyInJson(key as! String, self)
        }
        
        guard let value = rawValue as? T else {
            throw ServerError.InvalidTypeOfKeyInJson(key as! String, self)
        }
        
        return value
    }
    
    func getOptional<T>(key: Key) -> T? {
        guard let rawValue = self[key] else {
            return nil
        }
        
        guard let value = rawValue as? T else {
            return nil
        }
        
        return value
    }
}


struct DataItem {
    var bear: Float = 0.0
    var course: String? = ""
    var delay: Int = 0
    var endStop: Int = 0
    var endStopX: String? = ""
    var LF: Bool = true
    var lastStop: Int = 0
    var lat: Double = 0
    var line: Int = 0
    var lng: Double = 0
    var operatorId: Int? = 0
    var route: Int = 0
    var startStop: Int = 0
    
    init(id: String, data: JSONObject) throws {
        let bearString: String? = data.getOptional("Bear")
        let bearInt: Int? = data.getOptional("Bear")
        bear = bearString.flatMap { Float($0) } ?? bearInt.flatMap { Float($0) } ?? 0.0
        
        course = data.getOptional("Course")
        delay = try data.get("Delay")
        endStop = try data.get("EndStop")
        endStopX = data.getOptional("EndStopX")
        LF = try data.get("LF")
        lastStop = try data.get("LastStop")
        lat = try data.get("Lat")
        line = try data.get("Line")
        lng = try data.get("Lng")
        operatorId = data.getOptional("Operator")
        route = try data.get("Route")
        startStop = try data.get("StartStop")
    }
}

func downloadAllData(completion: (ServerResult<[DataItem]>) -> ()) {
    let session = NSURLSession.sharedSession()

    let url = NSURL(string: "http://iris.bmhd.cz/api/data.json")!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("http://iris.bmhd.cz/", forHTTPHeaderField: "Referer")

    let task = session.dataTaskWithRequest(request) { data, response, error in
        if let error = error {
            dispatch_async(dispatch_get_main_queue()) {
                completion(.Error(error))
            }
        } else if let data = data {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? JSONObject {
                var items = [DataItem]()

                let innerData = json["Data"] as! JSONObject
                for (key, value) in innerData {
                    if let parsed = try? DataItem(id: key, data: value as! JSONObject) {
                        items.append(parsed)
                    }
                }
                
                let innerData2 = json["DataPlus"] as! JSONObject
                for (key, value) in innerData2 {
                    if let parsed = try? DataItem(id: key, data: value as! JSONObject) {
                        items.append(parsed)
                    }
                }
                
                let newItems = items.filter { $0.line == 702 }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Ok(newItems))
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Error(ServerError.ParsingJson))
                }
            }
        }
    }
    
    task.resume()
}
