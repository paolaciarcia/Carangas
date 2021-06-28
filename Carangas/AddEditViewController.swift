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
    
    var didFinishUpdatingCar: ((Car) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            brandTextField.text = car.brand
            carNameTextField.text = car.name
            priceTextField.text = "\(car.price)"
            fuelTypeSegmentedControl.selectedSegmentIndex = car.gasType
            registerButton.setTitle("Alterar carro", for: .normal)
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.didFinishUpdatingCar?(self.car)
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
        
        if car._id == nil {
            Rest.saveCar(car: car) { (success) in
                self.goBack()
            }
        } else {
            Rest.updateCar(car: car, onComplete: { (success) in
                self.goBack()
            })
        }
    }
}
