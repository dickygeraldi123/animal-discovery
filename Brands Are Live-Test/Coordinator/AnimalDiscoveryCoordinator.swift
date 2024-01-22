//
//  AnimalDiscoveryCoordinator.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit

final class AnimalDiscoveryCoordinator {
    // MARK: - Properties
    var navigationController: UINavigationController?
    var window: UIWindow?

    // MARK: - Init
    public init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let vm = HomeDiscoveryViewModels(coordinator: self)
        let vc = HomeDiscoveryViewController(viewModel: vm)
        navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        window!.overrideUserInterfaceStyle = .light
        window!.makeKeyAndVisible()
    }

    func showDetailAnimals(animalName: String) {
        guard let nc = navigationController else { return }

        AnimalDetailCoordinator(navigationController: nc, animalFilter: animalName).start()
    }
}
