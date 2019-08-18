//
//  ViewController.swift
//  YourTimer
//
//  Created by SooRin Kim on 16/07/2019.
//  Copyright © 2019 SooRin Kim. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents

class ViewController: UIViewController {
    
    @IBOutlet weak var minSecLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var resetBtn: MDCButton!
    @IBOutlet weak var saveBtn: MDCButton!
    
    var testTimes = [Times]()
    let buttonScheme = MDCButtonScheme()
    
    var timer: Timer?
    var startDate: Date?
    var time: Double = 0.0
    var isTimerRunning: Bool = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataFilePath)
        
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: resetBtn)
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: saveBtn)
        
        resetBtn.setTitle("초기화", for: .normal)
        saveBtn.setTitle("저장", for: .normal)
        
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: device)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: device)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Error : Button touch target does not meet minimum size guidlines of (48, 48). 해결
        let verticalInset = min(0, (self.resetBtn.bounds.height - 48) / 2)
        resetBtn.hitAreaInsets = UIEdgeInsets(top: verticalInset, left: 0, bottom: verticalInset, right: 0)
        saveBtn.hitAreaInsets = UIEdgeInsets(top: verticalInset, left: 0, bottom: verticalInset, right: 0)
    }
    
    @objc func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            device.proximityState ? timerStart(): self.timer?.invalidate()
        }
    }
    
    //MARK: - Action Handling
    //Add the button handlers
    @objc func didTapReset(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSave(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Time Label
    @objc func updateTimer() {
        time += 0.01
        updateTimeLabelText(with: time)
    }
    
    func updateTimeLabelText(with time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 60)
        
        let timeText = String(format: "%02ld:%02ld", minute, second)
        
        hourLabel.text = minute >= 60 ? String(Int(minute / 60)) : ""
        minSecLabel.text = timeText
    }
    
    func timerStart() {
        if startDate == nil {
            startDate = Date()
            print(startDate)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    //MARK: - Button functions
    @IBAction func pressedResetButton(_ sender: UIButton) {
        resetTimer()
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        // TODO: startDate가 nil이면, 저장할데이터가 없다는 alert 띄우기
        let newTimeData = Times(context: self.context)
        newTimeData.id = UUID.init()
        newTimeData.start = startDate
        newTimeData.time = time
        
        saveTime()
        print(startDate)
    }
    
    //MARK: - Data Manipulation
    //MARK: - Data Manipulation
//    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func saveTime() {
        do {
            if startDate != nil {
                try context.save()
                print("Complete Save")
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadTimes(with request: NSFetchRequest<Times> = Times.fetchRequest()) {
        do {
            testTimes = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        print(testTimes[testTimes.count-1].start)
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        time = 0.0
        hourLabel.text = ""
        minSecLabel.text = "00:00"
        startDate = nil
    }
    
    //MARK: - Class Methods
    //MARK: - UIColorFromRGB
    class func UIColorFromRGB(rgb: Int) -> UIColor {
        return UIColor(red: CGFloat(((Float)((rgb & 0xFF0000) >> 16)/255.0)),
                       green: CGFloat(((Float)((rgb & 0xFF00) >> 8)/255.0)),
                       blue: CGFloat((Float)(rgb & 0xFF)/255.0),
                       alpha: 1.0)
    }
    
}

