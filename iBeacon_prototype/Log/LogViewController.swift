//
//  logController.swift
//  iBin.samples
//
//  Created by 我妻花音 on 2020/12/22.
//

import UIKit
import CoreLocation

class LogController : UIViewController, CLLocationManagerDelegate{
    
    // 位置情報インスタンス変数(CLLocationManager)
    var myLocationManager:CLLocationManager!
    // ビーコン通信インスタンス変数(CLBeaconRegion)
    var myBeaconRegion:CLBeaconRegion!
    
    let logService = LogService()
    
    //  UUIDに対応して変えるけどどうしよう
    
    @IBOutlet weak var dateTimeNow: UILabel!
    @IBOutlet weak var regionInOut: UILabel!
    @IBOutlet weak var regionNumber: UILabel!
    @IBOutlet weak var distanceBeacon: UILabel!
    @IBOutlet weak var uuidNumber: UILabel!
    
    let UUIDList = [
        //"D546DF97-4757-47EF-BE09-3E2DCBDD0C77",
        "FDA50693-A4E2-4FB1-AFCF-C6EB07647825",
    ]
    
    //日時の記録(日本時間)
    func datejapan(){
        let dateTimeNow = DateFormatter()
        dateTimeNow.dateStyle = .short
        dateTimeNow.timeStyle = .medium
        print(dateTimeNow.string(from: Date()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 位置情報インスタンスの設定
        myLocationManager = CLLocationManager()
        // バックグランドモードでの位置情報使用許可設定
        myLocationManager.allowsBackgroundLocationUpdates = true;
        // 位置情報用メソッドの継承
        myLocationManager.delegate = self
        // 位置情報の精度の設定(kCLLocationAccuracyBest=最高精度)
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定(1 = 1m移動したら位置情報を更新)
        myLocationManager.distanceFilter = 1
        // 位置情報取得をユーザに通知
        switch myLocationManager.authorizationStatus {
        case .notDetermined,.denied, .restricted, .authorizedWhenInUse:
            // 未選択状態であれば、許可確認する
            myLocationManager.requestAlwaysAuthorization()
            break
        default:
            // 許可状態であれば何もしない
            break
        }
    }
    //Regionの探索が開始されたとき
    private func startMyMonitoring() {
        for i in 0 ..< UUIDList.count {
            // UUID型に変換
            let uuid: NSUUID! = NSUUID(uuidString: "\(UUIDList[i].lowercased())")
            // ビーコンIDを設定
            let identifierStr: String = "HCS_BEACON_ID_\(i)"
            // ビーコンインスタンスを生成
            myBeaconRegion = CLBeaconRegion(uuid: uuid as UUID, identifier: identifierStr)
            // 画面起動時かつ、ロック中画面が表示されたときにBeaconの状態（内側にいるか外側にいるか）を確認するかどうか。defaultはfalse
            myBeaconRegion.notifyEntryStateOnDisplay = false
            // Beacon領域に入ったときのdelegateからの通知がいらないときはfalse。defaultはtrue
            myBeaconRegion.notifyOnEntry = true
            // Beacon領域から出たときのdelegateからの通知がいらないときはfalse。defaultはtrue
            myBeaconRegion.notifyOnExit = true
            // Beaconの測定を開始
            myLocationManager.startMonitoring(for: myBeaconRegion)
            
            // FIXME: 画面表示するUUIDは配列の先頭と決め打ちしているため、動的に変えるべき
            uuidNumber.text = UUIDList[0]
        }
    }
    
    // 位置認証のステータスが変更された時に実行される
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let result = logService.didChangeAuthorize(status: status)
        if result {
            // 位置情報を利用可能な場合
            startMyMonitoring()
        } else {
            myLocationManager.requestAlwaysAuthorization()
        }
    }
    
    // 観測の開始に成功すると実行される
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region);
    }
    
    // 領域内にいるかどうかを判定する
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let log = logService.didDetermineState(manager: manager, state: state, for: region)
        // 領域内であることを確認する
        if log.regionNumber == 1 {
            start(manager, region)
        }
    }
    
    // ①領域内にいる場合に実行される
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let entity = logService.didRangeBeacons(manager: manager, didRangeBeacons: beacons, in: region)
        // TODO: 取得したビーコンを元に出席登録を行う 以下はデバッグ用
        if !entity.logEntity.isEmpty {
            let log = entity.logEntity[0]
            let date = log.dateTimeNow
            let dist = log.distanceBeacon
            let inou = log.regionInOut
            let uuid = log.uuidNumber
            print("date:\(date)  uuid:\(uuid) inout:\(inou) + dist:\(String(describing: dist))")
        }
        //----------------------------------ここまで
    }
    
    // ②領域内に入った場合に実行される
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        logService.didEnterRegion(manager: manager, didEnterRegion : region)
        start(manager, region)
    }
    
    // ③領域内から出た場合に実行される
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        logService.didExitRegion(manager: manager, didExitRegion: region)
        stop(manager, region)
    }
    
    fileprivate func start(_ manager: CLLocationManager, _ region: CLRegion) {
        // UUIDを取得(regionのIDがnilであることがないのでアンラッピング)
        let uuid = UUID(uuidString: UUIDList[0])!
        // ビーコンインスタンスを生成
        let beacon = CLBeaconIdentityConstraint(uuid: uuid)
        // ビーコンと通信を行う(領域外へ出るまでは①〜③が実行される)
        manager.startRangingBeacons(satisfying: beacon)
    }
    
    fileprivate func stop(_ manager: CLLocationManager, _ region: CLRegion) {
        // UUIDを取得(regionのIDがnilであることがないのでアンラッピング)
        let uuid = UUID(uuidString: UUIDList[0])!
        // ビーコンインスタンスを生成
        let beacon = CLBeaconIdentityConstraint(uuid: uuid)
        // ビーコンと通信を行う(領域外へ出るまでは①〜③が実行される)
        manager.stopRangingBeacons(satisfying: beacon)
    }
}
