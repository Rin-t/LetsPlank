//
//  UIViewControllerExtension.swift
//  letsPlank
//
//  Created by Rin on 2021/01/25.
//

import UIKit

extension UIViewController {
    
    func presentModalFullScreen(storyboradName: String, withIdentifier: String) {
        let storyborad = UIStoryboard(name: storyboradName, bundle: nil)
        let nextViewController = storyborad.instantiateViewController(withIdentifier: withIdentifier)
        let nav = UINavigationController(rootViewController: nextViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}


