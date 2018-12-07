//
//  Network.swift
//  Networking
//
//  Created by Maroof Khan on 07/05/2018.
//  Copyright © 2018 for RapydJobs. All rights reserved.
//

import Foundation

struct Logger {
    
    static func log(request: URLRequest) {
        
        if let header = request.allHTTPHeaderFields {
             print("🌏 header: \(header)")
        }
        if let url = request.url?.absoluteString {
            print("🌏 url: \(url)")
        }
        
        if let body = request.httpBody, let json = try? JSONSerialization.jsonObject(with: body, options: []) {
             print("🌏 body: \(json)")
        }
    }
    
    static func log(response: URLResponse?, error: Error?, data: Data?) {
        if let response = response as? HTTPURLResponse {
            print("🔥 status: \(response.statusCode)")
        }
        
        if let error = error {
             print("🔥 error: \(error)")
        }
        
        if let body = data, let json = try? JSONSerialization.jsonObject(with: body, options: []) {
            print("🔥 body: \(json)")
        }
    }
}

public final class Network {
    public static let shared: Network = .init()
    private let sessionStore: SessionManagerStore
    
    private init(sessionStore: SessionManagerStore = .init()) {
        self.sessionStore = sessionStore
    }
    
    func request<E: EndpointProvider>(_ request: E, completion: @escaping ((Result<E.Response, NetworkError>) -> Void)) {
        
        let endpoint = request.endpoint
        let manager = sessionStore.sessionManager(for: endpoint.api.baseURL)
        
        guard let urlRequest = try? endpoint.modifiedURLRequest() else {
            completion(.failure(.requestCreation))
            return
        }
        
        Logger.log(request: urlRequest)
        
        let task = manager.dataTask(with: urlRequest) { (data, response, error) in
            
            Logger.log(response: response, error: error, data: data)
            
            let result: Result<E.Response, NetworkError>
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode),
                error == nil {
                
                let decoder = JSONDecoder()
                let errorDTO = data != nil ? try? decoder.decode(ErrorDTO.self, from: data!) : nil
                
                if let errorDTO = errorDTO {
                    result = .failure(.error(errorDTO))
                } else if let error = error {
                    result = .failure(.server(error))
                } else {
                    result = .failure(.unknown)
                }
                
            } else if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    let dto = try decoder.decode(E.Response.self, from: data)
                    result = .success(dto)
                    
                } catch let exception {
                    result = .failure(.decoding(data, exception))
                }
            } else {
                result = .failure(.unknown)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
