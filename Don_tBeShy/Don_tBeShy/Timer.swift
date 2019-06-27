//
//  Timer.swift
//  Don_tBeShy
//
//  Created by 전창민 on 28/06/2019.
//  Copyright © 2019 min. All rights reserved.
//

import Foundation

extension CalendarViewController {
    
    func runTimer() {
        //아예 처음에 통신이 실패하였을 때, 조건 찾기가 어려워서 실패시 따로 타이머를 걸어주었다.
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if isTimerRunning {
            seconds -= 1
        }
        

        if seconds == 0 {
            
            self.setPeriod()
            self.setBtn()
            
            //isTimerRunning = false
            seconds = 10
            //timer.invalidate()
        }
    }

    
}

