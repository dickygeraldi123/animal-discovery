//
//  UIKit+Ext.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit
import Kingfisher

var associateObjectValue: Int = 0

func startShimmeringAnimation(_ parentView: UIView!, _ arrayOfSpesificView: [UIView]? = nil) {
    startShimmeringAnimation(parentView, arrayOfSpesificView, duration: 1.5)
}

func startShimmeringAnimation(_ parentView: UIView!, _ arrayOfSpesificView: [UIView]? = nil, duration: CFTimeInterval) {
    let arrayOfView = arrayOfSpesificView ?? getSubViewsForAnimate(parentView)
    for animateView in arrayOfView {
        animateView.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        gradientLayer.frame = animateView.bounds
        animateView.layer.mask = gradientLayer

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = duration
        animation.fromValue = -animateView.frame.size.width
        animation.toValue = animateView.frame.size.width
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "")
    }
}

func stopShimmeringAnimation(_ parentView: UIView!, _ arrayOfSpesificView: [UIView]? = nil) {
    let arrayOfView = arrayOfSpesificView ?? getSubViewsForAnimate(parentView)
    for animateView in arrayOfView {
        animateView.layer.removeAllAnimations()
        animateView.layer.mask = nil
    }
}

func getSubViewsForAnimate(_ parentView: UIView!) -> [UIView] {
    var obj: [UIView] = []
    for objView in parentView.subviewsRecursive() {
        obj.append(objView)
    }
    return obj.filter({ (obj) -> Bool in
        obj.shimmerAnimation
    })
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }

    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }

    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newTop) {
            var rect = self.frame
            rect.origin.y = newTop
            self.frame = rect
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newBottom) {
            var rect = self.frame
            rect.origin.y = newBottom - rect.size.height
            self.frame = rect
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var rect = self.frame
            rect.size.height = newHeight
            self.frame = rect
        }
    }
}

extension UIImageView {
    func loadImage(
        url: String?,
        indicatorType: IndicatorType = .activity,
        placeholder: UIImage = UIImage(named: "placeholder")!,
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

extension UIColor {
    convenience init(hex: String) {
        let string = hex
        var chars = Array(string.hasPrefix("#") ? "\(string.dropFirst())": string)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 0
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
