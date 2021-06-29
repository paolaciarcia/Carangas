//
//  CarError.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}
