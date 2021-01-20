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
        
        //初めてアプリを起動した時には60秒を標準設定にする
        if UserDefaults.standard.object(forKey: "PlankSec") == nil {
            UserDefaults.standard.set(60, forKey: "PlankSec")
        }
        
        //ログインしてない場合のみアカウント作成画面に遷移
        if let _ = Auth.auth().currentUser { return }
        presentSignUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sec = UserDefaults.standard.integer(forKey: "PlankSec")
        timerLabel.text = String(sec)
        timerInt = sec
        defaultSec = sec
    }
    
    //MARK: - viewのレイアウト関係
    func setUpView() {
        self.navigationItem.title = "Let's Plank"
        UITabBar.appearance().tintColor = .baseColour
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
            showAlert()
        }
        moveImageView()
        isEnableButtonsStatus()
        startAndStopButton.alpha = 1.0
        
    }
    
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
        saveDataToFirestore()
    }
    
    func saveDataToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print("ユーザーID", userID)
        let dateArray = [
            "a": Timestamp()
            ]
        
        Firestore.firestore().collection("users").document(userID).getDocument { (snapshot, err) in
            if let err = err {
                
                print("データの取得に失敗", err)
            }
            print("データの取得に成功", snapshot?.data())
            let date: Timestamp = snapshot!.data()!["a"] as! Timestamp
            print(self.dateFormatterForDateLabel(date: date.dateValue()))
        }
        
        
//        Firestore.firestore().collection("users").document(userID).setData(dateArray) { err in
//            if let err = err {
//                print("追加失敗")
//            }
//            print("追加成功")
//        }
//
        
    }
    func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
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
    
    //MARK: - showAlert
    func showAlert() {
        let alert = UIAlertController(title: "えっ？やめるの？", message: "やめたら記録は保存しないぞ！\nさぁ続けるんだ！！", preferredStyle: .alert)
        
        let continuous = UIAlertAction(title: "続ける", style: .default) { [self] (_) in
            moveImageView()
            isEnableButtonsStatus()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
            startAndStopButton.setTitle(buttonTitle.stop.rawValue, for: .normal)
        }
        
        let stop = UIAlertAction(title: "やめる", style: .destructive) { [self] (_) in
            timerInt = defaultSec
            timerLabel.text = String(timerInt)
            startAndStopButton.setTitle(buttonTitle.start.rawValue, for: .normal)
        }
        
        alert.addAction(stop)
        alert.addAction(continuous)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - NavigationBarButton
    @IBAction func tappedSetTimerButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SettingTimer", bundle: nil)
        let settingTimerController = storyboard.instantiateViewController(withIdentifier: "SettingTimerViewController") as! SettingTimerViewController
        let navigation = UINavigationController(rootViewController: settingTimerController)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
        
    }
    @IBAction func tappedLogoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            presentSignUpViewController()
        } catch {
            print("err")
        }
    }
    
    func presentSignUpViewController() {
        let storyborad = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyborad.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
