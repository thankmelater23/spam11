//
//  ViewController.swift
//  XNinety
//
//  Created by John John on 3/15/18.
//  Copyright © 2018 Courtney Osborne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func press(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
}

