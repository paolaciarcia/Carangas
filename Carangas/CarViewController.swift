//
//  CarViewController.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import UIKit

class CarViewController: UIViewController {
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var gasType: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brand.text = car.brand
        gasType.text = car.gas
        price.text = "R$ \(car.price)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddEditViewController
        vc?.car = car
    }
}
