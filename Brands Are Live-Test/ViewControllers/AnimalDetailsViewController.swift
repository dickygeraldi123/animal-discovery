//
//  AnimalDetailsViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 17/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import CHTCollectionViewWaterfallLayout

class AnimalDetailsViewController: BaseViewController {

    // MARK: - All Properties
    @IBOutlet weak var vwLoading: UIView!
    // Header
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavoriteAnimal: UIButton!
    @IBOutlet weak var ivIsFavoriteAnimal: UIImageView!
    @IBOutlet weak var btnBack1: UIButton!
    @IBOutlet weak var btnFavoriteAnimal1: UIButton!
    @IBOutlet weak var ivIsFavoriteAnimal1: UIImageView!
    @IBOutlet weak var vwNavigation: UIView!

    @IBOutlet weak var ivImageCover: UIImageView!
    @IBOutlet weak var vwArrowUp: UIView!
    @IBOutlet weak var btnArrowToTop: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svAllAnimalContent: UIStackView!
    @IBOutlet weak var lblAnimalName: UILabel!
    @IBOutlet weak var lblAnimalHabitat: UILabel!
    @IBOutlet weak var svAnimalCharacteristic: UIStackView!
    @IBOutlet weak var lblAnimalLocations: UILabel!
    @IBOutlet weak var svAnimalTaxonomy: UIStackView!
    @IBOutlet weak var lblPopulationSize: UILabel!
    @IBOutlet weak var vwImageCollection: UIView!
    @IBOutlet weak var cvImageCollection: UICollectionView!
    @IBOutlet weak var cvImageCollectionFlowLayout: CHTCollectionViewWaterfallLayout!
    @IBOutlet weak var cvImageCollectionHeight: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    var viewModel: AnimalDetailViewModel

    init(viewModel: AnimalDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        setupView()
        observeViewModel()
        viewModel.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.cvImageCollectionHeight.constant = cvImageCollection.contentSize.height
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Observe ViewModel
extension AnimalDetailsViewController {
    private func observeViewModel() {
        viewModel.isProgressIndicatorVisible.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if isLoading {
                    self.vwLoading.isHidden = false
                    self.scrollView.isHidden = true
                    startShimmeringAnimation(self.view, [self.vwLoading])
                } else {
                    self.vwLoading.isHidden = true
                    self.scrollView.isHidden = false
                    stopShimmeringAnimation(self.view, [self.vwLoading])
                }
            }
        }).disposed(by: disposeBag)
    
        viewModel.updateState.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.updateStateFavorite()
            }
        }).disposed(by: disposeBag)

        viewModel.arrayOfAnimalData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.updateUI()
            }
        }).disposed(by: disposeBag)

        viewModel.arrayOfAnimalPhotos.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let imgUrl = self.viewModel.arrayOfAnimalPhotos.value[safeIndex: 0]?.src.original {
                    self.ivImageCover.loadImage(url: imgUrl)
                }
                self.cvImageCollection.reloadData()
            }
        }).disposed(by: disposeBag)
    
        btnArrowToTop.rx.tap.bind(onNext: { [weak self] in
            if let self = self {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }).disposed(by: disposeBag)

        let btnBacks: [UIButton] = [btnBack, btnBack1]
        for btnBack in btnBacks {
            btnBack.rx.tap
                        .bind(to: self.viewModel.onCloseButtonTap)
                        .disposed(by: disposeBag)
        }

        let btnFavorites: [UIButton] = [btnFavoriteAnimal, btnFavoriteAnimal1]
        for btnFavorite in btnFavorites {
            btnFavorite.rx.tap.bind(onNext: { [weak self] in
                if let self = self {
                    self.viewModel.addToFavoriteAnimal()
                }
            }).disposed(by: disposeBag)
        }
    }
}

// MARK: - UIHelper
extension AnimalDetailsViewController {
    private func setupView() {
        vwArrowUp.layer.cornerRadius = 24
        cvImageCollectionFlowLayout.columnCount = 2
        cvImageCollectionFlowLayout.itemRenderDirection = .leftToRight
        cvImageCollection.delegate = self
        cvImageCollection.dataSource = self
        cvImageCollection.register(UINib(nibName: "ImagePhotoGalleryCell", bundle: nil), forCellWithReuseIdentifier: "ImagePhotoGalleryCell")
    }

    private func updateUI() {
        if let model = viewModel.getAnimalData() {
            svAllAnimalContent.removeAllSubviews()
            svAnimalTaxonomy.removeAllSubviews()
            svAnimalCharacteristic.removeAllSubviews()

            lblAnimalName.text = model.name
            lblAnimalHabitat.text = model.characteristics.habitat
            lblPopulationSize.text = model.characteristics.estimatedPopulationSize
            lblAnimalLocations.text = model.getAllLocations()

            for (idx, animal) in viewModel.arrayOfAnimalData.value.enumerated() {
                if let vw = FilterCategoryTitleView.instanceFromNib() {
                    vw.titleCategory = animal.name
                    vw.isFilterActive = (idx == viewModel.animalIndexChoose)
                    vw.onClickCategory = { [weak self] category in
                        if let self = self {
                            if self.viewModel.animalIndexChoose == idx {
                                // do nothing
                            } else {
                                self.viewModel.animalIndexChoose = idx
                                self.viewModel.resetData()
                                self.updateUI()
                            }
                        }
                    }
                    svAllAnimalContent.addArrangedSubview(vw)
                }
            }

            for (key, value) in viewModel.getAnimalCharacteristics() {
                if let vw = CharacteristicAnimalView.instanceFromNib() {
                    vw.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
                    vw.animalCharacteristic = (key, value)
                    svAnimalCharacteristic.addArrangedSubview(vw)
                }
            }

            for (key, value) in viewModel.getAnimalTaxonomy() {
                if let vw = CharacteristicAnimalView.instanceFromNib() {
                    vw.animalCharacteristic = (key, value)
                    svAnimalTaxonomy.addArrangedSubview(vw)
                }
            }

            updateStateFavorite()
        }
    }

    func updateStateFavorite() {
        let favoriteImg: [UIImageView] = [ivIsFavoriteAnimal, ivIsFavoriteAnimal1]
        for favoriteView in favoriteImg {
            favoriteView.image = viewModel.isAnimalLoved() ? UIImage(named: "ic-heart-active") : UIImage(named: "ic-heart-inactive")
        }
    }
}

// MARK: - ScrollView Delegate
extension AnimalDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offsetY = (scrollView.contentOffset.y - 150) - (viewTop.height - vwNavigation.height)
            if offsetY >= 0 {
                vwNavigation.isHidden = false
                vwArrowUp.isHidden = false
            } else {
                vwArrowUp.isHidden = true
                vwNavigation.isHidden = true
            }
        }
    }
}

// MARK: - UICollection View Delegate and Data Source
extension AnimalDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOfAnimalPhotos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePhotoGalleryCell", for: indexPath) as? ImagePhotoGalleryCell else {
            fatalError("Unable to dequeue a cell with identifier YourCellIdentifier")
        }

        cell.prepareForReuse()
        cell.urlImage = viewModel.arrayOfAnimalPhotos.value[indexPath.item].src.medium

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: CGFloat.random(in: 200...500))
    }
}
