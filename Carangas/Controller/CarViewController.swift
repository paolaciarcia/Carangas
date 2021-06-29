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
    
    // MARK: - IBOutlets
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var gasType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Properties
    var car: Car!
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        return numberFormatter
    }()

    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = car.name
        brand.text = car.brand
        gasType.text = car.gas
        price.text = numberFormatter.string(from: NSNumber(value: car.price))
        getWebView()
    }
    
    //MARK: - Methods
    func getWebView() {
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://google.com.br/search?q=\(name)&tbm=isch"
        guard let url = URL(string: urlString) else { return }
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

//MARK: - WKNavigationDelegate, WKUIDelegate
extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
