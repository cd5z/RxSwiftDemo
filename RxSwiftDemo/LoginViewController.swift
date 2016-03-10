//
//  LoginViewController
//  RxT
//
//  Created by LiChendi on 16/3/4.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let minUsernameLength = 5
let maxUsernameLength = 10
let minPasswordLength = 5
let maxPasswordLength = 16
let disposBag = DisposeBag()

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLB: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let usernameValid = usernameTF.rx_text
            .map{$0.characters.count >= minUsernameLength && $0.characters.count <= maxUsernameLength }  //map函数 对text进行处理
            .shareReplay(1)     //
        
        let passwordValid = passwordTF.rx_text
            .map{$0.characters.count >= minPasswordLength && $0.characters.count < maxPasswordLength }  //map函数 对text进行处理
            .shareReplay(1)     //
        
        
//        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { (usernameValid, passwordValid) -> Bool in
//            usernameValid && passwordValid
//        }
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        .shareReplay(1)
        
        usernameValid
            .bindTo(passwordTF.rx_enabled)  //username通过验证，passwordTF才可以输入
            .addDisposableTo(disposBag)
        
        usernameValid
            .bindTo(usernameLB.rx_hidden)   //username通过验证，usernameLB警告消失
            .addDisposableTo(disposBag)
        
        passwordValid
            .bindTo(passwordLB.rx_hidden)
            .addDisposableTo(disposBag)
        
        everythingValid
            .bindTo(loginButton.rx_enabled)   // 用户名密码都通过验证，才可以点击按钮
            .addDisposableTo(disposBag)
        
        loginButton.rx_tap
            .subscribeNext { [weak self] in
                self?.showAlert()
        }
            .addDisposableTo(disposBag)
        
        
        
      
    }


    func showAlert() {
        let alertView = UIAlertView(
            title: "成功",
            message: "登录成功",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
