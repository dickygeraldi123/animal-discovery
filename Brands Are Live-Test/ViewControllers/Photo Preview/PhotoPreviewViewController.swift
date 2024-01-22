//
//  PhotoPreviewViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 22/01/24.
//

import UIKit
import Lightbox
import RxSwift
import RxCocoa

class PhotoPreviewViewController: BaseViewController {
    // MARK: - All Properties
    var viewModel: PhotoPreviewViewModel

    private let disposeBag = DisposeBag()

    init(viewModel: PhotoPreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        observeViewModel()
        viewModel.viewLoaded()
    }
}

// MARK: - Observe ViewModel
extension PhotoPreviewViewController {
    private func observeViewModel() {
        viewModel.arrayOfSlideImages.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.updateUI()
            }
        }).disposed(by: disposeBag)
    }

    private func updateUI() {
        let controller = LightboxController(images: viewModel.arrayOfSlideImages.value)
        controller.goTo(viewModel.indexClick)
        controller.dismissalDelegate = self
        controller.dynamicBackground = true

        addChild(controller)
        view.addSubview(controller.view)
        view.sendSubviewToBack(controller.view)
    }
}

extension PhotoPreviewViewController: LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        viewModel.onCloseButtonTap.onNext("")
    }
}
