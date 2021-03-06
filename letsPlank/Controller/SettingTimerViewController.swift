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
    
    private var secIntArray = [Int](0...59)
    private var minIntArray = [Int](0...10)
    private var totalSec = 60
    private var selectedMin = 1
    private var selectedSec = 0
    private let minLabel = UILabel()
    private let secLabel = UILabel()
    
    @IBOutlet weak var settingTimerPickerView: UIPickerView!
    @IBOutlet weak var setTimeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    func setUpView() {
        //PickerView
        settingTimerPickerView.delegate = self
        settingTimerPickerView.dataSource = self
        settingTimerPickerView.selectRow(1, inComponent: 0, animated: false)
        
        //Button
        setTimeButton.addTarget(self, action: #selector(tappedSetTime), for: .touchUpInside)
        setTimeButton.addTarget(self, action: #selector(changeButtonColour), for: .touchDown)
        setTimeButton.layer.cornerRadius = 20
        self.navigationItem.title = "Setting Timer"
    }
    
    @objc func tappedSetTime() {
       // if totalSec >= 30 {
            UserDefaults.standard.set(totalSec, forKey: "PlankSec")
            setTimeButton.alpha = 1.0
            dismiss(animated: true, completion: nil)
        //} else {
          //  showAlert()
        //}
        
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "設定時間が短すぎます", message: "設定時間は30秒以上にしてください。", preferredStyle: .alert)
        
        let continuous = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(continuous)
        present(alert, animated: true, completion: nil)
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
            minLabel.text = "min"
            settingTimerPickerView.setPickerLabels(labels: [1: minLabel])
            return ""
        case 2:
            return String(secIntArray[row])
        case 3:
            secLabel.text = "sec"
            settingTimerPickerView.setPickerLabels(labels: [3: secLabel])
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
        totalSec = selectedMin * 60 + selectedSec
    }
    
    
}
