//
//  StudentCardController.swift
//  iBeacon_prototype
//
//  Created by しゅん on 2021/01/22.
//

import UIKit

class StudentCardController: UIViewController {

    @IBOutlet weak var barcode: UIImageView!
    
    var userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:バーコードを生成する処理
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
