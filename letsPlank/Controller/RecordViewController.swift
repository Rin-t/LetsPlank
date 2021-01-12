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
    @IBOutlet weak var continuousDaysLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var totalSecLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Record"
        self.calender.dataSource = self
        self.calender.delegate = self
        setViews()
        
    }
    
    
    
    func setViews() {
        
        let navigationBarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        calender.frame.size.height = self.view.frame.height / 3
        calender.frame.size.width = self.view.frame.width
        calender.layer.position = CGPoint(x: self.view.frame.width/2, y: navigationBarHeight*2 + self.view.frame.height/6 + 5)
        calender.appearance.headerTitleColor = .orange
        calender.appearance.todayColor = .systemTeal
        calender.appearance.weekdayTextColor = .orange
        
        subView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height*2/3)
    }
    
}

extension RecordViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        let da = formatter.string(from: date)
       
        
        print(da)
    }
    
    
}
