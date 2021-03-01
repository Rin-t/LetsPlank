//
//  UIViewControllerExtension.swift
//  letsPlank
//
//  Created by Rin on 2021/01/25.
//

import UIKit
import Firebase

extension UIViewController {
    
    func presentModalFullScreen(storyboradName: String) {
        let nextViewController = prepareForPresent(storyboradName: storyboradName)
        let nav = UINavigationController(rootViewController: nextViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentShow(storyboradName: String) {
        let nextViewController = prepareForPresent(storyboradName: storyboradName)
        self.show(nextViewController, sender: nil)
    }
    
    func prepareForPresent(storyboradName: String) -> UIViewController {
        let storyborad = UIStoryboard(name: storyboradName, bundle: nil)
        let nextViewController = storyborad.instantiateViewController(withIdentifier: storyboradName)
        return nextViewController
    }
  
    

}

