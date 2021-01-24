//
//  logData.swift
//  iBin.samples
//
//  Created by 我妻花音 on 2020/12/22.
//

import Foundation

class LogData{
    var dateTimeNow : String
    var regionInOut : String
    var regionNumber : Int
    // クラス生成時に取得できない場合があるため、nilを許容
    var distanceBeacon : String?
    var uuidNumber : String
    
    
    init(dateTimeNow : String,regionInOut : String, regionNumber : Int, uuidNumber:String){
        self.dateTimeNow = dateTimeNow
        self.regionInOut = regionInOut
        self.regionNumber = regionNumber
        self.uuidNumber = uuidNumber
    }
}

