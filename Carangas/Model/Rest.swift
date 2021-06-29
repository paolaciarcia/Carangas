//
//  Rest.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import Foundation

class Rest {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        
        return config
    }()
    
    //requisição customizada
    private static let session = URLSession(configuration: configuration)
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json") else {
            onComplete(nil)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data
            else {
                onComplete(nil)
                return
            }
            
            do {
                let brands = try JSONDecoder().decode([Brand].self, from: data)
                onComplete(brands)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
        dataTask.resume()
    }
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return onError(.taskError(error: error!))
            }
            
            guard let response = response as? HTTPURLResponse else {
                onError(.noResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                print("status inválido pelo servidor")
                return onError(.responseStatusCode(code: response.statusCode))
            }
            
            guard let data = data else { return }
            
            do {
                let cars = try JSONDecoder().decode([Car].self, from: data)
                onComplete(cars)
            } catch {
                print(error.localizedDescription)
                onError(.invalidJSON)
            }
        }
        dataTask.resume()
    }
       
    
    class func saveCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    class func updateCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
        
    }
    
    class func deleteCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Car, operation: RestOperation, onComplete: @escaping (Bool) -> Void) {
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = operation.rawValue
        
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = json
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if data == nil {
                onComplete(false)
            } else {
                onComplete(true)
            }
//            if error == nil {
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
//                    onComplete(false)
//                    return
//                }
//                onComplete(true)
//            } else {
//                onComplete(false)
//            }
        }
        dataTask.resume()
    }
}
