//
//  CollectionsViewController.swift
//  XNinety
//
//  Created by John John on 3/16/18.
//  Copyright © 2018 Courtney Osborne. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner


class CollectionViewCell: UICollectionViewCell, UICollectionViewDelegate {
    
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var shoePrice: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
}

extension CollectionsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offSet = targetContentOffset.pointee
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthSpacing
        let roundedIndex = round(index)
        
        offSet = CGPoint(x: roundedIndex * cellWidthSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        targetContentOffset.pointee = offSet
    }
}


class CollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let collectionViewIdentifier = "CollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var shoeProducts : [Product]?
    var shoeId = [String]()
    var shoeName = [String]()
    var shoeUrl = [URL]()
    var shoeImageUrl : URL?
    var shoeImage : UIImage?
    var shoeFileImage : URL?
    var prices = [Int]()
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateUI()
    }
    
    func updateUI() {
        SwiftSpinner.show("loading products")
        Moltin.product.list { (result) in
            
            switch result {
                
            case .failure(error: let error):
                print("error: \(error)")
                
            case .success(result: let productList):
                SwiftSpinner.hide()
                var price = [Int]()
                for product in productList.products {
                    let prices = product.prices //Array
                    price.append(prices[0].amount)
                    self.shoeId.append(product.id)
                }
                self.prices = price
                
                self.shoeProducts = productList.products
    
                self.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = shoeProducts?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath) as! CollectionViewCell
        
        if let shoes = self.shoeProducts {
            cell.productLabel.text = shoes[indexPath.row].name
        }
        
        let logoImages = [
            UIImage(named: "Nike131")!,
            UIImage(named: "MixPaint1")!,
            UIImage(named: "RetroOG1")!,
            UIImage(named: "9retros1")!,
            UIImage(named: "Lunar1")!,
            UIImage(named: "Lebrons1")!,
            UIImage(named: "XXXII1")!,
            UIImage(named: "AFSage1")!,
            UIImage(named: "AF11")!
        ]
        let shawdowImages = [
            UIImage(named: "Nike13")!,
            UIImage(named: "MixPaint")!,
            UIImage(named: "RetroOG")!,
            UIImage(named: "9retros")!,
            UIImage(named: "Lunar")!,
            UIImage(named: "Lebrons")!,
            UIImage(named: "XXXII")!,
            UIImage(named: "AFSage")!,
            UIImage(named: "AF1")!

        ]
        cell.shadowImage.image = shawdowImages[indexPath.row]
        cell.shoeImageView.image = logoImages[indexPath.row]
        cell.shoePrice.text = String("$\(self.prices[indexPath.row])")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let query = MoltinQuery(offset: nil, limit: nil, sort: nil, filter: nil, include: [.files])
        var arr = [URL]()
        SwiftSpinner.show("loading...")
            Moltin.product.list(withQuery: query) { result in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let list):
                    self.products = list.products
                    
                    for i in self.products { // GRABS ALL PRODUCTS
                        self.shoeUrl.append((i.main_image?.url)!)
                    }
                    let p = self.products[indexPath.row].files
                    
                    for j in p {
                        arr.append(j.url)
                    }
                    
                self.collectionView.reloadData()
            }
                
            self.shoeImageUrl = self.shoeUrl[indexPath.row] // The MainImage

            let main = UIStoryboard(name: "Main", bundle: nil)
                
            let dv = main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                dv.url = self.shoeImageUrl
                dv.secondImage = arr[0]
                dv.thirdImage = arr[1]
                dv.fourthImage = arr[2]
                dv.navString = self.shoeProducts![indexPath.row].name
                dv.shoesdescriptionText = self.shoeProducts![indexPath.row].description
                
            self.navigationController?.pushViewController(dv, animated: true)
        }
        
    }

}






