//
//  timer.swift
//  workingTitle
//
//  Created by C4Q on 4/18/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol hackTimerDelegate: class {
    func updateTimer(time: String)
}

class hackTimer{
    weak var delegate: hackTimerDelegate?
    var countdownTimer: Timer!
    var timerLabelText = "" {
        didSet{
            self.delegate?.updateTimer(time: timerLabelText)
        }
    }
    var totalTime = 60
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTime() {
        timerLabelText = "time left: \(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        timerLabelText = "DONE!!!"
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
