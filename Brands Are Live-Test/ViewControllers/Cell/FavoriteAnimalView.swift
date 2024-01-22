//
//  FavoriteAnimalView.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteAnimalView: UIView {
    @IBOutlet weak var ivAnimalImage: UIImageView!
    @IBOutlet weak var lblAnimalName: UILabel!
    @IBOutlet weak var lblAnimalWidthAndLength: UILabel!
    @IBOutlet weak var lblAnimalLocations: UILabel!
    @IBOutlet weak var btnClickView: UIButton!

    private let disposeBag = DisposeBag()
    var onClickFavoriteAnimal: (() -> Void)?

    var animalDetailModel: FavoriteAnimalDataModel! {
        didSet {
            updateUI()
        }
    }

    class func instanceFromNib() -> FavoriteAnimalView? {
        let views = UINib(nibName: "FavoriteAnimalView", bundle: nil).instantiate(withOwner: nil, options: nil)
        if let view = views.first(where: { (vw) -> Bool in
            return vw is FavoriteAnimalView
        }) as? FavoriteAnimalView {
            view.setupBtn()
            return view
        }
        return nil
    }

    func setupBtn() {
        btnClickView.rx.tap.bind(onNext: { [weak self] in
            if let self = self {
                self.onClickFavoriteAnimal?()
            }
        }).disposed(by: disposeBag)
    }

    func updateUI() {
        if let model = animalDetailModel {
            ivAnimalImage.loadImage(url: model.imageUrl)
            lblAnimalName.text = model.animalName
            lblAnimalWidthAndLength.text = "Weight: \(model.weight ?? "Unknown")\nHeight: \(model.height ?? "Unknown")"
            lblAnimalLocations.text = model.locations
        }
    }
}
