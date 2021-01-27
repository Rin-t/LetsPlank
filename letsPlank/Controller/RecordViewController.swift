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
    @IBOutlet weak var continuousDaysLabel: UILabel!
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
        //カレンダーのレイアウト
        calender.appearance.headerTitleColor = .orange
        calender.appearance.todayColor = .systemTeal
        calender.appearance.weekdayTextColor = .orange
        //名言の挿入
        let quote = Quotes()
        let randomInt = Int.random(in: 0...quote.quotesArray.count - 1)
        quoteTextView.text = quote.quotesArray[randomInt]
        
    }
    
}

extension RecordViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        let date = formatter.string(from: date)
   
        let storyborad = UIStoryboard.init(name: "SelectImage", bundle: nil)
        let selectedImageController = storyborad.instantiateViewController(withIdentifier: "SelectImageViewController") as! SelectImageViewController
        selectedImageController.selectedDay = String(date)
        let navigation = UINavigationController(rootViewController: selectedImageController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
        
    }
    
    
}

