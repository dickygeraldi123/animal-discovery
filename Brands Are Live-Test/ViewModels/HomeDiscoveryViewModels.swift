//
//  HomeDiscoveryViewModels.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import RxSwift
import RxCocoa

final class HomeDiscoveryViewModels {
    var coordinator: AnimalDiscoveryCoordinator
    var animalDiscoveryRepository: AnimalDiscoveryRepository?
    
    var arrayOfAnimalCharacters = BehaviorRelay<[AnimalDetailModels]>(value: [])
    var arrayOfAnimalFilter = BehaviorRelay<[String]>(value: [])
    var arrayOfFavoriteAnimals = BehaviorRelay<[FavoriteAnimalDataModel]>(value: [])
    var didSelectAnimals = PublishSubject<AnimalDetailModels>()
    var didSelectFavoriteAnimals = PublishSubject<FavoriteAnimalDataModel>()

    var allFavorite: [FavoriteAnimalDataModel] = []
    var animalFilter: [String] = []
    private let disposeBag = DisposeBag()
    
    init(coordinator: AnimalDiscoveryCoordinator) {
        self.coordinator = coordinator
        
        self.observeSelf()
    }
    
    func viewLoaded() {
        self.fetchFilterAnimal()
        self.fetchAnimalCharacters()
        self.fetchFavoriteAnimals()
    }
    
    private func observeSelf() {
        didSelectAnimals.subscribe { [weak self] data in
            if let self = self {
                self.goToDetailAnimal(data: data.element?.name ?? "")
            }
        }.disposed(by: disposeBag)

        didSelectFavoriteAnimals.subscribe { [weak self] data in
            if let self = self {
                self.goToDetailAnimal(data: data.element?.animalName ?? "")
            }
        }.disposed(by: disposeBag)
    }

    private func fetchFilterAnimal() {
        arrayOfAnimalFilter.accept([
            "Elephant", "Lion", "Fox", "Dog", "Shark", "Turtle", "Whale", "Penguin"
        ])
    }
    
    private func fetchAnimalCharacters() {
        arrayOfAnimalCharacters.accept([
            AnimalDetailModels.createObject(["name": "Elephant", "images": ["https://images.pexels.com/photos/6551925/pexels-photo-6551925.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Lion", "images": ["https://images.pexels.com/photos/4032590/pexels-photo-4032590.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Fox", "images": ["https://images.pexels.com/photos/918595/pexels-photo-918595.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Dog", "images": ["https://images.pexels.com/photos/220938/pexels-photo-220938.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Shark", "images": ["https://images.pexels.com/photos/6970122/pexels-photo-6970122.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Turtle", "images": ["https://images.pexels.com/photos/2765872/pexels-photo-2765872.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Whale", "images": ["https://images.pexels.com/photos/4666751/pexels-photo-4666751.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
            AnimalDetailModels.createObject(["name": "Penguin", "images": ["https://images.pexels.com/photos/689777/pexels-photo-689777.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]])
        ])
    }
    
    func fetchFavoriteAnimals() {
        let favoriteAnimals = Favorites.retrieveData()
        arrayOfFavoriteAnimals.accept(favoriteAnimals)
        allFavorite = favoriteAnimals
    }

    func goToDetailAnimal(data: String) {
        coordinator.showDetailAnimals(animalName: data)
    }

    func getFavoriteByCat(_ filter: String) {
        shouldAddFilter(filter)
        var tempData: [FavoriteAnimalDataModel] = []

        if animalFilter.isEmpty {
            tempData = allFavorite
        } else {
            for datum in allFavorite {
                if let type = datum.animalType {
                    if animalFilter.contains(type) {
                        tempData.append(datum)
                    }
                }
            }
        }
        arrayOfFavoriteAnimals.accept(tempData)
    }

    private func shouldAddFilter(_ filter: String) {
        if animalFilter.contains(filter) {
            animalFilter = animalFilter.filter({ $0 != filter })
        } else {
            animalFilter.append(filter)
        }
    }
}
