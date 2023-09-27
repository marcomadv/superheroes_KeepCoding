//
//  NetworkModel.swift
//  SuperHeroes
//
//  Created by Marco Muñoz on 19/9/23.
//

import Foundation

final class NetworkModel {
    enum NetworkError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
        
    }
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private var token: String? {
        get {
            if let token = LocalDataModel.getToken(){
                return token
            }
            return nil
        }
        set {
            if let token = newValue {
                LocalDataModel.save(token: token)
            }
        }
    }
    
    private let session : URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
       
        let loginString = String(format: "%@:%@", user, password)  //user:password
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else{
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(token))
            self?.token = token
        }
        task.resume()
    }
    func getHeroes(
        completion: @escaping (Result<[Hero], NetworkError>) -> Void
    ){
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
         guard let token else {
             completion(.failure(.noToken))
         return
         }
         
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        createTask(for: request,
                   using: [Hero].self,
                   completion: completion
        )
    }

    func getTransformations(
        for heroId: String,
        completion: @escaping (Result<[Transformation], NetworkError>) -> Void
    ){
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: heroId)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = urlComponents.query?.data(using: .utf8)
        createTask(for: request,
                   using: [Transformation].self,
                   completion: completion
        )
    }
    // Generics
    func createTask<T: Decodable>(
        for request: URLRequest,
        using type: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result : Result<T, NetworkError>
            
            // el codigo dentro de defer se ejecuta al final del closure, nos aseguramos de inicializar siempre el completion
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            guard let data else {
                result = .failure(.noData)
                return
            }
            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decodingFailed)
                return
            }
            
            result = .success(resource)
        }
        
        task.resume()
    }
}
