//
//  LocationClient.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 31/03/2024.
//https://www.youtube.com/watch?v=gWtipirALjI&ab_channel=azamsharp
//create one generic client, instead of loads^

import Foundation


struct LocationClient {
    
    static let shared = LocationClient()
    private init() { }
    
    private enum LocClientError: Error {
        case invalidResponse
        case decodingError(Error)
    }
    
    func fetchLocations(at url: URL) async throws -> [Location] {
        let (data, response) = try await URLSession.shared.data(from:url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw LocClientError.invalidResponse
        }
        do {
            return try JSONDecoder().decode([Location].self, from:data)
        } catch {
            throw LocClientError.decodingError(error)
        }
        //return[]
    }

}
