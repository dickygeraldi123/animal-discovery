//
//  UIKit+Ext.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(
        url: String?,
        indicatorType: IndicatorType = .activity,
        placeholder: UIImage = UIImage(),
        onSuccess: ((_ image: UIImage) -> Void)? = nil,
        onFailure: ((_ error: KingfisherError) -> Void)? = nil
    ) {
        let imageUrl = URL(string: url ?? "")

        self.kf.indicatorType = indicatorType
        self.kf.setImage(
            with: imageUrl,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.none),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success(let value):
                    onSuccess?(value.image)
                case .failure(let error):
                    onFailure?(error)
                }
        })
    }
}
