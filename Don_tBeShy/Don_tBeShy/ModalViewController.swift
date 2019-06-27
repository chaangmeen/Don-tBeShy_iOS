//
//  ModalViewController.swift
//  Don_tBeShy
//
//  Created by 전창민 on 27/06/2019.
//  Copyright © 2019 min. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    @IBOutlet weak var periodStartBtn: UIButton!
    @IBOutlet weak var periodEndBtn: UIButton!
    
    let orangeColor = UIColor(hex: 0xFB9926)
    let grayColor = UIColor(hex:0xA0A0A0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func periodStart(_ sender: Any) {
        //end button background
        periodEndBtn.setTitleColor( .white, for: .normal)
        periodEndBtn.backgroundColor = grayColor
        periodStartBtn.setTitleColor(.black, for: .normal)
        periodStartBtn.backgroundColor = orangeColor
        
    }
    
    @IBAction func periodEnd(_ sender: Any) {
        //start button background
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
        
    }
    
}
