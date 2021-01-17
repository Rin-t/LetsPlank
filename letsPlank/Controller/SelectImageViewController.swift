//
//  selectImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/13.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    var selectedDay: String?
    var topSafeAreaHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedDay
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSafeAreaHeight = self.view.safeAreaInsets.top
        setViews()
    }
    
    func setViews() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //imageviewのレイアウト
        imageButton.frame.size.width = width
        imageButton.frame.size.height = height/2
        imageButton.layer.position = CGPoint(x: width/2, y: topSafeAreaHeight + height/4)
        imageButton.layer.borderWidth = 0.5
        
        saveButton.frame.size.width = 70
        saveButton.frame.size.width = 190
        saveButton.layer.position = CGPoint(x: width/2, y: height*4/5)
    }
    
    @IBAction func tappedBackBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension SelectImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            imageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        imageButton.setTitle("", for:  .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.contentHorizontalAlignment = .fill
        imageButton.contentVerticalAlignment = .fill
        imageButton.clipsToBounds = true

        dismiss(animated: true, completion: nil)
    }
}
