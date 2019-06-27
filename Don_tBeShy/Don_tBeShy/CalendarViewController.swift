//
//  CalendarViewController.swift
//  ManageParkingBrother
//
//  Created by 전창민 on 24/12/2018.
//  Copyright © 2018 parkingbrother. All rights reserved.
//

import UIKit
import FSCalendar
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class CalendarViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()

    
    var dateStart = Date()
    var dateEnd = Date()
    var defaultSelectDate = Date()
    var dayCategory = ""
    var today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendarDefaultSetting()
        calendar.today = today
        showIndicator()

        // Do any additional setup after loading the view.
        
    }
    
    func showIndicator() {
        let size = CGSize(width: 30, height: 30)
        let indicatorType = presentingIndicatorTypes[1]
        
        startAnimating(size, message: "Loading...", type: indicatorType, fadeInAnimation: nil)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//            self.stopAnimating(nil)
//        }
    }
    
    
    func initLabelSetting() {
        yearLabel.text = defaultSelectDate.year
        dateLabel.text = "\(defaultSelectDate.month)월 \(defaultSelectDate.day)일 (\(defaultSelectDate.weekday))"
    }
    
    @IBAction func leftSwipeButton(_ sender: Any) {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)
        calendar.setCurrentPage(previousMonth!, animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)
        calendar.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func setAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension CalendarViewController : FSCalendarDelegate , FSCalendarDataSource {
    
    func calendarDefaultSetting() {
        calendar.formatter.locale = Locale(identifier: "ko_kr")
        calendar.formatter.timeZone = TimeZone(abbreviation: "KST")
        calendar.locale = Locale(identifier: "ko_kr")
        calendar.appearance.headerDateFormat = "yyyy MMM"
        calendar.appearance.headerTitleColor = UIColor(hex: 0xFB5F26)
        calendar.appearance.weekdayTextColor = UIColor(hex: 0xfb9926)
        calendar.appearance.selectionColor = UIColor(red:0.97, green:0.76, blue:0.14, alpha:1.0)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.performSegue(withIdentifier: "modalView", sender: self)
        

        //        yearLabel.text = date.year
        //        dateLabel.text = "\(date.month)월 \(date.day)일 (\(date.weekday))"
        
        if dayCategory == "start" {
            dateStart = date
        } else {
            dateEnd = date
        }

    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
  
        return true
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if let today = calendar.today {
            if date == today {
                return "Today"
            }
        }
        return nil
    }
}
extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}
