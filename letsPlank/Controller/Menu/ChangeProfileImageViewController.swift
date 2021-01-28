//
//  ChangeProfileImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/27.
//

import UIKit

class ChangeProfileImageViewController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Change plofile image"
        tabBarController?.tabBar.isHidden = true
        let width = self.view.frame.size.width
        profileImageButton.layer.cornerRadius = width / 4
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.gray.cgColor
        changeButton.layer.cornerRadius = width / 24
        
        
    }
    @IBAction func tappedProfileImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension ChangeProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
