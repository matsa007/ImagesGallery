//
//  NetworkServiceProtocol.swift
//  ImagesGallery
//
//  Created by Сергей Матвеенко on 26.03.24.
//

import Foundation

protocol NetworkServiceProtocol {
    func requestData<T: Codable>(toEndPoint: String, clientID: String, httpMethod: HttpMethod) async throws -> T
    func requestImageData(from urlString: String, httpMethod: HttpMethod) async throws -> Data
}
