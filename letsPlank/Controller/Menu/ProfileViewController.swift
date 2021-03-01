//
//  ProfileViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/30.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Profile"
        
        
        
        
        
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
