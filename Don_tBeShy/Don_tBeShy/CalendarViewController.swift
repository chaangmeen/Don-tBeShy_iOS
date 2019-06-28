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
    @IBOutlet weak var sexButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var sexLabel: UILabel!
    
    var isTimerRunning = false
    var seconds = 10
    var timer = Timer()
    var selectDate: Date?
    var sexState : Int = 0
    
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var dateStart = Date()
    var dateEnd = Date()
    
    var defaultSelectDate = Date()
    var dayCategory = ""
    var today = Date()
    
    // 1번 sex , 2번 생리
    var entireDates : [DateData] = [] // 전체 날 모음
    var periodDates : [Date] = []// 생리 한 날 모음
    var sexDates : [Date] = []// 관계 가진 날
    var wrongSexDates : [Date] = []
    var userID = "kmw811"
    let beforeColor = UIColor(hex: 0xF3FFCB)
    let afterSendColor = UIColor(hex: 0xFFE7C6)
    let afterReceiveColor = UIColor(hex:0xFFCBCB )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showAlert(title: "선택", message: "예 => aaaa , 아니요 => kwm811")
        calendar.delegate = self
        calendar.dataSource = self
        calendarDefaultSetting()
        calendar.today = dateEnd
        //지워야한다.
        
        // Do any additional setup after loading the view.
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPeriod()
    }
    
    
    func setPeriod() {

        print(" \(userID) 보낼때 status : \(sexState)")
        
        showIndicator()
        
        getPeriod { result in
            print(result)
            for (_,sub) : (String,JSON) in result {
                let dateString = sub["date"].stringValue
                let state = sub["state"].intValue
                if state == 3 {
                    self.processingSexData(dataString: dateString)
                }
                if state == 2 {
                    self.processingPeriodData(dateString: dateString)
                }
                if state == 4 {
                    self.processingUnSaftySexData(dataString: dateString)
                }
                self.entireDates.append(DateData(state: state, date: dateString, buttonStatus: state))
                self.calendar.reloadData()
                self.calendar.allowsMultipleSelection = false
                self.setBtn()
                
            }
        }
    }
    
    func setBtn() {
        getBtnStatus { json in
            self.sexState = json["state"].intValue
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
        refreshButton.transform = refreshButton.transform.rotated(by: CGFloat(M_PI_2))
        
        setBtn()
    }
    
    func processingPeriodData(dateString: String) {
        let subString = String(dateString[0..<10]!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date : Date = dateFormatter.date(from: subString)!
        periodDates.append(date)
    }
    
    func processingSexData(dataString: String) {
        let subString = String(dataString[0..<10]!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date : Date = dateFormatter.date(from: subString)!
        sexDates.append(date)
    }
    
    func processingUnSaftySexData(dataString: String) {
        let subString = String(dataString[0..<10]!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date : Date = dateFormatter.date(from: subString)!
        wrongSexDates.append(date)
    }
    
    func getPeriod(completion : @escaping (JSON) -> Void ) {
        
        let param : Parameters = ["id":"\(self.userID)", "year":"2019", "month":"6"]
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
    
    func getBtnStatus( completion : @escaping (JSON) -> Void) {
        
        let month = calendar.today?.month
        print(month)
        
        let param : Parameters = ["id":"\(self.userID)", "year":"2019", "month":"6"]
        showIndicator()
        Alamofire.request("http://10.10.2.137:3000/btn", method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
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
    
    @IBAction func sexAction(_ sender: Any) {
        
        if let imageView = sexButton.imageView {
            if let image = imageView.image {
                if image == UIImage(named: "beforeSend") {
                    sexButton.setImage(UIImage(named: "afterSend"), for: .normal)
                } else {
                    sexButton.setImage(UIImage(named: "beforeSend"), for: .normal)
                }
            }
        }
        sendSexAction(completion: { json in
            print(json)
        })
    }

    
    
    func sendSexAction( completion : @escaping (JSON)-> Void) {
        
        print(" \(userID) 보낼때 status : \(sexState)")
        
        let param : Parameters = ["id":"\(userID)", "state":"\(self.sexState)"]
        
        Alamofire.request("http://10.10.2.137:3000/btnclick", method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalView" {
            if let vc = segue.destination as? ModalViewController {
                if let day = self.selectDate {
                    vc.selectDay = day
                    vc.userID = self.userID
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
            UserDefaults.standard.set(true, forKey: "bool")
            //self.setPeriod()
            
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { _ in
            UserDefaults.standard.set(false, forKey: "bool")
            //self.setPeriod()
            
        })

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sexAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
            print("확인후")
            self.setPeriod()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CalendarViewController : FSCalendarDelegate , FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarDefaultSetting() {
        calendar.allowsMultipleSelection = true
        calendar.formatter.locale = Locale(identifier: "ko_kr")
        calendar.formatter.timeZone = TimeZone(abbreviation: "KST")
        calendar.locale = Locale(identifier: "ko_kr")
        calendar.appearance.headerDateFormat = "yyyy MMM"
        calendar.appearance.headerTitleColor = UIColor(hex: 0xffffff)
        calendar.appearance.weekdayTextColor = UIColor(hex: 0x94e6ff)
        calendar.appearance.selectionColor = UIColor.lightGray
        calendar.appearance.borderRadius = 5.0
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectDate = date
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.performSegue(withIdentifier: "modalView", sender: self)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if dateStart.compare(date) == .orderedAscending {
            return false
        }
        return true
    }
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        if periodDates.contains(date) {
            return UIImage(named: "blood")
        } else if sexDates.contains(date) {
            return sexDates.contains(date) ? UIImage(named: "heart1") : nil
        } else if wrongSexDates.contains(date) {
            return UIImage(named: "heart2")
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
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
