//
//  UserRepository.swift
//  iBin.samples
//
//  Created by 小松周矢 on 2020/12/15.
//

import Foundation
import Firebase

class UserRepository {
    
    var userEntity: UserEntity
    var ref: DatabaseReference!
    var uid: DatabaseReference!
    
    // 非同期処理用のクロジャー
    typealias ComplateCreate = (_ sucees:Bool) -> Void
    typealias ComplateLogin = (_ uid:String?) -> Void
    typealias ComplateSearch = (_ user:UserData?) -> Void
    
    init() {
        userEntity = UserEntity()
        ref = Database.database().reference()
    }
    
    //MARK: 以下からFirebase Authenticationに対する操作を記述する
    
    // ユーザ作成(Firabase Authentication)
    func userCreate(email: String, password: String, complateCreate:@escaping ComplateCreate) -> Void {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                //エラーが存在する場合
                self.authErrorDesc(error: error)
                complateCreate(false)
                return
            }
            //正常終了
            complateCreate(true)
        }
    }
    
    // サインイン(Firabase Authentication)
    func signIn(email: String, password: String, complateLogin:@escaping ComplateLogin) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                // エラーが存在する場合
                self.authErrorDesc(error: error)
                complateLogin(nil)
                return
            }
            let uid = self.getUid()
            complateLogin(uid)
        }
    }
    
    // UID取得
    private func getUid() -> String {
        //ユーザー情報取得
        let user = Auth.auth().currentUser
        return user!.uid
    }
    
    // ログイン確認
    func isLogin() -> Bool {
        let user = Auth.auth().currentUser
        return user != nil
    }
    
    // エラー内容の振り分け
    private func authErrorDesc(error: Error?) {
        print("【ERROR：】" + error.debugDescription)
        
        if let errCode = AuthErrorCode(rawValue: error!._code) {
            switch errCode {
            case .invalidEmail:
                print("メールアドレスの形式が違います。")
                break
            case .emailAlreadyInUse:
                print("このメールアドレスはすでに使われています。")
                break
            case .operationNotAllowed:
                print("操作権限がありません")
                break
            case .weakPassword:
                print("パスワードは6文字以上で入力してください。")
                break
            case .wrongPassword:
                print("パスワードもしくはユーザIDが間違っています。")
                break
            default:
                print("登録に失敗しました。\nしばらくしてから再度お試しください")
                break
            }
        }
    }
    
    //MARK: 以下からFirebase Realtime Databaseに対する操作を記述する

    // ユーザ作成(Realtime Database)
    func insertUser(user: UserData) {
        //ユーザID(学籍番号？　UID？)をルートにする
        let userId = user.user_no
        ref.child("user").child(userId).setValue(user.toDictionary())
    }
    
    // ユーザ検索(Realtime Database)
    func searchUser(userid: String, complateSearch:@escaping ComplateSearch) {
        ref = Database.database().reference().child("user").child(userid)
        ref.observe(.value, with: { snapshot in
            if let values = snapshot.value as? [String:String] {
                // ユーザモデルを作成
                let user = UserData(src: values)
                complateSearch(user)
            } else {
                // ユーザが見つからない場合
                complateSearch(nil)
            }
        })
    }
}
