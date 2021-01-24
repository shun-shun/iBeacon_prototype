//
//  UserConnectViewController.swift
//  iBeacon_prototype
//
//  Created by しゅん on 2021/01/20.
//

import Foundation
import UIKit

class UserConnectViewConroller: NoHideViewUtiler {
    
    @IBOutlet var number:UITextField!
    @IBOutlet var mail:UITextField!
    @IBOutlet var pass:UITextField!
    
    let regex_email = "^([A-Z0-9a-z._+-])+@([A-Za-z0-9.-])+\\.([A-Za-z]{2,})$"
    
    let service = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pass.isSecureTextEntry = true
        
        // textFieldの操作を準備
        self.number.delegate = self
        self.mail.delegate = self
        self.pass.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // textFieldが隠れないように細工
        self.setUpNotificationForTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面外をタップすると、textFieldを消す
        self.view.endEditing(true)
    }
    
    //ボタン
    @IBAction func doAction(_ sender: Any) {
        
        // nilチェック
        guard let email = mail.text else {
            print("【100】EMail未入力")
            return
        }
        
        // 空文字チェック
        guard email != "" else {
            print("")
            return
        }
        
        // TODO:メールアドレス形式チェック
        
        // nilチェック
        guard let password = pass.text else {
            print("【101】Password未入力")
            return
        }
        
        // 空文字チェック
        guard password != "" else {
            print("")
            return
        }
        
        // TODO: パスワード要件チェック
        
        print(email)
        print(password)
        
        //整合性チェック
        print("No.01[前]")
        service.create(email: email, password: password, complate: { uid in
            if uid != nil {
                // 名前を指定してStoryboardを取得する(Menu.storyboard)
                let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
                // StoryboardIDを指定してViewControllerを取得する(menuSB)
                let nextController = storyboard.instantiateViewController(withIdentifier: "menuSB") as! MenuViewController
                // 遷移開始
                self.present(nextController, animated: true, completion: nil)
            } else {
                // TODO:  失敗
            }
        })
    }
}
