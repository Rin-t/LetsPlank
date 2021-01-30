//
//  MenuViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/02.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    private let cellId = "cellId"
    private let menuLabelArray = ["プロフィール","開発者","このアプリを広める","ログアウト"]
    private let presentStoryboradNames = ["ChangeProfileImage","Introduce"]
    private let imageArray = ["person.fill","pc","square.and.pencil","arrowshape.turn.up.backward.fill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        navigationItem.title = "Menu"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        deselectRowAnimation()
    }
    
    private func deselectRowAnimation() {
        if let indexPathForSelectedRow = menuTableView.indexPathForSelectedRow {
            UIView.animate(withDuration: 0.6, animations: {
                self.menuTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            })
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menuLabelArray[indexPath.row]
        cell.menuImage.image = UIImage(systemName: imageArray[indexPath.row])
        cell.menuImage.tintColor = .baseColour
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0...1 ~= indexPath.row {
            presentShow(storyboradName: presentStoryboradNames[indexPath.row])
        } else if indexPath.row == 2 {
            showAlert()
            deselectRowAnimation()
        } else {
            do {
                try Auth.auth().signOut()
                presentModalFullScreen(storyboradName: "SignUp")
                
            } catch {
                print("err")
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "ありがとうございます！", message: "このアプリを広めてくれようとしたのでしょうか?\n何と心やさしきお方なのでしょう。\nしかしながら定形文は用意しておりませんので、お好きな画面をキャプチャしてSNS等に投稿してください。", preferredStyle: .alert)
        let continuous = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(continuous)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

//@IBAction func tappedLogoutButton(_ sender: Any) {
//    do {
//        try Auth.auth().signOut()
//        presentSignUpViewController()
//    } catch {
//        print("err")
//    }
//}
