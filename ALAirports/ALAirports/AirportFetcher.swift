//
//  AirportFetcher.swift
//  ALAirports
//
//  Created by Steve Huey on 3/23/17.
//  Copyright © 2017 Art and Logic. All rights reserved.
//

import Foundation

import Apollo

@objc class AirportFetcher : NSObject
{
   let apollo = ApolloClient(url: URL(string: "https://api.graph.cool/simple/v1/cj0ijwus6z61t0122ffhroqbj")!)
   
   public func allAirports()
   {
      apollo.fetch(query: AllAirportsQuery()) { (result, error) in
         guard let data = result?.data else {
            print("There wasn't any data…")
            return
         }
         
         var allAirports = [[String: String]]()
         
         for airport in data.allAirports
         {
            var result = [String: String]()
            
            result["airportId"] = String(airport.airportId!)
            result["identifier"] = airport.identifier!
            result["airportType"] = airport.airportType!
            result["name"] = airport.name!
            result["elevation"] = String(describing: airport.elevation)
            result["isoCountry"] = String(describing: airport.isoCountry!)
            result["isoRegion"] = String(describing: airport.isoRegion!)
            result["municipality"] = String(describing: airport.municipality!)
            result["gpsCode"] = String(describing: airport.gpsCode!)
            result["iataCode"] = String(describing: airport.iataCode!)
            result["localCode"] = String(describing: airport.localCode!)
            result["homepageUrl"] = String(describing: airport.homepageUrl!)
            result["wikipedialUrl"] = String(describing: airport.wikipediaUrl!)
            result["scheduledService"] = String(describing: airport.scheduledService)
            result["latitude"] = String(describing: airport.latitude!)
            result["longitude"] = String(describing: airport.longitude!)
            
            allAirports.append(result)
         }
         
         NotificationCenter.default.post(name: Notification.Name("DidFetchAllAirports"),
                                         object: allAirports)
      }
   }
}
