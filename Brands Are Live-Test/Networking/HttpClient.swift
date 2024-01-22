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
    func fetchToUrlNinjas(url: URL, completion: @escaping (Result<String, Error>) -> Void)
    func fetchToUrlPexels(url: URL, completion: @escaping (Result<String, Error>) -> Void)
    func fetchApi(url: URLRequest, completion: @escaping (Result<String, Error>) -> Void)
}

class HttpClient: HttpClientProtocol {
    // MARK: Public Func
    func fetchToUrlNinjas(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("pfFQJxLiPMYqvY5rZXbYdw==VBjYVanTRFZdEhx9", forHTTPHeaderField: "X-Api-Key")

        Dlog("REQUEST: \(request.url?.absoluteString ?? "")")
        fetchApi(url: request, completion: completion)
    }

    func fetchToUrlPexels(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("F0RsC7L6viQO7bzFmZTKs7hwGWhXlwm5TjAozyXUwkTmB8INisxbwjVg", forHTTPHeaderField: "Authorization")

        Dlog("REQUEST: \(request.url?.absoluteString ?? "")")
        fetchApi(url: request, completion: completion)
    }

    func fetchApi(url: URLRequest, completion: @escaping (Result<String, Error>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(HttpError.badResponse))
                return
            }

            if let data = data {
                let strJson = String(decoding: data, as: UTF8.self)
                Dlog("RESPONSE: \(strJson)")
                completion(.success(strJson))
            } else {
                completion(.failure(HttpError.badResponse))
            }
        }).resume()
    }
}
