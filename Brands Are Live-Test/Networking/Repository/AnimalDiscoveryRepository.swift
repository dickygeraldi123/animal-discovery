//
//  AnimalDiscoveryRepository.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

class AnimalDiscoveryRepository {
    private var httpClient: HttpClientProtocol

    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }

    func getDetailAnimal(animal: String, completion: @escaping (Result<String, Error>) -> Void) {
        let partUrl: String = "?name=\(animal)"
        guard let url = URL(string: apiNinjaBaseUrl + ListUrls.GET_ANIMAL + partUrl) else {
            completion(.failure(HttpError.badURL))
            return
        }

        httpClient.fetchToUrlNinjas(url: url, completion: { resp in
            completion(resp)
        })
    }

    func getAnimalPhotos(animal: String, completion: @escaping (Result<String, Error>) -> Void) {
        let partUrl: String = "?query=\(animal)&per_page=50"
        guard let url = URL(string: apiPexelsBaseUrl + ListUrls.GET_PHOTO_DETAIL + partUrl) else {
            completion(.failure(HttpError.badURL))
            return
        }

        httpClient.fetchToUrlPexels(url: url, completion: { resp in
            completion(resp)
        })
    }
}
