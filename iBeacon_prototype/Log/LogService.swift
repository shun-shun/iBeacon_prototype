//
//  logService.swift
//  iBin.samples
//
//  Created by 我妻花音 on 2020/12/22.
//

import Foundation
import CoreLocation

class LogService{
    
    var logRepository:LogRepository!
    
    init(){
        logRepository = LogRepository()
    }
    
    // 認証ステータスに応じ振り分ける処理(false->不可,true->可能)
    func didChangeAuthorize(status : CLAuthorizationStatus) -> Bool {
        
        printDate("位置情報に対する認証が変更されました")
        
        switch (status) {
        case .notDetermined:
            printDate("未決定の場合")
            return false
        case .restricted:
            printDate("位置情報を利用できない制限がある場合")
            return false
        case .denied:
            printDate("許可しない場合")
            return false
        case .authorizedAlways:
            printDate("常に許可した場合")
            return true
        case .authorizedWhenInUse:
            printDate("使用中のみ許可した場合")
            return true
        default :
            return false
        }
    }
    
    // 領域内であるかどうかを測定する
    func didDetermineState(manager: CLLocationManager,state: CLRegionState, for region: CLRegion) -> LogData {
        
        printDate("領域内であるか測定中")
        let date = getDate()
        let uuid = region.identifier
        
        switch (state) {
        case .inside:
            let regionNumber = 1
            let regionInOut = "inside"
            let log = LogData(dateTimeNow: date, regionInOut: regionInOut, regionNumber: regionNumber, uuidNumber: uuid)
            return log
        case .outside:
            let regionNumber = 0
            let regionInOut = "outside"
            let log = LogData(dateTimeNow: date, regionInOut: regionInOut, regionNumber: regionNumber, uuidNumber: uuid)
            return log            
        case .unknown:
            let regionNumber = 0
            let regionInOut = "outside"
            let log = LogData(dateTimeNow: date, regionInOut: regionInOut, regionNumber: regionNumber, uuidNumber: uuid)
            return log
        }
    }
    //レンジング中にiBeacon情報が到着したとき
    func didRangeBeacons(manager: CLLocationManager,didRangeBeacons beacons: [CLBeacon],in region: CLBeaconRegion) -> LogEntity {
        let entity = LogEntity()
        
        guard beacons.count > 0 else {
            // ビーコンが取得できない場合は空を返す
            return entity
        }
        
        
        for i in 0 ..< beacons.count {
            let date = getDate()
            let beacon = beacons[i]
            let beaconUUID = beacon.uuid.description
            let minorID = beacon.minor;
            let majorID = beacon.major;
            let rssi = beacon.rssi;
            let proximity = beacon.proximity
            switch (proximity) {
            case .unknown :
                let log = LogData(dateTimeNow: date, regionInOut: "outside", regionNumber: 0, uuidNumber: beaconUUID)
                log.distanceBeacon = "Unknown"
                // FIXME: minorやmajor、rssiをlogに格納するべきだと思われ
                entity.addLog(data: log)
                break
            case .far:
                let log = LogData(dateTimeNow: date, regionInOut: "inside", regionNumber: 1, uuidNumber: beaconUUID)
                log.distanceBeacon = "Far"
                // FIXME: minorやmajor、rssiをlogに格納するべきだと思われ
                entity.addLog(data: log)
                break
            case .near:
                let log = LogData(dateTimeNow: date, regionInOut: "inside", regionNumber: 1, uuidNumber: beaconUUID)
                log.distanceBeacon = "Near"
                // FIXME: minorやmajor、rssiをlogに格納するべきだと思われ
                entity.addLog(data: log)
                break
            case .immediate:
                let log = LogData(dateTimeNow: date, regionInOut: "inside", regionNumber: 1, uuidNumber: beaconUUID)
                log.distanceBeacon = "Immediate"
                // FIXME: minorやmajor、rssiをlogに格納するべきだと思われ
                entity.addLog(data: log)
                break
            default :
                // 状態不明
                let log = LogData(dateTimeNow: date, regionInOut: "unkown", regionNumber: 0, uuidNumber: beaconUUID)
                entity.addLog(data: log)
                break
            }
        }
        return entity
    }
    
    func didEnterRegion(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        printDate("探索条件に合致したビーコン領域に入りました")
    }
    
    func didExitRegion(manager: CLLocationManager, didExitRegion region: CLRegion){
        printDate("探索条件に合致したビーコン領域から出ました")
    }
    
    
    //    時間で制御するためのメソッド
    //    func timeAction(){
    //        if (dateTimeNow <= 15){
    //
    //        }
    //    }
    
    fileprivate func printDate(_ message:String) {
        let f = getDateFormatter()
        print(f.string(from: Date()) + " \(message)")
    }
    
    fileprivate func getDateFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .medium
        return f
    }
    
    fileprivate func getDate() -> String {
        let f = getDateFormatter()
        return f.string(from: Date())
    }
}

