//
//  Exten.swift
//  My Wedding Day
//
//  Created by Ivana Fidanovska on 4/22/21.
//  Copyright © 2021 Fidanovska. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    func loader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Plese wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader: UIAlertController){
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
