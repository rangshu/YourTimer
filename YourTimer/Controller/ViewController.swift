//
//  ViewController.swift
//  YourTimer
//
//  Created by SooRin Kim on 16/07/2019.
//  Copyright © 2019 SooRin Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minSecLabel: UILabel!
    
    var timer: Timer?
    var time: Double = 0.0
    var isTimerRunning: Bool = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataFilePath)
        hourLabel.text = ""
        
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        
        if device.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: device)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: device)
        }
    }
    
    @objc func proximityChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            device.proximityState ? timerStart(): self.timer?.invalidate()
        }
    }
    
    //MARK: - Time Label
    @objc func updateTimer() {
        time += 0.01
        updateTimeLabelText(with: time)
    }
    
    func updateTimeLabelText(with time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let hour: Int = Int(time.truncatingRemainder(dividingBy: 1) * 60)
        
        let timeText = String(format: "%02ld:%02ld", minute, second)
        
        hourLabel.text = hour == 0 ? "" : String(hour)
        minSecLabel.text = timeText
    }
    
    func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    //MARK: - Button functions
    @IBAction func pressedResetButton(_ sender: UIButton) {
        resetTimer()
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        let newTimeData = Times(context: self.context)
        newTimeData.id = UUID.init()
        newTimeData.time = time
        
        print(newTimeData.id!)
        print(newTimeData.time)
        saveTime()
    }
    
    //MARK: - Data Manipulation
    func saveTime() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        time = 0.0
        hourLabel.text = ""
        minSecLabel.text = "00:00"
    }
}

