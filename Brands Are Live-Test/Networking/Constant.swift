//
//  Constant.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

var apiNinjaBaseUrl: String = {
    return "https://api.api-ninjas.com/"
}()

var apiPexelsBaseUrl: String = {
    return "https://api.pexels.com/"
}()

struct ListUrls {
    static let GET_ANIMAL = "v1/animals"
    static let GET_PHOTO_DETAIL = "v1/search"
}
