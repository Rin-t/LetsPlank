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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Record"
        setViews()
    }
    
    func setViews() {
        
        let navigationBarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        calender.frame.size.height = self.view.frame.height / 3
        calender.frame.size.width = self.view.frame.width
        calender.layer.position = CGPoint(x: self.view.frame.width/2, y: navigationBarHeight*2 + self.view.frame.height/6)
        
    }
    
}
