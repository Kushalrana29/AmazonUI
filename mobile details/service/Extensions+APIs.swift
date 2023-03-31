//
//  Extensions+APIs.swift
//  mobile details
//
//  Created by Kushal Rana on 30/03/23.
//

import Foundation

extension URLSession {
    
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { ( data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from:data)
                    completion (.success(object))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            }
        } .resume()
    }
}
