//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    var cars: [Car] = []
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Carregando carros..."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Rest.loadCars { apiCars in
            
            self.cars = apiCars.filter { car in
                return !car.name.isEmpty
            }
            print("apiCars: \(self.cars)")
            DispatchQueue.main.async {
                self.label.text = "Não existem carros cadastrados"
                self.tableView.reloadData()
            }
        } onError: { (error) in
            print(error)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = cars.count == 0 ? label : nil
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        
            cell.textLabel?.text = car.name
            cell.detailTextLabel?.text = car.brand

        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCarDetail" {
        let carVC = segue.destination as! CarViewController
            carVC.car = cars[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            Rest.deleteCar(car: car) { (success) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
