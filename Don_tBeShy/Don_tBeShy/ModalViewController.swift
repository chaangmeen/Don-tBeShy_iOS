//
//  ModalViewController.swift
//  Don_tBeShy
//
//  Created by 전창민 on 27/06/2019.
//  Copyright © 2019 min. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ModalViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    @IBOutlet weak var periodStartBtn: UIButton!
    @IBOutlet weak var periodEndBtn: UIButton!
    
    @IBOutlet weak var safeBtn: UIButton!
    @IBOutlet weak var unSafeBtn: UIButton!
    
    let pinkColor = UIColor(hex: 0xE6287B)
    let grayColor = UIColor(hex:0xA0A0A0)
    
    var selectDay = Date()
    var userID = ""
    var type = 1
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    func showIndicator() {
        let size = CGSize(width: 30, height: 30)
        let indicatorType = presentingIndicatorTypes[1]
        startAnimating(size, message: "기다려 주세요..", type: indicatorType, fadeInAnimation: nil)
    }
    
    @IBAction func safeAction(_ sender: Any) {
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        safeBtn.setTitleColor(.white, for: .normal)
        safeBtn.backgroundColor = pinkColor
    }
    
    
    @IBAction func unSafeAction(_ sender: Any) {
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor(.white, for: .normal)
        unSafeBtn.backgroundColor = pinkColor
    }
    
    @IBAction func periodStart(_ sender: Any) {
        //end button background
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor(.white, for: .normal)
        periodStartBtn.backgroundColor = pinkColor
        
    }
    
    @IBAction func periodEnd(_ sender: Any) {
        //start button background
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        periodEndBtn.setTitleColor(.white, for: .normal)
        periodEndBtn.backgroundColor = pinkColor
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }

    @IBAction func backgroundDissmissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        //생리  시작 , 끝  통신할 것 .
        showIndicator()
        sendDate {
            print("성공")
            print(self.presentingViewController)
            if let vc = self.presentingViewController as? CalendarViewController {
                
                vc.setPeriod()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func sendDate(completion: @escaping () -> Void) {
        print("생리 / 섹스 날짜 보내기")
        let sendDate = selectDay.addingTimeInterval(3600*24)
        var type = 2
        if safeBtn.backgroundColor == pinkColor {
            type = 3
        } else if unSafeBtn.backgroundColor == pinkColor {
            type = 4
        } else {
            type = 2
        }
        
        
        let param : Parameters = ["id":"\(userID)",
            "type":"\(type)",
            "year":"\(sendDate.year)",
            "month":"\(sendDate.month)",
            "day":"\(sendDate.day)",
            ]
        Alamofire.request("http://10.10.2.137:3000/addcalendar", method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseString { response in
            print(response)
            switch response.result {
            case .success:
                completion()
            case .failure:
                print("실패")
            }
        }
        
    }
}
