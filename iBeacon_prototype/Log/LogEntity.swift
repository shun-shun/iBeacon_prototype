//
//  logEntity.swift
//  iBin.samples
//
//  Created by 我妻花音 on 2020/12/22.
//

import Foundation
class LogEntity{
    var logEntity = [LogData]()
    
    func addLog(data: LogData) -> Void {
        logEntity.append(data)
    }
}
