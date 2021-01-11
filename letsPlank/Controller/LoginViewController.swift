//
//  LoginViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/07.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.frame.size.width = self.view.frame.width*2 / 3
        messageLabel.frame.size.height = 80
        messageLabel.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/3)
        
        
        navigationItem.title = "Login"
    }
    
    
}
