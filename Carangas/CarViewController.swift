//
//  CarViewController.swift
//  Carangas
//
//  Created by Erick Borges on 25/06/21.
//

import UIKit
import Foundation
import WebKit

class CarViewController: UIViewController {
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var gasType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = car.name
        brand.text = car.brand
        gasType.text = car.gas
        price.text = "R$ \(car.price)"
        
        getWebView()
    }
    
    func getWebView() {
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://google.com.br/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddEditViewController
        vc?.car = car

        vc?.didFinishUpdatingCar = { updatedCar in
            self.car = updatedCar
        }
    }
}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
