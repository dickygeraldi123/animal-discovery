//
//  ImagePhotoGalleryCell.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 18/01/24.
//

import UIKit

class ImagePhotoGalleryCell: UICollectionViewCell {
    @IBOutlet weak var ivImageCollection: UIImageView!

    var urlImage: String! {
        didSet {
            updateImage()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        ivImageCollection.clipsToBounds = true
        ivImageCollection.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        ivImageCollection.image = nil
    }

    private func updateImage() {
        ivImageCollection.loadImage(url: urlImage)
    }
}
