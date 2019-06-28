//
//  DateExtension.swift
//  ManageParkingBrother
//
//  Created by 전창민 on 25/12/2018.
//  Copyright © 2018 parkingbrother. All rights reserved.
//

import Foundation
let timeData  = ["1","2","3","4","5","6","7","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]

let hourDataString = ["00","01","02","03","04","05","06","07","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
let miniuteDataString = ["00" , "10", "20", "30", "40", "50"]
extension Date {
    
    var month : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: self)
        
    }
    var year : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: self)
        
    }
    
    var day : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: self)
    }
    
    var weekday : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter.string(from: self)
        
    }
    
    var time : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
        
    }
    
    var AMorPM : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
        
    }
    
}
