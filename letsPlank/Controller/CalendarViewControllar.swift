//
//  RecordViewController.swift
//  Let'sPlank
//
//  Created by Rin on 2020/12/19.
//

import UIKit
import FSCalendar
import Firebase


class CalenderViewControllar: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var continuousDaysLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var profileBarButtonItem: UIBarButtonItem!
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        self.navigationItem.title = "Record"
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        
    }
    
    func setViews() {
        //カレンダーのレイアウト
        calendar.appearance.headerTitleColor = .orange
        calendar.appearance.todayColor = .systemTeal
        calendar.appearance.weekdayTextColor = .orange
        //名言の挿入
        let quote = Quotes()
        let randomInt = Int.random(in: 0...quote.quotesArray.count - 1)
        
        quoteTextView.text = quote.quotesArray[randomInt]
    }
    
}

extension CalenderViewControllar: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let date = formatter.string(from: date)
   
        let storyborad = UIStoryboard.init(name: "SelectImage", bundle: nil)
        let selectedImageController = storyborad.instantiateViewController(withIdentifier: "SelectImageViewController") as! SelectImageViewController
        selectedImageController.selectedDay = String(date)
        let navigation = UINavigationController(rootViewController: selectedImageController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
        
    }
    
}

