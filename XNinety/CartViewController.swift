//
//  CartViewController.swift
//  XNinety
//
//  Created by John John on 3/16/18.
//  Copyright © 2018 Courtney Osborne. All rights reserved.
// https://forum.moltin.com/t/moltin-type-and-its-members/196/2

import UIKit
import SwiftSpinner
import Moltin


class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shopping Cart button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(disableCheckout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftSpinner.show("loading cart")
        
        Moltin.cart.getNew { (results) in
            SwiftSpinner.hide()
            
        }
        
    }
    
   @objc func disableCheckout() {
        let alert = UIAlertController(title: "Empty cart", message: "Add something to cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: nil))

 
        present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table cell", for: indexPath)
        
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
