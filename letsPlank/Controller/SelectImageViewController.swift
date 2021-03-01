//
//  selectImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/13.
//

import UIKit
import Firebase
import FirebaseStorage
import Nuke

class SelectImageViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    var selectedDay: String?
    var topSafeAreaHeight: CGFloat = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.backgroundColor = .lightGray
        navigationItem.title = selectedDay
        navigationController?.navigationBar.barTintColor = .systemGray6
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
                print("storageからのimageのダウンロードに失敗", err)
                return
            }
            print("strageからimageのダウンロードを成功")
        
            guard let data = data else { return }
            Nuke.loadImage(with: data, into: imageView)
            imageView.contentMode = .scaleAspectFill
            print("画像セット完了")
        })
    }
    
    func setViews() {
          saveButton.layer.cornerRadius = 12
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
            self.imageButton.isEnabled = false
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedDeleteBarButton(_ sender: Any) {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "写真の削除", message: "保存している写真を削除しますか？", preferredStyle: .alert)
        
        let notDelete = UIAlertAction(title: "いいえ", style: .default) { (_) in
            
        }
        
        let delete = UIAlertAction(title: "はい", style: .destructive) { [self] (_) in
            imageView.image = nil
            guard let userId = Auth.auth().currentUser?.uid else { return }
            guard let selectedDay = selectedDay else { return }
            
            Storage.storage().reference().child(userId).child(selectedDay).delete { (err) in
                if let err = err {
                    print("写真の削除に失敗しました")
                }
                print("写真の削除が完了しました。")
            }
        }
        
        alert.addAction(delete)
        alert.addAction(notDelete)
        present(alert, animated: true, completion: nil)
        
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
        imageView.image = nil

        dismiss(animated: true, completion: nil)
    }
}
