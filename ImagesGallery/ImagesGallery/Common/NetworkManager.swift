//
//  NetworkManager.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 17.03.24.
//

import Foundation

final class NetworkManager {
    static var shared = NetworkManager()
    
    func requestData<T: Codable>(toEndPoint: String, clientID: String, httpMethod: HttpMethod) async throws -> T {
        guard let requestUrl = URL(string: toEndPoint) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.setValue(
            clientID,
            forHTTPHeaderField: HttpHeaders.authorization.rawValue
        )
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let resultData = try decoder.decode(T.self, from: data)
        return resultData
    }
    
    func requestImageData(from urlString: String, httpMethod: HttpMethod) async throws -> Data {
        guard let requestUrl = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
                
        return data
    }
}

enum HttpMethod: String {
    case get = "GET"
}

enum HttpHeaders: String {
    case authorization = "Authorization"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
}
