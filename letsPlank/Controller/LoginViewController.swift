//
//  LoginViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/07.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwardTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwardTextField.delegate = self
        
        loginButton.layer.cornerRadius = 12
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightGray
        
        navigationItem.title = "Login"
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let passward = passwardTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: passward) { (res, err) in
            if let err = err {
                print("loginに失敗", err)
                return
            }
            print("loginに成功")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwardTextField.text?.isEmpty ??  false
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .baseColour
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
