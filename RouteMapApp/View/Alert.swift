//
//  Alert.swift
//  RouteMapApp
//
//  Created by Александр Макаров on 05.11.2022.
//

import UIKit

extension UIViewController {
    
    func alertAddAddress(title: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "ОК", style: .default) { action in
            let tfText = alertController.textFields?.first
            guard let text = tfText?.text else { return }
            completionHandler(text)
        }
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .default) { _ in
            
        }
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true)
    }
    
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertOk)
        present(alertController, animated: true)
    }
}
