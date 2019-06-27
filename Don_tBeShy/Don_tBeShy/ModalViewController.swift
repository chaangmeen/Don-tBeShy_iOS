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

class ModalViewController: UIViewController {

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    @IBOutlet weak var periodStartBtn: UIButton!
    @IBOutlet weak var periodEndBtn: UIButton!
    
    @IBOutlet weak var safeBtn: UIButton!
    @IBOutlet weak var unSafeBtn: UIButton!
    
    let orangeColor = UIColor(hex: 0xFB9926)
    let grayColor = UIColor(hex:0xA0A0A0)
    
    var selectDay = Date()
    var userID = ""
    var type = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectDay)
        print(selectDay.day)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func safeAction(_ sender: Any) {
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        safeBtn.setTitleColor(.black, for: .normal)
        safeBtn.backgroundColor = orangeColor
        
    }
    
    
    @IBAction func unSafeAction(_ sender: Any) {
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor(.black, for: .normal)
        unSafeBtn.backgroundColor = orangeColor
    }
    
    @IBAction func periodStart(_ sender: Any) {
        //end button background
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor(.black, for: .normal)
        periodStartBtn.backgroundColor = orangeColor
        
    }
    
    @IBAction func periodEnd(_ sender: Any) {
        //start button background
        safeBtn.setTitleColor( .white, for: .normal)
        safeBtn.backgroundColor = grayColor
        unSafeBtn.setTitleColor( .white, for: .normal)
        unSafeBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor( .white, for: .normal)
        periodStartBtn.backgroundColor = grayColor
        periodEndBtn.setTitleColor(.black, for: .normal)
        periodEndBtn.backgroundColor = orangeColor
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
        sendDate {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func sendDate(completion: @escaping () -> Void) {
        
        let param : Parameters = ["id":"\(userID)",
            "type":"\(1)",
            "year":"\(selectDay.year)",
            "month":"\(selectDay.month)",
            "day":"\(selectDay.day)",
            ]
        print(param)
        
        Alamofire.request("http://10.10.2.137:3000/addcalendar", method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                if let dataFromString = response.result.value {
                    let json = JSON(dataFromString)
           
                }
            case .failure:
                print("실패")
            }
        }
        
    }
}
