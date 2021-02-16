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
  
    
    func setUpProfileBarButtonItem(profileBarButtonItem: UIBarButtonItem) {
        
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.imageView?.contentMode = .scaleToFill
        button.clipsToBounds = true
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { [self] (data, err) in
            if let err = err {
                print("profileImageの取得に失敗")
                return
            }
            
            guard let profileImageString = data?.data()!["profileImageUrl"] else { return }
            let profileImageURL = URL(string: profileImageString as! String)!
            print("プロフィールURL", profileImageURL)
            let image = UIImage(url: profileImageString as! String)
            button.setImage(image, for: .normal)
            
            profileBarButtonItem.customView = button
            profileBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
            profileBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            
        }
    }
}

