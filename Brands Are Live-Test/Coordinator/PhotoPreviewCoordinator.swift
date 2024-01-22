//
//  PhotoPreviewCoordinator.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 22/01/24.
//

import UIKit

final class PhotoPreviewCoordinator {
    private var listOfUrlImages: [AnimalPhotosModels]
    private var indexClick: Int
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, listOfUrlImages: [AnimalPhotosModels], indexClick: Int) {
        self.navigationController = navigationController
        self.indexClick = indexClick
        self.listOfUrlImages = listOfUrlImages
    }
    
    func start() {
        let vm = PhotoPreviewViewModel(coordinator: self, listImages: listOfUrlImages, indexClick: indexClick)
        let vc = PhotoPreviewViewController(viewModel: vm)

        navigationController?.pushViewController(vc, animated: true)
    }

    func resign() {
        navigationController?.popViewController(animated: true)
    }
}
