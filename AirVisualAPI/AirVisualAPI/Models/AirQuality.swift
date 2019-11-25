//
//  AirQuality.swift
//  AirVisualAPI
//
//  Created by Travis Wheeler on 11/19/19.
//  Copyright © 2019 Travis Wheeler. All rights reserved.
//

import Foundation

struct TopLevelDict: Codable {
    var status: String
    var data: AirQualityData
}

struct AirQualityData: Codable {
    var city: String
    var state: String
    var country: String
    //   var location: LocationData
    var current: Current
}

//struct LocationData: Codable {
//    var type: String
//   // var coordinates: [Double]
//}

struct Current: Codable {
    var weather: Weather
    //    var pollution: Pollution
}

struct Weather: Codable {
    var ts: String // timestamp
    var tp: Int    // temperature in Celsius
    var pr: Int    // atmospheric pressure in hPa
    var hu: Int    // humidity %
    var ws: Double // wind speed
    //    var wd: Int    // wind direction
    var ic: String // weather icon code
}

//struct Pollution: Codable {
//    var ts: String     // timestamp
//    var aqius: Int     // AQI value based on US EPA standard
//    var mainus: String // main pollutant for US AQI
//}
