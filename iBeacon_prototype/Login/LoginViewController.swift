//
//  ViewController.swift
//  iBeacon_prototype
//
//  Created by しゅん on 2021/01/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var in_user_no: UITextField!
    @IBOutlet weak var in_password: UITextField!
    
    let userService = UserService()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        in_user_no.delegate = self
    }
    
    @IBAction func getText(sender : UITextField) {
        in_password.text = sender.text
    }
    
    @IBAction func login(_ sender: Any) {
        
        //TODO: 以下のnilとか空文字とか形式チェックとか
        let user_no: String = String(in_user_no.text!)
        let password: String = String(in_password.text!)
        
        userLogin(email: user_no, password: password)
    }
    
    func userLogin(email: String, password: String) {
        userService.signIn(email: email, password: password, complate: {uid in
            if uid != nil {
                print("ログイン成功：\(uid!)")
                // 名前を指定してStoryboardを取得する(Menu.storyboard)
                let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
                // StoryboardIDを指定してViewControllerを取得する(menuSB)
                let nextController = storyboard.instantiateViewController(withIdentifier: "menuSB") as! MenuViewController
                // 遷移開始
                self.present(nextController, animated: true, completion: nil)
                return
            }
            print("ログイン失敗")
        })
        
    }
}

