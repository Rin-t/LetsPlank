//
//  selectImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/13.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    var selectedDay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.title = selectedDay
    }
    
    func setViews() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //imageviewのレイアウト
        imageView.frame.size.width = width
        imageView.frame.size.height = height+2/3
        imageView.layer.position = CGPoint(x: width/2, y: 0)
        
        saveButton.frame.size.width = 70
        saveButton.frame.size.width = 90
    }
    
    @IBAction func tappedBackBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("tapped")
    }
    
}
