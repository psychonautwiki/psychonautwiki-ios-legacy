//
//  UIViewControllerExtensions.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension Optional {
    
    func isNil() -> Bool {
        return self == nil
    }
    
}
