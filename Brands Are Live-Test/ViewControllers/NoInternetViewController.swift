//
//  NoInternetViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 20/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class NoInternetViewController: UIViewController {

    @IBOutlet weak var btnCheckConnection: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
    }

    private func setupButton() {
        btnCheckConnection.rx.tap.bind(onNext: { [weak self] in
            if let self = self {
                self.navigationController?.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
    }
}
