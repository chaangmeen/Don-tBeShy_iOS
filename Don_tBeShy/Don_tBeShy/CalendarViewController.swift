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
    var entireDates : [DateData] = []
    var periodDates : [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendarDefaultSetting()
        calendar.today = today
        showIndicator()
        getPeriod { result in
            for (_,sub) : (String,JSON) in result {
                
                let dateString = sub["date"].stringValue
                let state = sub["state"].intValue
                self.processingData(dateString: dateString)
                self.entireDates.append(DateData(state: state, date: dateString, buttonStatus: 1))
                self.selectPeriodDates(dates: self.periodDates)
                self.calendar.reloadData()

            }
        }
        // Do any additional setup after loading the view.
    }
    
    func processingData(dateString: String) {
        let subString = String(dateString[0..<10]!)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date : Date = dateFormatter.date(from: subString)!
        let returnDate = date.addingTimeInterval(3600*24)
        periodDates.append(returnDate)
    }
    
    func getPeriod(completion : @escaping (JSON) -> Void ) {
        
        let param : Parameters = ["id":"kmw811", "year":"2019", "month":"6"]
        
        Alamofire.request("http://10.10.2.137:3000/calendar", method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                self.stopAnimating(nil)
                if let dataFromString = response.result.value {
                    let json = JSON(dataFromString)
                    completion(json)
                }
            case .failure:
                self.stopAnimating(nil)
                print("실패")
            }
        }
        
    }
    
    func showIndicator() {
        let size = CGSize(width: 30, height: 30)
        let indicatorType = presentingIndicatorTypes[1]
        
        startAnimating(size, message: "기다려 주세요..", type: indicatorType, fadeInAnimation: nil)
 
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

extension CalendarViewController : FSCalendarDelegate , FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarDefaultSetting() {
        
        calendar.allowsMultipleSelection = true
        calendar.formatter.locale = Locale(identifier: "ko_kr")
        calendar.formatter.timeZone = TimeZone(abbreviation: "KST")
        calendar.locale = Locale(identifier: "ko_kr")
        calendar.appearance.headerDateFormat = "yyyy MMM"
        calendar.appearance.headerTitleColor = UIColor(hex: 0xFB5F26)
        calendar.appearance.weekdayTextColor = UIColor(hex: 0xfb9926)
        calendar.appearance.selectionColor = UIColor.white
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    func selectPeriodDates( dates : [Date]) {
        
        self.calendar.appearance.selectionColor = .red
        
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        

    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if periodDates.contains(date) {
            return .orange
        }
        return UIColor.red
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.performSegue(withIdentifier: "modalView", sender: self)
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if let today = calendar.today {
            if date == today {
                return "Today"
            }
        } else {
            
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
