//
//  SignUpViewController.swift
//  message
//
//  Created by Rin on 2020/11/17.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PKHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwardTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //profileImageButton.layer.cornerRadius = 65
        profileImageButton.frame.size.width = self.view.frame.size.width/3
        profileImageButton.frame.size.height = self.view.frame.size.width/3
        profileImageButton.layer.position = CGPoint(x: self.view.frame.size.width/2, y:self.view.frame.size.height/4 )
        profileImageButton.layer.cornerRadius = self.view.frame.size.width/6
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.gray.cgColor
        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 12
        registerButton.isEnabled = false
        registerButton.backgroundColor = .lightGray
        
        emailTextField.delegate = self
        passwardTextField.delegate = self
        usernameTextField.delegate = self
        
        navigationItem.title = "Create a New Account"
        
        //setUpViews()
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        navigationController?.navigationBar.isHidden = false
    //    }
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedProfileImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setUpViews() {
        
        //        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        //        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedAlreadyHaveAccountButton), for: .touchUpInside)
    }
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.setTitle("", for:  .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        
        profileImageButton.clipsToBounds = true
        
    
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwardTextField.text?.isEmpty ??  false
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false
        
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .lightGray
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .baseColour
        }

    }
}




//    @objc private func tappedAlreadyHaveAccountButton() {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//        self.navigationController?.pushViewController(loginViewController, animated: true)
//    }
//
//    @objc private func tappedProfileImageButton() {
//
//        let imagePickerControlelr = UIImagePickerController()
//        imagePickerControlelr.delegate = self
//        imagePickerControlelr.allowsEditing = true
//
//        self.present(imagePickerControlelr, animated: true, completion: nil)
//
//    }
//
//    @objc private func tappedRegisterButton() {
//        guard let image = profileImageButton.imageView?.image else { return }
//        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
//
//        HUD.show(.progress)
//
//        let fileName = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
//
//        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
//            if let err = err {
//                print("err", err)
//                print(err)
//                HUD.hide()
//                return
//            }
//
//            storageRef.downloadURL{ (url, err) in
//                if let err = err {
//                    print("err2")
//                    HUD.hide()
//                    return
//                }
//
//                guard let urlString = url?.absoluteString else { return }
//                self.createUserToFireStore(profileImageUrl: urlString)
//            }
//        }
//    }
//
//    private func createUserToFireStore(profileImageUrl: String) {
//
//        guard let email = emailTextField.text else { return }
//        guard let password = passwardTextField.text else { return }
//
//        Auth.auth().createUser(withEmail: email, password: password) {  (res, err) in
//            if let err = err {
//                print(err)
//                print("err3")
//                HUD.hide()
//                return
//            }
//            print("ok")
//
//            guard let uid = res?.user.uid else { return }
//            guard let username = self.usernameTextField.text else { return }
//            let docData = [
//                "email": email,
//                "username": username,
//                "createdAt": Timestamp(),
//                "profileImageUrl": profileImageUrl
//            ] as [String : Any]
//
//            Firestore.firestore().collection("users").document(uid).setData(docData) {
//                (err) in
//                if let err = err {
//                    print("err4")
//                    HUD.hide()
//                    return
//                }
//                print("保存成功")
//                HUD.hide()
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//}
//
//extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let editImage = info[.editedImage] as? UIImage {
//            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        } else if let originalImage = info[.originalImage] as? UIImage {
//            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        profileImageButton.setTitle("", for:  .normal)
//        profileImageButton.imageView?.contentMode = .scaleAspectFill
//        profileImageButton.contentHorizontalAlignment = .fill
//        profileImageButton.clipsToBounds = true
//
//        dismiss(animated: true, completion: nil)
//    }
//
//}
//
//

