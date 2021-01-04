//
//  DoPlankViewController.swift
//  Let'sPlank
//
//  Created by Rin on 2020/12/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

//buttonTitle
enum buttonTitle: String {
    case start = "Let's Plank"
    case stop = "Stop"
}

class DoPlankViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var plankImageView: UIImageView!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var setTimerButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet var defaultLeftConstraintOfPlankImage: NSLayoutConstraint!
    @IBOutlet var centreConstraint: NSLayoutConstraint!
    
    var defaultSec = 0
    var timerInt = 0
    var timer: Timer!
    var imageIsMoved = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        if UserDefaults.standard.object(forKey: "PlankSec") == nil {
            UserDefaults.standard.set(60, forKey: "PlankSec")
        }
        
        let storyborad = UIStoryboard.init(name: "SignUp", bundle: nil)
        let sinUpViewController = storyborad.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let navigation = UINavigationController(rootViewController: sinUpViewController)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sec = UserDefaults.standard.integer(forKey: "PlankSec")
        timerLabel.text = String(sec)
        timerInt = sec
        defaultSec = sec
    }
    
    func setUpView() {
        self.navigationItem.title = "Let's Plank"
        
        startAndStopButton.layer.cornerRadius = 20
        startAndStopButton.setTitle(buttonTitle.start.rawValue, for: .normal)
        startAndStopButton.addTarget(self, action: #selector(tappedStartAndStopButton), for: .touchUpInside)
        startAndStopButton.addTarget(self, action: #selector(changeButtonColour), for: .touchDown)
    }

    //MARK: - StartAndStopButton
    @objc func tappedStartAndStopButton() {
        
        guard let buttonCurrentTitle = startAndStopButton.currentTitle else { return }
        
        //開始と停止の処理
        if buttonCurrentTitle == buttonTitle.start.rawValue {
            startAndStopButton.setTitle(buttonTitle.stop.rawValue, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            startAndStopButton.setTitle(buttonTitle.start.rawValue, for: .normal)
        }
        isEnableButtonsStatus()
        moveImageView()
        startAndStopButton.alpha = 1.0
        
    }
    //他のところでも使うからModelで持たせる？
    @objc func changeButtonColour() {
        startAndStopButton.alpha = 0.7
    }
    
    func isEnableButtonsStatus() {
        tabBarController?.tabBar.isHidden.toggle()
        setTimerButton.isEnabled.toggle()
        logoutButton.isEnabled.toggle()
    }
    
    //MARK: - Timer
    @objc func countTimer() {
        timerInt -= 1
        timerLabel.text = String(timerInt)
        
        //タイマーが0になった時
        if timerInt != 0 { return }
        timerInt = defaultSec
        timerLabel.text = String(timerInt)
        timer.invalidate()
        startAndStopButton.setTitle(buttonTitle.start.rawValue, for: .normal)
        moveImageView()
        isEnableButtonsStatus()
    }
    

    
    //MARK: - Animatioin
    func moveImageView() {
        centreConstraint.isActive.toggle()
        defaultLeftConstraintOfPlankImage.constant = imageIsMoved ? -170 : view.frame.size.width/2 - 80
        imageIsMoved = !imageIsMoved
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - NavigationBarButton
    @IBAction func tappedSetTimerButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SettingTimer", bundle: nil)
        let settingTimerController = storyboard.instantiateViewController(withIdentifier: "SettingTimerViewController") as! SettingTimerViewController
        let navigation = UINavigationController(rootViewController: settingTimerController)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
        
    }
}
