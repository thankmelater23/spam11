//
//  DetailViewController.swift
//  XNinety
//
//  Created by John John on 3/16/18.
//  Copyright © 2018 Courtney Osborne. All rights reserved.
// https://forum.moltin.com/t/moltin-type-and-its-members/196/2

import UIKit
import Moltin
import SwiftSpinner
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    
    @IBOutlet weak var detailTextLabelView: UITextView!
    
    var shoesdescriptionText = String()
    var productImage = UIImage()
    var secondImage : URL?
    var thirdImage : URL?
    var fourthImage : URL?
    var url : URL?
    var navString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.navigationItem.title = navString

        self.detailTextLabelView.text = shoesdescriptionText
        
        secondImageView.kf.setImage(with: secondImage)
        thirdImageView.kf.setImage(with: thirdImage)
        fourthImageView.kf.setImage(with: fourthImage)
        
        mainImageView.kf.setImage(with: url)
        SwiftSpinner.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Currently out of stock", message: "Allow notifications to recieve alerts on new release", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func contraints() {
        
    }

}


















