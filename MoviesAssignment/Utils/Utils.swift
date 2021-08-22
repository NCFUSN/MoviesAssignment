//
//  Utils.swift
//  MoviesAssignment
//
//  Created by SilentObserver on 19/08/2021.
//

import UIKit

class Utils {
    static var APIKEY: String? {
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    if let v = dict["APIKEY"] {
                        return v as? String
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static func presentError(error: Error, for controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            }))
        //for iPad Support
        alert.popoverPresentationController?.sourceView = controller.view

        controller.present(alert.fixConstraints(), animated: true, completion: {
                
            })
    }
    
    static func presentMessage(message: String, for controller: UIViewController) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            }))
        //for iPad Support
        alert.popoverPresentationController?.sourceView = controller.view

        controller.present(alert.fixConstraints(), animated: true, completion: {
                
            })
    }
}
