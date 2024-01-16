//
//  AnimalDetailModels.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import Foundation

class AnimalDetailModels: NSObject {
    var name: String = ""
    var taxonomy: TaxonomyModels = TaxonomyModels()
    var animalLocations: [String] = []
    var characteristics: CharacteristicsModels = CharacteristicsModels()

    static func createObject(_ dict: [String: Any]) -> AnimalDetailModels {
        let new: AnimalDetailModels = AnimalDetailModels()
        new.name = dict["name"] as? String ?? ""
        new.taxonomy = TaxonomyModels.createObject(dict["taxonomy"] as? [String: Any] ?? [:])
        new.animalLocations = dict["locations"] as? [String] ?? []
        new.characteristics = CharacteristicsModels.createObject(dict["characteristics"] as? [String: Any] ?? [:])

        return new
    }
}

// MARK: - Characteristics
class CharacteristicsModels: NSObject {
    var prey: String = ""
    var nameOfYoung: String = ""
    var groupBehavior: String = ""
    var estimatedPopulationSize: String = ""
    var biggestThreat: String = ""
    var mostDistinctiveFeature: String = ""
    var wingspan: String = ""
    var incubationPeriod: String = ""
    var ageOfFledgling: String = ""
    var habitat: String = ""
    var predators: String = ""
    var diet: String = ""
    var lifestyle: String = ""
    var commonName: String = ""
    var numberOfSpecies: String = ""
    var location: String = ""
    var averageClutchSize: String = ""
    var slogan: String = ""
    var group: String = ""
    var skinType: String = ""
    var topSpeed: String = ""
    var lifespan: String = ""
    var weight: String = ""
    var height: String = ""
    var ageOfSexualMaturity: String = ""

    static func createObject(_ dict: [String: Any]) -> CharacteristicsModels {
        let new: CharacteristicsModels = CharacteristicsModels()
        new.prey = dict["prey"] as? String ?? ""
        new.nameOfYoung = dict["name_of_young"] as? String ?? ""
        new.groupBehavior = dict["group_behavior"] as? String ?? ""
        new.estimatedPopulationSize = dict["estimated_population_size"] as? String ?? ""
        new.biggestThreat = dict["biggest_threat"] as? String ?? ""
        new.mostDistinctiveFeature = dict["most_distinctive_feature"] as? String ?? ""
        new.wingspan = dict["wingspan"] as? String ?? ""
        new.incubationPeriod = dict["incubation_period"] as? String ?? ""
        new.ageOfFledgling = dict["age_of_fledgling"] as? String ?? ""
        new.habitat = dict["habitat"] as? String ?? ""
        new.predators = dict["predators"] as? String ?? ""
        new.diet = dict["diet"] as? String ?? ""
        new.lifestyle = dict["lifestyle"] as? String ?? ""
        new.commonName = dict["common_name"] as? String ?? ""
        new.numberOfSpecies = dict["number_of_species"] as? String ?? ""
        new.location = dict["location"] as? String ?? ""
        new.averageClutchSize = dict["average_clutch_size"] as? String ?? ""
        new.slogan = dict["slogan"] as? String ?? ""
        new.group = dict["group"] as? String ?? ""
        new.skinType = dict["skin_type"] as? String ?? ""
        new.topSpeed = dict["top_speed"] as? String ?? ""
        new.lifespan = dict["lifespan"] as? String ?? ""
        new.weight = dict["weight"] as? String ?? ""
        new.height = dict["height"] as? String ?? ""
        new.ageOfSexualMaturity = dict["age_of_sexual_maturity"] as? String ?? ""

        return new
    }
}

// MARK: - Taxonomy
class TaxonomyModels: NSObject {
    var kingdom: String = ""
    var phylum: String = ""
    var taxonomyClass: String = ""
    var order: String = ""
    var family: String = ""
    var genus: String = ""
    var scientificName: String = ""

    static func createObject(_ dict: [String: Any]) -> TaxonomyModels {
        let new: TaxonomyModels = TaxonomyModels()
        new.kingdom = dict["kingdom"] as? String ?? ""
        new.phylum = dict["phylum"] as? String ?? ""
        new.taxonomyClass = dict["class"] as? String ?? ""
        new.order = dict["order"] as? String ?? ""
        new.family = dict["family"] as? String ?? ""
        new.genus = dict["genus"] as? String ?? ""
        new.scientificName = dict["scientific_name"] as? String ?? ""

        return new
    }
}
