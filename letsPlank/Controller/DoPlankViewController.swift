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
    
    @IBOutlet var defaultLeftConstraintOfPlankImage: NSLayoutConstraint!
    @IBOutlet var centreConstraint: NSLayoutConstraint!
    @IBOutlet weak var todaysActivityLabel: UILabel!
    
    var defaultSec = 0              //defaultの秒数
    var timerInt = 0                //countDown用
    var timer: Timer!
    var imageIsMoved = false
    
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView作成
        self.imageView.frame.size.width = 100
        self.imageView.frame.size.width = 45
        //中央寄せ
        self.imageView.center = self.view.center
        //画像を設定
        self.imageView.image = UIImage(named: "腕立て")
        //viewに追加
        self.view.addSubview(self.imageView)
        
        
        
        setUpView()
        confirmAleadyDoneToday()
        //初めてアプリを起動した時には60秒を標準設定にする
        if UserDefaults.standard.object(forKey: "PlankSec") == nil {
            UserDefaults.standard.set(60, forKey: "PlankSec")
        }
        
        //ログインしてない場合のみアカウント作成画面に遷移
        if let _ = Auth.auth().currentUser { return }
        presentModalFullScreen(storyboradName: "SignUp")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                       }, completion: { (Bool) in
                        
                       })
        
        //8倍まで拡大！
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.imageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                        self.imageView.alpha = 0
                       }, completion: { (Bool) in
                        //で、アニメーションが終わったらimageViewを消す
                        self.imageView.removeFromSuperview()
                       })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //画面が表示された時は初期設定の時間をセットする
        let sec = UserDefaults.standard.integer(forKey: "PlankSec")
        timerLabel.text = String(sec)
        timerInt = sec
        defaultSec = sec
    }
    
    private func confirmAleadyDoneToday() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userID).getDocument { [self] (snapshot, err) in
            if let err = err {
                print("データの取得に失敗", err)
            }
            print("データの取得に成功")
            
            guard let  date: [Timestamp] = snapshot!.data()!["didPlankDay"] as? [Timestamp] else { return }
            let lastDay = dateFormatterForDateLabel(date: (date.last!.dateValue()))
            let today =  dateFormatterForDateLabel(date: Date())
            if lastDay == today {
                todaysActivityLabel.text = "今日はもうやったよ"
                todaysActivityLabel.textColor = .systemBlue
            }
            
        }
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
        todaysActivityLabel.text = "今日はもうやったよ！"
        todaysActivityLabel.textColor = .systemBlue
        moveImageView()
        isEnableButtonsStatus()
        saveDataToFirestore()
    }
    
    //counterが0までいったら、firebaseに実行日を追加
    func saveDataToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userID).getDocument { (snapshot, err) in
            if let err = err {
                print("データの取得に失敗", err)
            }
            print("データの取得に成功")
            
            var date: [Timestamp] = snapshot!.data()!["didPlankDay"] as? [Timestamp] ?? [Timestamp()]
            if date.count != 1 {
                date.append(Timestamp())
            }
            
            let dateArray = [
                "didPlankDay": date
            ]
            
            Firestore.firestore().collection("users").document(userID).updateData(dateArray) {
                err in
                if let err = err {
                    print("データのupdate失敗", err)
                }
                print("データのアップデート成功だ")
            }
        }
    }
    
    //MARK: - dateFormatter
    func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
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
        let alert = UIAlertController(title: "やめるの？", message: "やめたら記録は保存しないぞ！", preferredStyle: .alert)
        
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
        presentModalFullScreen(storyboradName: "SettingTimer")
    }
}
