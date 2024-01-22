//
//  HomeDiscoveryViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeDiscoveryViewController: BaseViewController {

    // MARK: - All Properties
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var svFavoriteContent: UIStackView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var svFilterContent: UIStackView!
    
    private let disposeBag = DisposeBag()
    private var centerCell: AnimalImageCollectionViewCell?
    private let cellScale: CGFloat = 0.4
    private var isFirst: Bool = true

    var viewModel: HomeDiscoveryViewModels

    init(viewModel: HomeDiscoveryViewModels) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        observeViewModel()

        viewModel.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        if !isFirst {
            viewModel.fetchFavoriteAnimals()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        if isFirst {
            imageCollectionView.scrollToItem(at: IndexPath(item: 100/2, section: 0), at: .centeredHorizontally, animated: true)
            isFirst = false
        }
    }
}

// MARK: - Observe ViewModel
extension HomeDiscoveryViewController {
    private func observeViewModel() {
        viewModel.arrayOfAnimalCharacters.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            self.imageCollectionView.reloadData()
        }).disposed(by: disposeBag)

        viewModel.arrayOfAnimalFilter.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            self.updateFilterView()
        }).disposed(by: disposeBag)

        viewModel.arrayOfFavoriteAnimals.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }

            self.updateFavoriteAnimals()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UI Helper
extension HomeDiscoveryViewController {
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "AnimalImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AnimalImageCollectionViewCell")
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor((screenSize.width) * cellScale)
        let cellHeight = floor((screenSize.height) * cellScale)
        let insetX = (view.bounds.width - cellWidth) / 2.0

        collectionViewFlowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }

    private func updateFilterView() {
        let arrayOfFilter = viewModel.arrayOfAnimalFilter.value

        if !arrayOfFilter.isEmpty {
            for filter in arrayOfFilter {
                if let vw = FilterCategoryTitleView.instanceFromNib() {
                    vw.titleCategory = filter
                    vw.isFilterActive = false
                    vw.onClickCategory = { [weak self] category in
                        if let self = self {
                            self.viewModel.getFavoriteByCat(category)
                        }
                    }
                    svFilterContent.addArrangedSubview(vw)
                }
            }
        }
    }

    private func updateFavoriteAnimals() {
        let arrayOfFavoriteAnimals = viewModel.arrayOfFavoriteAnimals.value
        svFavoriteContent.removeAllSubviews()
        emptyView.isHidden = !arrayOfFavoriteAnimals.isEmpty
        svFavoriteContent.isHidden = arrayOfFavoriteAnimals.isEmpty

        if !arrayOfFavoriteAnimals.isEmpty {
            for animal in arrayOfFavoriteAnimals {
                if let vw = FavoriteAnimalView.instanceFromNib() {
                    vw.onClickFavoriteAnimal = { [weak self] in
                        if let self = self {
                            self.viewModel.didSelectFavoriteAnimals.onNext(animal)
                        }
                    }
                    vw.animalDetailModel = animal
                    svFavoriteContent.addArrangedSubview(vw)
                }
            }
        }
    }
}

// MARK: - Collection View Delegate and Data Source
extension HomeDiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalImageCollectionViewCell", for: indexPath) as? AnimalImageCollectionViewCell else {
            fatalError("Unable to dequeue a cell with identifier YourCellIdentifier")
        }
        
        cell.prepareForReuse()
        cell.animalModel = viewModel.arrayOfAnimalCharacters.value[indexPath.item % viewModel.arrayOfAnimalCharacters.value.count]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = viewModel.arrayOfAnimalCharacters.value[indexPath.item % viewModel.arrayOfAnimalCharacters.value.count]
        viewModel.didSelectAnimals.onNext(vm)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = collectionViewFlowLayout.itemSize.width + collectionViewFlowLayout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {return}
        
        let centerPoint = CGPoint(x: imageCollectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: imageCollectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = imageCollectionView.indexPathForItem(at: centerPoint) {
            self.centerCell = (imageCollectionView.cellForItem(at: indexPath) as? AnimalImageCollectionViewCell)
            self.centerCell?.transformToLarge()
        }
        
        if let cell = self.centerCell {
            let offsetX = centerPoint.x - cell.center.x
            if offsetX < -40 || offsetX > 40 {
                cell.transformToStandard()
                centerCell = nil
            }
        }
    }
}
