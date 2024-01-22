//
//  AnimalDetailCoordinator.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit

final class AnimalDetailCoordinator {
    private var animalFilter: String?
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController, animalFilter: String) {
        self.navigationController = navigationController
        self.animalFilter = animalFilter
    }
    
    func start() {
        let vm = AnimalDetailViewModel(
            coordinator: self,
            animalFilter: animalFilter ?? "",
            httpClient: AnimalDiscoveryRepository(httpClient: HttpClient())
        )
        let vc = AnimalDetailsViewController(viewModel: vm)

        navigationController?.pushViewController(vc, animated: true)
    }

    func resign() {
        navigationController?.popViewController(animated: true)
    }
}
