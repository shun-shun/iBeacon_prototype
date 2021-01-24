//
//  UserService.swift
//  iBin.samples
//
//  Created by 小松周矢 on 2020/12/15.
//

import Foundation

class UserService {
    
    typealias Complate = (_ uid:String?) -> Void
    
    var userRepository: UserRepository
    
    init() {
        userRepository = UserRepository()
    }
    
    // ログイン済みかの確認
    func isLogin() -> Bool {
        let login = userRepository.isLogin()
        return login
    }
    
    // ログイン処理
    func signIn(email: String, password: String, complate:@escaping Complate) {
        userRepository.signIn(email: email, password: password, complateLogin: { uid in
            guard uid != nil else {
                complate(nil)
                return
            }
            complate(uid)
        })
    }
    
    // アカウント登録処理
    func create(email:String, password: String, complate:@escaping Complate) {
        userRepository.userCreate(email: email, password: password, complateCreate: { result in
            if result {
                //作成できた場合
                self.signIn(email: email, password: password, complate: { uid in
                    if uid != nil {
                        //ログイン成功時
                        complate(uid!)
                    } else {
                        //ログイン失敗時
                        complate(nil)
                    }
                })
            } else {
                //作成できない場合
                complate(nil)
            }
        } )
    }
}
