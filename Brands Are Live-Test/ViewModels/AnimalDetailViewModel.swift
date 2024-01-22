//
//  AnimalDetailViewModel.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import RxSwift
import RxCocoa

final class AnimalDetailViewModel {
    private var favoriteAnimals: [FavoriteAnimalDataModel] = []
    var animalFilter: String
    var coordinator: AnimalDetailCoordinator
    var animalDiscoveryRepository: AnimalDiscoveryRepository
    var animalIndexChoose: Int = 0

    var animalNameToGetPhoto: String = ""
    var isProgressIndicatorVisible = BehaviorRelay<Bool>(value: true)
    var updateState = BehaviorRelay<Bool>(value: true)
    var errorHandling = BehaviorRelay<String>(value: "")
    var arrayOfAnimalData = BehaviorRelay<[AnimalDetailModels]>(value: [])
    var arrayOfAnimalPhotos = BehaviorRelay<[AnimalPhotosModels]>(value: [])
    var onCloseButtonTap = PublishSubject<Void>()

    private let disposeBag = DisposeBag()
    
    init(coordinator: AnimalDetailCoordinator, animalFilter: String, httpClient: AnimalDiscoveryRepository) {
        self.coordinator = coordinator
        self.animalFilter = animalFilter
        self.animalDiscoveryRepository = httpClient
    }

    func viewLoaded() {
        fetchAnimalCharacters()
        fetchFavoriteAnimals()

        observeSelf()
    }

    private func observeSelf() {
        onCloseButtonTap.subscribe { [weak self] _ in
            if let self = self {
                self.coordinator.resign()
            }
        }.disposed(by: disposeBag)
    }

    private func fetchFavoriteAnimals() {
        favoriteAnimals = Favorites.retrieveData()
    }

    private func fetchAnimalCharacters() {
        isProgressIndicatorVisible.accept(true)
        animalDiscoveryRepository.getDetailAnimal(animal: animalFilter, completion: { [weak self] response in
            if let self = self {
                switch response {
                case .success(let responseData):
                    if let data = responseData.convertToDictionary() as? [[String: Any]] {
                        var tempAnimalData: [AnimalDetailModels] = []
                        for datum in data {
                            tempAnimalData.append(AnimalDetailModels.createObject(datum))
                        }
                        self.arrayOfAnimalData.accept(tempAnimalData)
                        self.animalNameToGetPhoto = tempAnimalData.first?.name ?? ""
                        self.fetchAnimalPhotos()
                    }
                case .failure(let error):
                    self.errorHandling.accept(error.localizedDescription)
                }
            }
        })
    }

    private func fetchAnimalPhotos() {
        isProgressIndicatorVisible.accept(true)
        animalDiscoveryRepository.getAnimalPhotos(animal: animalNameToGetPhoto, completion: { [weak self] response in
            if let self = self {
                self.isProgressIndicatorVisible.accept(false)
                switch response {
                case .success(let responseData):
                    if let data = responseData.convertToDictionary() as? [String: Any], let photos = data["photos"] as? [[String: Any]] {
                        var tempAnimalPhoto: [AnimalPhotosModels] = []
                        for photo in photos {
                            tempAnimalPhoto.append(AnimalPhotosModels.createObject(photo))
                        }
                        self.arrayOfAnimalPhotos.accept(tempAnimalPhoto)
                    }
                case .failure(let error):
                    self.errorHandling.accept(error.localizedDescription)
                }
            }
        })
    }

    func getAnimalData() -> AnimalDetailModels? {
        if !arrayOfAnimalData.value.isEmpty {
            return arrayOfAnimalData.value[animalIndexChoose]
        }
        return nil
    }

    func addToFavoriteAnimal() {
        if isAnimalLoved() {
            Favorites.deleteData(animalFilter)
            fetchFavoriteAnimals()
        } else {
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"

            let animalNow = getAnimalData()
            var favoriteAnimalData = FavoriteAnimalDataModel()
            favoriteAnimalData.animalType = animalFilter
            favoriteAnimalData.height = animalNow?.characteristics.height
            favoriteAnimalData.imageUrl = arrayOfAnimalPhotos.value[safeIndex: 0]?.src.medium
            favoriteAnimalData.locations = animalNow?.getAllLocations()
            favoriteAnimalData.weight = animalNow?.characteristics.weight
            favoriteAnimalData.createdDate = formatter.string(from: today)
            favoriteAnimalData.id = UUID().uuidString
            favoriteAnimalData.animalName = animalNow?.name
            Favorites.createOrUpdate(item: favoriteAnimalData)
            fetchFavoriteAnimals()
        }
        updateState.accept(true)
    }

    func resetData() {
        animalNameToGetPhoto = getAnimalData()?.name ?? ""
        fetchAnimalPhotos()
        arrayOfAnimalPhotos.accept([])
    }

    func getAnimalCharacteristics() -> [String: String] {
        var resultDic: [String: String] = [:]
        if let animalData = getAnimalData() {
            if !animalData.characteristics.weight.isEmpty {
                resultDic["Weight"] = animalData.characteristics.weight
            }
            if !animalData.characteristics.height.isEmpty {
                resultDic["Height"] = animalData.characteristics.height
            }
            if !animalData.characteristics.habitat.isEmpty {
                resultDic["Habitat"] = animalData.characteristics.habitat
            }
            if !animalData.characteristics.lifespan.isEmpty {
                resultDic["Lifespan"] = animalData.characteristics.lifespan
            }
            if !animalData.characteristics.predators.isEmpty {
                resultDic["Predators"] = animalData.characteristics.predators
            }
        }

        return resultDic
    }

    func getAnimalTaxonomy() -> [String: String] {
        var resultDic: [String: String] = [:]
        if let animalData = getAnimalData() {
            if !animalData.taxonomy.kingdom.isEmpty {
                resultDic["Kingdom"] = animalData.taxonomy.kingdom
            }
            if !animalData.taxonomy.phylum.isEmpty {
                resultDic["Phylum"] = animalData.taxonomy.phylum
            }
            if !animalData.taxonomy.taxonomyClass.isEmpty {
                resultDic["Class"] = animalData.taxonomy.taxonomyClass
            }
            if !animalData.taxonomy.order.isEmpty {
                resultDic["Ordo"] = animalData.taxonomy.order
            }
            if !animalData.taxonomy.family.isEmpty {
                resultDic["Family"] = animalData.taxonomy.family
            }
            if !animalData.taxonomy.genus.isEmpty {
                resultDic["Genus"] = animalData.taxonomy.genus
            }
        }

        return resultDic
    }

    func isAnimalLoved() -> Bool {
        let animalSelected = getAnimalData()
        for animal in favoriteAnimals {
            if animal.animalName == animalSelected?.name {
                return true
            }
        }

        return false
    }
}
