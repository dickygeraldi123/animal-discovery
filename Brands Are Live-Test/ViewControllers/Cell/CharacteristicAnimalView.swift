//
//  CharacteristicAnimalView.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit

class CharacteristicAnimalView: UIView {
    @IBOutlet weak var lblAnimalCharacteristicTitle: UILabel!
    @IBOutlet weak var lblCharacteristicDetail: UILabel!

    var animalCharacteristic: (String, String)! {
        didSet {
            updateUI()
        }
    }

    class func instanceFromNib() -> CharacteristicAnimalView? {
        let views = UINib(nibName: "CharacteristicAnimalView", bundle: nil).instantiate(withOwner: nil, options: nil)
        if let view = views.first(where: { (vw) -> Bool in
            return vw is CharacteristicAnimalView
        }) as? CharacteristicAnimalView {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(hex: "000000").cgColor
            view.layer.cornerRadius = 10
            return view
        }
        return nil
    }

    func updateUI() {
        if let data = animalCharacteristic {
            lblAnimalCharacteristicTitle.text = data.0
            lblCharacteristicDetail.text = data.1
        }
    }
}
