//
//  AirQualityController.swift
//  AirVisualAPI
//
//  Created by Travis Wheeler on 11/19/19.
//  Copyright © 2019 Travis Wheeler. All rights reserved.
//

import Foundation

class AirQualityController {
    // creating a function called getAirQuality that takes in a state and city and completes with a result type. which is either success or failure.
    static func getAirQuality(state: String, city: String, completion: @escaping (Result<AirQualityData, AirQualityAPIError>) -> Void) {
        
        // we unwrap baseURL which equals an optional URL initialized from a string
        guard let baseURL = URL(string: URLConstants.baseURL) else { return completion(.failure(.invalidURL))}
        // declaring cityComponent of type URL by appending cityComponent to the baseURL
        let cityComponentURL = baseURL.appendingPathComponent(URLConstants.cityComponent)
        
        // create a urlComponents variable that allows us to add query items and extract a final URL
        guard var urlComponents = URLComponents(url: cityComponentURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // declaring query constants of type URLQueryItem so that we can assign them to the queryItems array on our urlComponents variable
        let cityQuery = URLQueryItem(name: URLConstants.cityQuery, value: city)
        let stateQuery = URLQueryItem(name: URLConstants.stateQuery, value: state)
        let countryQuery = URLQueryItem(name: URLConstants.countryQuery, value: URLConstants.countryValue)
        let apiKeyQuery = URLQueryItem(name: URLConstants.apiQuery, value: URLConstants.apiKey)
        
        urlComponents.queryItems = [cityQuery, stateQuery, countryQuery, apiKeyQuery]
        
        // creating a finalURL from the urlComponents and queryItems
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print(finalURL)
        //MARK: - Data Tasking
        // defining a dataTask with URL as a parameter and we complete with either data, a response (which we don't need for our app), or an error
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.communicationError))
                return
            }
            guard let data = data else {
                print("Could not fetch data")
                completion(.failure(.noData))
                return
            }
            
            // we are attempting to decode data into a TopLevelDict object using a do/try/catch block (ask Jared how to notate this)
            do {
                let airQualityDataDecoded = try JSONDecoder().decode(TopLevelDict.self, from: data)
                // if successful, complete with our TopLevelDict.data of type AirQualityData
                completion(.success(airQualityDataDecoded.data))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.unableToDecode))
            }
            // above here defines the dataTask.
            // .resume() starts the dataTask
        } .resume()
    }
}

enum AirQualityAPIError: LocalizedError {
    case invalidURL
    case communicationError
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "It looks like the URL is not valid."
        case .communicationError:
            return "Check your wifi"
        case .noData:
            return "The server returned with no data"
        case .unableToDecode:
            return "Make shore you spelld it rite."
        }
    }
}
