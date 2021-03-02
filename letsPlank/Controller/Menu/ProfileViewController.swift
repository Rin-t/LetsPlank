//
//  ProfileViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/30.
//

import UIKit
import Nuke
import Firebase

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var userIdTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Profile"
        
        setViews()
        
        
        
    }
    
    private func setViews() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        userIdTextView.text = userId
        
        Firestore.firestore().collection("users").document(userId).getDocument { [self] (data, err) in
            if let err = err {
                print("ユーザーデータの取得に失敗ProfileViewController", err)
            }
            
            guard let userName = data?.data()?["username"] as? String else { return }
            
            //ユーザーネームを表示
            userNameLabel.text = userName
            
            //プロフィール画像の設定
            guard let profileImageString = data?.data()?["profileImageUrl"] as? String else { return }
            guard let profileImageUrl = URL(string: profileImageString) else { return }
            Nuke.loadImage(with: profileImageUrl, into: profileImageView)
            profileImageView.layer.cornerRadius = view.frame.size.width / 4
            profileImageView.contentMode = .scaleAspectFill
        }
        
        

        
        
        
        
        
    }
    
    private func fetcheFirestoreData() -> Any {
        return 0
    }
    
    
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
