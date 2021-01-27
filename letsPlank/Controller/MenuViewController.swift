//
//  MenuViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/02.
//

import UIKit


class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    private let cellId = "cellId"
    private let menuLabelArray = ["開発者","プロフィール画像変更","このアプリを広める","ログアウト"]
    private let presentStoryboradNames = ["Introduce","ChangeProfileImage"]
    private let imageArray = ["person.fill","camera","square.and.pencil","arrowshape.turn.up.backward.fill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        navigationItem.title = "Menu"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
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
        }
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
