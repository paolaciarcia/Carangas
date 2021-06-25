//
//  Car.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import Foundation

struct Car: Codable {
    let id: String
    let brand: String
    let gasType: Int
    let name: String
    let price: Double
    
    var gas: String {
        
        switch gasType {
        case 0:
           return "Flex"
        case 1:
           return "Álcool"
        default:
        return "Gasolina"
        }
    }
}
