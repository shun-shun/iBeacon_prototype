//
//  UserData.swift
//  iBin.samples
//
//  Created by 小松周矢 on 2020/12/15.
//

import Foundation

class UserData {
    var user_no: String
    var mail: String
    var password: String
    var user_name: String
    var student_class: String
    var student_no: String
    
    init(user_no: String, mail: String, password: String, user_name: String, student_class: String, student_no: String) {
        self.user_no = user_no
        self.mail = mail
        self.password = password
        self.user_name = user_name
        self.student_class = student_class
        self.student_no = student_no
    }
    
    init(src:[String:String]) {
        self.user_no = src["user_no"]!
        self.mail = src["mail"]!
        self.password = src["password"]!
        self.user_name = src["user_name"]!
        self.student_class = src["student_class"]!
        self.student_no = src["student_no"]!
    }
    
    func toDictionary() -> [String:String?] {
        return [
            "user_no":user_no,
            "mail" : mail,
            "password" : password,
            "user_name" : user_name,
            "student_class" : student_class,
            "student_no" : student_no,
        ]
    }
}
