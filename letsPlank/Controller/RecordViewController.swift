//
//  RecordViewController.swift
//  letsPlank
//
//  Created by Rin on 2021/02/18.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 30
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        navigationItem.title = "Record"
        
    }
}

//totalsec continuousdays totaldays
