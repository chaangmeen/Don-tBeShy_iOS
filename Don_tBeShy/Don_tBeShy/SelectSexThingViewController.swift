//
//  SelectSexThingViewController.swift
//  Don_tBeShy
//
//  Created by 전창민 on 27/06/2019.
//  Copyright © 2019 min. All rights reserved.
//

import UIKit

class SelectSexThingViewController: UIViewController {
    
    @IBOutlet weak var condomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTouchSetting()
        // Do any additional setup after loading the view.
    }
    
    func setTouchSetting() {
        
        condomView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goDetailView))
        tap.numberOfTapsRequired = 1
        condomView.addGestureRecognizer(tap)
        
    }
    
    @objc func goDetailView() {
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
