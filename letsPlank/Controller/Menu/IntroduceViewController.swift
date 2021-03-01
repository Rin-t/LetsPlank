//
//  IntroduceViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/02.
//

import UIKit

class IntroduceViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About Developer"
        textView.isEditable = false
        tabBarController?.tabBar.isHidden = true
    }
}
