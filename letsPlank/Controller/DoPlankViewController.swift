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
import Nuke

//buttonTitle
enum ActionStatus: String {
    case idel = "Let's plank"
    case plank = "Stop"
}

//startAndStopButton.setTitle(buttonTitle.start.rawValue, for: .normal)

class DoPlankViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var plankImageView: UIImageView!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var setTimerButton: UIBarButtonItem!
    @IBOutlet var defaultLeftConstraintOfPlankImage: NSLayoutConstraint!
    @IBOutlet var centreConstraint: NSLayoutConstraint!
    @IBOutlet weak var todaysActivityLabel: UILabel!
    @IBOutlet weak var profileBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    private var currentActionStatus: ActionStatus = .idel
    ///plankの秒数
    private var defaultSec = 0
    ///timerのカウント用
    private var timerInt = 0
    private var timer: Timer!
    private var imageIsMoved = false

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //起動時のアニメーション
        launchAppImageAnimation()
        
        //view関係のセットアップ
        setUpView()
        
        
        
        //初めてアプリを起動した時には60秒を標準設定にする
        if UserDefaults.standard.object(forKey: "PlankSec") == nil {
            UserDefaults.standard.set(60, forKey: "PlankSec")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //画面が表示された時は初期設定の時間をセットする
        let sec = UserDefaults.standard.integer(forKey: "PlankSec")
        timerLabel.text = String(sec)
        timerInt = sec
        defaultSec = sec
        
        setUpProfileBarButtonItem(profileBarButtonItem: profileBarButtonItem)
        
        //その日にすでにプランクをしているかの確認
        confirmAleadyDoneToday()
          
        
    }
    
    private func launchAppImageAnimation() {
        //アニメーションようのlogoをviewにセット
        self.logoImageView.image = UIImage(named: "白プランク")
        self.view.addSubview(self.imageView)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                       }, completion: { (Bool) in
                        
                       })
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.8,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                        self.logoImageView.alpha = 0
                       }, completion: { (Bool) in
                        //アニメーションが終わったらimageViewを消す
                        self.imageView.removeFromSuperview()
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.setNavigationBarHidden(false, animated: false)
                        
                        //アニメーションが終わってアカウントにログインしていない場合の画面遷移
                        if let _ = Auth.auth().currentUser { return }
                        self.presentModalFullScreen(storyboradName: "SignUp")
                       })
    }
    
    private func setButtonTitle(actionStatus: ActionStatus) {
        startAndStopButton.setTitle(actionStatus.rawValue, for: .normal)
    }
    
    
//MARK: - confirmAleadyDoneToday
    private func confirmAleadyDoneToday() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userID).getDocument { [self] (snapshot, err) in
            if let err = err {
                print("データの取得に失敗", err)
            }
            print("データの取得に成功")
            
            guard let  date: [Timestamp] = snapshot?.data()!["didPlankDay"] as? [Timestamp] else { return }
            let lastDay = dateFormatterForDateLabel(date: (date.last!.dateValue()))
            let today =  dateFormatterForDateLabel(date: Date())
            if lastDay == today {
                todaysActivityLabel.text = "Done today!"
                todaysActivityLabel.textColor = .systemBlue
            }
            
        }
    }
    
    //MARK: - viewのレイアウト関係
    private func setUpView() {
        self.navigationItem.title = "Let's Plank"
        UITabBar.appearance().tintColor = .baseColour
        
        setUpStartAndStopButton()
        setUpProfileBarButtonItem(profileBarButtonItem: profileBarButtonItem)
        
    }
    
    private func setUpStartAndStopButton() {
        setButtonTitle(actionStatus: .idel)
        startAndStopButton.layer.cornerRadius = 20
        startAndStopButton.addTarget(self, action: #selector(tappedStartAndStopButton), for: .touchUpInside)
        startAndStopButton.addTarget(self, action: #selector(changeButtonColour), for: .touchDown)
        startAndStopButton.addTarget(self, action: #selector(changeButtonColour), for: .touchDragExit)
    }
    

    
    //MARK: - StartAndStopButton
    
    
    @objc private func tappedStartAndStopButton() {
        
        //開始と停止の処理
        if  currentActionStatus == .idel {
            currentActionStatus = .plank
            setButtonTitle(actionStatus: currentActionStatus)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
        } else {
            currentActionStatus = .idel
            timer.invalidate()
            setButtonTitle(actionStatus: currentActionStatus)
            showAlert()
        }
        moveImageView()
        isEnableButtonsStatus()
        startAndStopButton.alpha = 1.0
        
    }
    
    @objc private func changeButtonColour() {
        //ボタンタップ時の背景色の変更
        //非常に美しくない
        //enum使ったらいいのかな？
        if startAndStopButton.alpha == 1.0 {
            startAndStopButton.alpha = 0.7
        } else {
            startAndStopButton.alpha = 1.0
            startAndStopButton.isSelected = false
        }
        
    }
    
    func isEnableButtonsStatus() {
        tabBarController?.tabBar.isHidden.toggle()
        setTimerButton.isEnabled.toggle()
        
    }
    
    //MARK: - setUpProfileBarButtonItem
    
    private func setUpProfileBarButtonItem(profileBarButtonItem: UIBarButtonItem) {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true

        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { (data, err) in
            if let err = err {
                print("profileImageの取得に失敗")
                return
            }
            
            guard let profileImageString = data?.data()?["profileImageUrl"] else { return }
            let profileImageUrl = URL(string: profileImageString as! String)!
            //button.setImage(image, for: .normal)
            Nuke.loadImage(with: profileImageUrl, into: imageView)
            profileBarButtonItem.customView = imageView
            profileBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
            profileBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            
        }
        
        
    }
    
    
    //MARK: - Timer
    @objc private func countTimer() {
        timerInt -= 1
        timerLabel.text = String(timerInt)
        
        //タイマーが0になった時
        if timerInt == 0 {
            timerInt = defaultSec
            timerLabel.text = String(timerInt)
            timer.invalidate()
            todaysActivityLabel.text = "Done today!"
            todaysActivityLabel.textColor = .systemBlue
            moveImageView()
            isEnableButtonsStatus()
            saveDataToFirestore()
            setButtonTitle(actionStatus: .idel)
            currentActionStatus = .idel
        }
        
    }
    
    //MARK: - saveDataToFirestore
    //counterが0までいったら、firebaseに実行日を追加
    private func saveDataToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userID).getDocument { (snapshot, err) in
            if let err = err {
                print("データの取得に失敗", err)
            }
            print("データの取得に成功")
            
            //初めてプランクをする場合はその時のtimestampをおす。
            var date: [Timestamp] = snapshot?.data()!["didPlankDay"] as? [Timestamp] ?? [Timestamp()]
            //初めての時はすでにtimestampを押しているのでスキップ
            if date.count <= 1 {
                date.append(Timestamp())
            }
            
            var totalSec: Int = snapshot?.data()!["totalSec"] as? Int ?? 0
            totalSec += self.defaultSec
            
            let dateArray = [
                "didPlankDay": date,
                "totalSec": totalSec
            ] as [String : Any]
            
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
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    
    //MARK: - Animatioin
    private func moveImageView() {
        centreConstraint.isActive.toggle()
        defaultLeftConstraintOfPlankImage.constant = imageIsMoved ? -170 : view.frame.size.width/2 - 80
        imageIsMoved = !imageIsMoved
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - showAlert
    private func showAlert() {
        let alert = UIAlertController(title: "Stop？", message: "やめたら記録は保存しないぞ！", preferredStyle: .alert)
        
        let continuous = UIAlertAction(title: "continue", style: .default) { [self] (_) in
            moveImageView()
            isEnableButtonsStatus()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimer), userInfo: nil, repeats: true)
            currentActionStatus = .plank
            setButtonTitle(actionStatus: currentActionStatus)
        }
        
        let stop = UIAlertAction(title: "stop", style: .destructive) { [self] (_) in
            
            timerInt = defaultSec
            timerLabel.text = String(timerInt)
            currentActionStatus = .idel
            setButtonTitle(actionStatus: currentActionStatus)
        }
        
        alert.addAction(stop)
        alert.addAction(continuous)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - NavigationBarButton
    @IBAction private func tappedSetTimerButton(_ sender: Any) {
        presentModalFullScreen(storyboradName: "SettingTimer")
    }
}


//test01@gmail.com
