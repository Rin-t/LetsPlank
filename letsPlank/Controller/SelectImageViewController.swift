//
//  selectImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/13.
//

import UIKit
import Firebase
import Nuke
import SDWebImage

class SelectImageViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    var selectedDay: String?
    var topSafeAreaHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.backgroundColor = .lightGray
        navigationItem.title = selectedDay
    }
    
    //safeareaの取得
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSafeAreaHeight = self.view.safeAreaInsets.top
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let selectedDay = selectedDay else { return }
        
        Storage.storage().reference().child(userId).child(selectedDay).downloadURL(completion: { [self] (data, err) in
            if let err = err {
                print("storageからのimageのダウンロードに失敗")
            }
            print("strageからimageのダウンロードを成功")
            print(data)
            guard let data = data else { return }
            Nuke.loadImage(with: data, into: imageButton.imageView!)
            imageButton.sd_setImage(with: data, for: .normal , completed: nil)
            print("画像セット完了")
        })
    }
    
    func setViews() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //imageviewのレイアウト
        imageButton.frame.size.width = width
        imageButton.frame.size.height = height/2
        imageButton.layer.position = CGPoint(x: width/2, y: topSafeAreaHeight + height/4)
        imageButton.layer.borderWidth = 0.5
        
        saveButton.layer.cornerRadius = 12
        saveButton.frame.size.width = 70
        saveButton.frame.size.width = 190
        saveButton.layer.position = CGPoint(x: width/2, y: height*4/5)
    }
    
    @IBAction func tappedBackBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        guard let image = imageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let fileName = selectedDay else { return }
        
        let storageRef = Storage.storage().reference().child(userId).child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。", err)
                return
            }
            print("fileをアップロードした")
            self.dismiss(animated: true, completion: nil)
        }
        
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
        saveButton.backgroundColor = .baseColour
        saveButton.isEnabled = true
        imageButton.setTitle("", for:  .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.contentHorizontalAlignment = .fill
        imageButton.contentVerticalAlignment = .fill
        imageButton.clipsToBounds = true

        dismiss(animated: true, completion: nil)
    }
}
