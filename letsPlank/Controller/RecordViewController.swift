//
//  RecordViewController.swift
//  Let'sPlank
//
//  Created by Rin on 2020/12/19.
//

import UIKit
import FSCalendar

class RecordViewController: UIViewController {
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Record"
        setViews()
    }
    
    func setViews() {
        
        let navigationBarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        calender.frame.size.height = self.view.frame.height / 3
        calender.frame.size.width = self.view.frame.width
        calender.layer.position = CGPoint(x: self.view.frame.width/2, y: navigationBarHeight*2 + self.view.frame.height/6 + 5)
        
        
        subView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height*2/3)
    }
    
}
