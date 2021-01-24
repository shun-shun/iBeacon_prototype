//
//  logRepository.swift
//  iBin.samples
//
//  Created by 我妻花音 on 2020/12/22.
//

import Foundation
import Firebase

class LogRepository{
    
    var userDate : UserData!
    var logEntity : LogEntity!
    var ref : DatabaseReference!
    var userRepository : UserRepository!
    
    //出席情報をDBに書き出し
    func Attendwrite() -> Void {
        
//        var cl:String
//        var number:String
//        var name:String
//        var student_name:String?
//        var student_class:String?
//        var student_no:String?
//        var clroom:String
//        var time:String
//
//        var uid:String = userRepository.getUid()
//        ref = Database.database().reference()
//
//        ref.child("user").observe(DataEventType.value, with: {(snapshot) in
//            if let values = snapshot.value as? NSDictionary {
//                for (key, val) in values {
//                    let ob: NSDictionary! = val as? NSDictionary
//
//                    student_name = ob.value(forKey:"student_name") as! String
//                    student_class = ob.value(forKey:"student_class") as! String
//                    student_no = ob.value(forKey:"student_no") as! String
//                }
//            }
//        }) { (errer) in
//            print(errer.localizedDescription)
//        }
//
//        cl = student_class!
//        number = student_no!
//        name = student_name!
////        clroom =
////        time =
//
//        var date = [
//            "class":cl,
//            "numbaer":number,
//            "name":name,
////            "classroom":clroom,
////            "time":time
//        ] as [String : Any]
//        ref.child("attend").childByAutoId().setValue(date)
    }
}
