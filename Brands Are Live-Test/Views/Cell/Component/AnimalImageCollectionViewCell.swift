//
//  AnimalImageCollectionViewCell.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit

class AnimalImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivAnimalImage: UIImageView!
    @IBOutlet weak var lblAnimalName: UILabel!
    @IBOutlet weak var vwContentBackground: UIView!
    
    var animalModel: AnimalDetailModels! {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 10
        ivAnimalImage.layer.cornerRadius = 10
        vwContentBackground.layer.cornerRadius = 10
    }

    func updateUI() {
        if let model = animalModel {
            lblAnimalName.text = model.name
            ivAnimalImage.loadImage(url: model.images.first)
        }
    }

    func transformToLarge(){
        UIView.animate(withDuration: 0.2){
            self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        }
    }
    
    func transformToStandard(){
        UIView.animate(withDuration: 0.2){
            self.transform = CGAffineTransform.identity
        }
    }
}
