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
    private let menuLabelArray = ["開発者","評価する"]
    private let imageArray = ["person.fill","square.and.pencil"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        navigationItem.title = "Menu"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
        let storyborad = UIStoryboard.init(name: "Introduce", bundle: nil)
        let introduceView = storyborad.instantiateViewController(withIdentifier: "IntroduceView")
        self.show(introduceView, sender: nil)
    }
    
    
}
