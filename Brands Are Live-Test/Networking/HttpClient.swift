//
//  HttpClient.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

protocol HttpClientProtocol {
    func fetch(url: URL, completion: @escaping (Result<[String: Any], Error>) -> Void)
}

class HttpClient: HttpClientProtocol {
    // MARK: Properties
    private var urlSession: URLSession

    // MARK: Init
    init(urlsession: URLSession) {
        self.urlSession = urlsession
    }

    // MARK: Public Func
    func fetch(url: URL, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        self.urlSession.dataTask(with: url, completionHandler: { data, response, error in
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(HttpError.badResponse))
                return
            }
            
            if let data = data {
                let strJson = String(decoding: data, as: UTF8.self)
                completion(.success(strJson.convertToDictionary() as? [String: Any] ?? [:]))
            } else {
                completion(.failure(HttpError.badResponse))
            }
        }).resume()
    }
}
