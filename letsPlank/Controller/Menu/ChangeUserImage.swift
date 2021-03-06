//
//  ChangeProfileImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/27.
//

import UIKit
import Firebase


class ChangeUserImageViewController: UIViewController {
    
    @IBOutlet weak private var profileImageButton: UIButton!
    @IBOutlet weak private var changeButton: UIButton!
    @IBOutlet weak private var newUsernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUsernameTextField.delegate = self
        tabBarController?.tabBar.isHidden = true
        setUpViews()
        
    }
    
    private func setUpViews() {
        let width = self.view.frame.size.width
        navigationItem.title = "Change plofile"
        
        changeButton.isEnabled = false
        changeButton.backgroundColor = .gray
        
        profileImageButton.layer.cornerRadius = width / 4
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.gray.cgColor
        
        changeButton.layer.cornerRadius = width / 24
    }
    
    @IBAction private func tappedProfileImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    

    @IBAction private func tappedChangeButton(_ sender: Any) {
        
        let newUsername: String? = newUsernameTextField.text
        let image = profileImageButton.imageView?.image
        let uploadImage = image?.jpegData(compressionQuality: 0.3) ?? nil
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { (data, err) in
            if let err = err {
                print("firestoreのデータの取得に失敗", err)
            }
            print("firestoreのデータの取得に成功")
            
            let dateArray = [
                "username": newUsername
               ]
            
            Firestore.firestore().collection("users").document(userId).updateData(dateArray) {
                err in
                if let err = err {
                    print("データのupdate失敗", err)
                }
                print("データのアップデート成功だ")
            }
        
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ChangeUserImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension ChangeUserImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
