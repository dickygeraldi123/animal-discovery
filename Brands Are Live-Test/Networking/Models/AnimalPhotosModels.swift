//
//  AnimalPhotosModels.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

// MARK: - Photo
class AnimalPhotosModels: NSObject {
    var id: Int = 0
    var width: Int = 0
    var height: Int = 0
    var photoUrl: String = ""
    var photographer: String = ""
    var photographerURL: String = ""
    var photographerID: Int = 0
    var avgColor: String = ""
    var src: SrcModels = SrcModels()
    var liked: Bool = false
    var alt: String = ""

    static func createObject(_ dict: [String: Any]) -> AnimalPhotosModels {
        let new: AnimalPhotosModels = AnimalPhotosModels()
        new.id = dict["id"] as? Int ?? 0
        new.width = dict["width"] as? Int ?? 0
        new.height = dict["height"] as? Int ?? 0
        new.photoUrl = dict["url"] as? String ?? ""
        new.photographer = dict["photographer"] as? String ?? ""
        new.photographerURL = dict["photographer_url"] as? String ?? ""
        new.photographerID = dict["photographer_id"] as? Int ?? 0
        new.avgColor = dict["avg_color"] as? String ?? ""
        new.photoUrl = dict["url"] as? String ?? ""
        new.liked = dict["liked"] as? Bool ?? false
        new.src = SrcModels.createObject(dict["src"] as? [String: Any] ?? [:])
        new.alt = dict["alt"] as? String ?? ""

        return new
    }
}

// MARK: - Src
class SrcModels: NSObject {
    var original: String = ""
    var large2X: String = ""
    var large: String = ""
    var medium: String = ""
    var small: String = ""
    var portrait: String = ""
    var landscape: String = ""
    var tiny: String = ""

    static func createObject(_ dict: [String: Any]) -> SrcModels {
        let new: SrcModels = SrcModels()
        new.original = dict["original"] as? String ?? ""
        new.large2X = dict["large2X"] as? String ?? ""
        new.large = dict["large"] as? String ?? ""
        new.medium = dict["medium"] as? String ?? ""
        new.small = dict["small"] as? String ?? ""
        new.portrait = dict["portrait"] as? String ?? ""
        new.landscape = dict["landscape"] as? String ?? ""
        new.tiny = dict["tiny"] as? String ?? ""

        return new
    }
}
