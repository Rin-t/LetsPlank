//
//  MenuViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/02.
//

import UIKit
import Firebase

struct MenuComponent {
    var label: String
    var image: UIImage
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    private let menu: [MenuComponent] = [
        MenuComponent(label: "プロフィール", image: UIImage(systemName: "person.fill")!),
        MenuComponent(label: "開発者", image: UIImage(systemName: "pc")!),
        MenuComponent(label: "このアプリを広める", image: UIImage(systemName: "square.and.pencil")!),
        MenuComponent(label: "ログアウト", image: UIImage(systemName: "arrowshape.turn.up.left.fill")!)
    ]
    
    private let cellId = "cellId"
    private let presentStoryboradNames = ["ChangeProfileImage","Introduce"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(menu)
        
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
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menu[indexPath.row].label
        cell.menuImage.image = menu[indexPath.row].image
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
