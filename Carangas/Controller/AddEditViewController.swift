//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import UIKit

class AddEditViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var fuelTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Properties
    var brands: [Brand] = []
    var car: Car!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    var didFinishUpdatingCar: ((Car) -> Void)?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            brandTextField.text = car.brand
            carNameTextField.text = car.name
            priceTextField.text = "\(car.price)"
            fuelTypeSegmentedControl.selectedSegmentIndex = car.gasType
            registerButton.setTitle("Alterar carro", for: .normal)
        }
        setupToolbar()
    }
    
    //MARK: - IBActions
    @IBAction func registerCarPressed(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
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
    
    //MARK: - Methods
    func setupToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [cancelButton, spaceButton, doneButton]
        brandTextField.inputAccessoryView = toolbar
        brandTextField.inputView = pickerView
        loadBrands()
    }
    
    @objc func cancel() {
        brandTextField.resignFirstResponder()
    }
    
    @objc func done() {
        brandTextField.text = brands[pickerView.selectedRow(inComponent: 0)].fipe_name
        cancel()
    }
    
    func goBack() {
        didFinishUpdatingCar?(car)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadBrands() {
        Rest.loadBrands(onComplete: { brands in
            if let brands = brands {
                self.brands = brands.sorted(by: { $0.fipe_name < $1.fipe_name })
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            } else {
                // tratar o erro, mostrar uma alert
            }
        })
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.fipe_name
    }
}
