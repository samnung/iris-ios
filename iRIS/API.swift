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
    case InvalidKeyInJson(String)
    case ParsingJson
}


typealias JSONObject = [String: AnyObject]

extension Dictionary where Key: StringLiteralConvertible {
    func get<T>(key: Key) throws -> T {
        if let value = self[key] as? T {
            return value
        } else {
            throw ServerError.InvalidKeyInJson(key as! String)
        }
    }
}


struct DataItem {
    var bear: Float = 0.0
    var course: String = ""
    var delay: Int = 0
    var endStop: Int = 0
    var endStopX: String = ""
    var LF: Bool = true
    var lastStop: Int = 0
    var lat: Double = 0
    var line: Int = 0
    var lng: Double = 0
    var operatorId: Int = 0
    var route: Int = 0
    var startStop: Int = 0
    
    init(id: String, data: JSONObject) throws {
        let bearString: String = try data.get("Bear")
        bear = Float(bearString)!
        course = try data.get("Course")
        delay = try data.get("Delay")
        endStop = try data.get("EndStop")
        endStopX = try data.get("EndStopX")
        LF = try data.get("LF")
        lastStop = try data.get("LastStop")
        lat = try data.get("Lat")
        line = try data.get("Line")
        lng = try data.get("Lng")
        operatorId = try data.get("Operator")
        route = try data.get("Route")
        startStop = try data.get("StartStop")
    }
}

func downloadAllData(completion: (ServerResult<[DataItem]>) -> ()) {
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    let url = NSURL(string: "http://iris.bmhd.cz/api/data.json")!
    let request = NSMutableURLRequest(URL: url)
    request.addValue("http://iris.bmhd.cz/", forHTTPHeaderField: "Referer")

    let task = session.dataTaskWithRequest(request) { data, response, error in
        if let error = error {
            completion(.Error(error))
        } else if let data = data {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? JSONObject {
                var items = [DataItem]()

                let innerData = json["Data"] as! JSONObject
                for (key, value) in innerData {
                    if let parsed = try? DataItem(id: key, data: value as! JSONObject) {
                        items.append(parsed)
                    }
                }
                
                completion(.Ok(items))
            } else {
                completion(.Error(ServerError.ParsingJson))
            }
        }
    }
    
    task.resume()
}
