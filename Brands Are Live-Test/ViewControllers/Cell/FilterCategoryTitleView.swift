//
//  FilterCategoryTitleView.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class FilterCategoryTitleView: UIView {
    @IBOutlet weak var lblTitleLabel: UILabel!
    @IBOutlet weak var btnFilterClick: UIButton!

    private let disposeBag = DisposeBag()
    var titleCategory: String! {
        didSet {
            updateUI()
        }
    }

    var isFilterActive: Bool! {
        didSet {
            updateState()
        }
    }
    var onClickCategory: ((_ category: String) -> Void)?

    class func instanceFromNib() -> FilterCategoryTitleView? {
        let views = UINib(nibName: "FilterCategoryTitleView", bundle: nil).instantiate(withOwner: nil, options: nil)
        if let view = views.first(where: { (vw) -> Bool in
            return vw is FilterCategoryTitleView
        }) as? FilterCategoryTitleView {
            view.layer.cornerRadius = 10
            view.setupButton()

            return view
        }
        return nil
    }

    func setupButton() {
        btnFilterClick.rx.tap.bind(onNext: { [weak self] in
            if let self = self {
                self.isFilterActive = !self.isFilterActive
                self.onClickCategory?(self.titleCategory)
            }
        }).disposed(by: disposeBag)
    }

    func updateUI() {
        if let titleCategory = titleCategory {
            lblTitleLabel.text = titleCategory
        }
    }

    func updateState() {
        if let isFilterActive = isFilterActive {
            self.backgroundColor = isFilterActive ? UIColor(hex: "80a2fb") : UIColor(hex: "FFFFFF")
            lblTitleLabel.textColor = isFilterActive ? UIColor(hex: "FFFFFF") : UIColor(hex: "000000")

            self.layer.borderWidth = isFilterActive ? 0 : 1
            self.layer.borderColor = isFilterActive ? UIColor.clear.cgColor : UIColor(hex: "F5F5F5").cgColor
        }
    }
}
