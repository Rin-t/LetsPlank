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
import FirebaseStorage
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
        
        setUpViews()
        
    }
    
    private func setUpViews() {
        profileImageButton.layer.cornerRadius = self.view.frame.size.width / 4.5
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.gray.cgColor
        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 12
        registerButton.isEnabled = false
        registerButton.backgroundColor = .lightGray
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        
        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedAlreadyHaveAccountButton), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwardTextField.delegate = self
        usernameTextField.delegate = self
        
        navigationItem.title = "Create a New Account"
    }
    
    
    
    @objc func tappedProfileImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func tappedRegisterButton() {
        guard let image = profileImageButton.imageView?.image else {
            showAlert(title: "アカウント作成エラー", message: "プロフィール画像を登録してください！", isModalClosing: false)
            return
        }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。", err)
                return
            }
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗。", err)
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createUserToFirestore(profileImageUrl: urlString)
            }
        }

    }
    
    private func createUserToFirestore(profileImageUrl: String) {
        guard let email = emailTextField.text else { return }
        guard let passward = passwardTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: passward) { [self] (res, err) in
            if let err = err {
                //エラーの時の処理を書く
                //なんでアカウントが作れないかのポップを出す
                print("失敗")
                return
            }
            
            print("アカウントの作成に成功")
            
            guard let username = usernameTextField.text else { return }
            guard let uid = res?.user.uid else { return }
            
            let docData = [
                "email": email,
                "username": username,
                "createdAt": Timestamp(),
                "profileImageUrl": profileImageUrl
                ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firestoreへの保存失敗", err)
                }
                print("Firestoreへの情報の保存が成功")
            }
            self.showAlert(title: "ようこそ、プランクの世界へ", message: "アカウントの作成に成功しました。\nさぁプランクを始めましょう。", isModalClosing: true)
        }
    }
    
    private func showAlert(title: String, message: String, isModalClosing: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertButton = UIAlertAction(title: "OK", style: .default) { (_) in
            if isModalClosing {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(alertButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func tappedAlreadyHaveAccountButton() {
        let storyborad = UIStoryboard.init(name: "Login", bundle: nil)
        let loginViewController = storyborad.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}




