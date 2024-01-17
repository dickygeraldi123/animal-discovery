//
//  HomeDiscoveryViewController.swift
//  Brands Are Live-Test
//
//  Created by Dicky Geraldi on 16/01/24.
//

import UIKit

class HomeDiscoveryViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var svFavoriteContent: UIStackView!
    @IBOutlet weak var emptyView: UIView!
    
    var centerCell: AnimalImageCollectionViewCell?
    let cellScale: CGFloat = 0.4
    var arrayOfAnimals: [AnimalDetailModels] = [
        AnimalDetailModels.createObject(["name": "Elephant", "images": ["https://images.pexels.com/photos/6551925/pexels-photo-6551925.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Lion", "images": ["https://images.pexels.com/photos/4032590/pexels-photo-4032590.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Fox", "images": ["https://images.pexels.com/photos/918595/pexels-photo-918595.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Dog", "images": ["https://images.pexels.com/photos/220938/pexels-photo-220938.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Shark", "images": ["https://images.pexels.com/photos/6970122/pexels-photo-6970122.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Turtle", "images": ["https://images.pexels.com/photos/2765872/pexels-photo-2765872.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Whale", "images": ["https://images.pexels.com/photos/4666751/pexels-photo-4666751.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]]),
        AnimalDetailModels.createObject(["name": "Penguin", "images": ["https://images.pexels.com/photos/689777/pexels-photo-689777.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"]])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        imageCollectionView.scrollToItem(at: IndexPath(item: 100/2, section: 0), at: .centeredHorizontally, animated: true)
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
}

// MARK: - Collection View Delegate and Data Source
extension HomeDiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalImageCollectionViewCell", for: indexPath) as? AnimalImageCollectionViewCell else {
            fatalError("Unable to dequeue a cell with identifier YourCellIdentifier")
        }
        
        cell.prepareForReuse()
        cell.animalModel = arrayOfAnimals[indexPath.item % arrayOfAnimals.count]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
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
