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
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func registerCarPressed(_ sender: UIButton) {
        if car == nil {
            car = Car()
        }
        guard let brand = brandTextField.text, let name = carNameTextField.text, let price = Double(priceTextField.text ?? "0"), let fuelType = fuelTypeSegmentedControl?.selectedSegmentIndex else { return }
            car.brand = brand
            car.name = name
            car.price = price
            car.gasType = fuelType
        
        Rest.saveCar(car: car) { (success) in
            self.goBack()
        }
    }
}
