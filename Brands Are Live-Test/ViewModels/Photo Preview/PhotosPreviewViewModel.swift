//
//  PhotoPreviewViewModel.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 22/01/24.
//

import Foundation
import Lightbox
import RxSwift
import RxCocoa

final class PhotoPreviewViewModel {
    var coordinator: PhotoPreviewCoordinator
    var arrayOfImages: [AnimalPhotosModels]
    var indexClick: Int

    var arrayOfSlideImages = BehaviorRelay<[LightboxImage]>(value: [])
    var onCloseButtonTap = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    init(coordinator: PhotoPreviewCoordinator, listImages: [AnimalPhotosModels], indexClick: Int) {
        self.coordinator = coordinator
        self.arrayOfImages = listImages
        self.indexClick = indexClick
    }

    func viewLoaded() {
        self.fetchSlideImage()

        observeSelf()
    }

    private func observeSelf() {
        onCloseButtonTap.subscribe { [weak self] _ in
            if let self = self {
                self.coordinator.resign()
            }
        }.disposed(by: disposeBag)
    }

    private func fetchSlideImage() {
        var result: [LightboxImage] = []
        for (idx, arrayOfImage) in arrayOfImages.enumerated() {
            if idx == indexClick {
                result.insert(
                    LightboxImage(
                        imageURL: URL(string: arrayOfImage.src.original)!,
                        text: arrayOfImage.alt
                    ), at: 0)
            } else {
                result.append(LightboxImage(
                    imageURL: URL(string: arrayOfImage.src.original)!,
                    text: arrayOfImage.alt
                ))
            }
        }

        arrayOfSlideImages.accept(result)
    }
}
