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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    

}
