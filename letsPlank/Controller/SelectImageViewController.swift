//
//  selectImageViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/01/13.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    var selectedDay: String = "1/1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.title = selectedDay
    }
    
}
