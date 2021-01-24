//
//  UserEntity.swift
//  iBin.samples
//
//  Created by 小松周矢 on 2020/12/15.
//

import Foundation

class UserEntity {
    var userEntity = [UserData]()
    
    func addUser(data: UserData) -> Void {
        userEntity.append(data)
    }
}
