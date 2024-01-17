//
//  FavoriteAnimalView.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit

class FavoriteAnimalView: UIView {
    @IBOutlet weak var ivAnimalImage: UIImageView!
    @IBOutlet weak var lblAnimalName: UILabel!
    @IBOutlet weak var lblAnimalWidthAndLength: UILabel!
    @IBOutlet weak var lblAnimalLocations: UILabel!

    var animalDetailModel: AnimalDetailModels! {
        didSet {
            updateUI()
        }
    }

    class func instanceFromNib() -> FavoriteAnimalView? {
        let views = UINib(nibName: "FavoriteAnimalView", bundle: nil).instantiate(withOwner: nil, options: nil)
        if let view = views.first(where: { (vw) -> Bool in
            return vw is FavoriteAnimalView
        }) as? FavoriteAnimalView {
            return view
        }
        return nil
    }

    func updateUI() {
        if let model = animalDetailModel {
            ivAnimalImage.loadImage(url: model.images.first)
            lblAnimalName.text = model.name
            lblAnimalWidthAndLength.text = "Weight: \(model.characteristics.weight) /n Height: \(model.characteristics.height)"
            lblAnimalLocations.text = model.getAllLocations()
        }
    }
}
