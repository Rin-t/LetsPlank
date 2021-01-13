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
    
    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var continuousDaysLabel: UILabel!
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quoteTextView: UITextView!
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Record"
        self.calender.dataSource = self
        self.calender.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSafeAreaHeight = self.view.safeAreaInsets.top
        setViews()
    }
    
    
    
    func setViews() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        calender.frame.size.height = height/3
        calender.frame.size.width = width
        calender.layer.position = CGPoint(x: width/2, y: topSafeAreaHeight + height/6)
        calender.appearance.headerTitleColor = .orange
        calender.appearance.todayColor = .systemTeal
        calender.appearance.weekdayTextColor = .orange
        
        quoteView.frame.size.height = height/3
        quoteView.frame.size.width = self.view.frame.width
        quoteView.layer.position = CGPoint(x: width/2, y: height*3/4)
        quoteTextView.frame.size.width = width*2/3 - 10
        
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

