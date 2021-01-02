//
//  SettingTimerViewController.swift
//  Let'sPlank
//
//  Created by Rin on 2020/12/20.
//

import UIKit
import Firebase

class SettingTimerViewController: UIViewController {
    
    @IBOutlet weak var buckButton: UIBarButtonItem!
    
    var secIntArray = [Int](0...59)
    var minIntArray = [Int](0...10)
    var totalSec = 60
    var selectedMin = 1
    var selectedSec = 0
    
    let settingTimerPickerView = UIPickerView()
    let setTimeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    func setUpView() {
        //PickerView
        settingTimerPickerView.frame.size.width = 240
        settingTimerPickerView.frame.size.height = self.view.frame.size.height/3
        settingTimerPickerView.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.size.height/3)
        self.view.addSubview(settingTimerPickerView)
        settingTimerPickerView.delegate = self
        settingTimerPickerView.dataSource = self
        settingTimerPickerView.selectRow(1, inComponent: 0, animated: false)
        
        //Buttons
        setTimeButton.frame.size.width = 170
        setTimeButton.frame.size.height = 80
        setTimeButton.layer.cornerRadius = 20
        setTimeButton.backgroundColor = .baseColour
        setTimeButton.setTitle("Set", for: .normal)
        setTimeButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height * 2/3)
        setTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        self.view.addSubview(setTimeButton)
        setTimeButton.addTarget(self, action: #selector(tappedSetTime), for: .touchUpInside)
        setTimeButton.addTarget(self, action: #selector(changeButtonColour), for: .touchDown)
        
        self.navigationItem.title = "Setting Timer"
    }
    
    @objc func tappedSetTime() {
        UserDefaults.standard.set(totalSec, forKey: "PlankSec")
        setTimeButton.alpha = 1.0
        dismiss(animated: true, completion: nil)
        print(totalSec)
        
    }
    
    @objc func changeButtonColour() {
        setTimeButton.alpha = 0.7
    }
    
    @IBAction func tappedBuckButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension SettingTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minIntArray.count
        case 1:
            return 1
        case 2:
            return secIntArray.count
        case 3:
            return 1
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(minIntArray[row])
        case 1:
            let min = UILabel()
            min.text = "min"
            settingTimerPickerView.setPickerLabels(labels: [1: min])
            return ""
        case 2:
            return String(secIntArray[row])
        case 3:
            let sec = UILabel()
            sec.text = "sec"
            settingTimerPickerView.setPickerLabels(labels: [3: sec])
            return ""
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch component {
        case 0:
            selectedMin = minIntArray[row]
        case 2:
            selectedSec = secIntArray[row]
        default:
            return
        }
        totalSec = selectedMin*60 + selectedSec
    }
    
    
}
