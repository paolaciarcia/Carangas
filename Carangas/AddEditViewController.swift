//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var fuelTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerCarPressed(_ sender: UIButton) {
    }
    
}
