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
}
