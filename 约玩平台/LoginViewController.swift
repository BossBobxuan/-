//
//  LoginViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/4.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextFIeld: UITextField!
    @IBAction func login(_ sender: UIButton) {
        if passwordTextField.text! == "" || userTextFIeld.text! == ""
        {
            let alert = UIAlertController(title: "密码与用户名不可为空", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            let manager = singleClassManager.manager
            let requestUrl = urlStruct.basicUrl + "token.json"
            let waitalert = UIAlertController(title: "正在登录", message: "", preferredStyle: .alert)
            self.present(waitalert, animated: true, completion: nil)
            manager.post(requestUrl, parameters: ["password": passwordTextField.text!,"user":userTextFIeld.text!,"grant_type":"password"], progress: {(progress) in }, success: {
                [weak self] (dataTask,response) in
                print("success")
                
                let JsonDic = response as! NSDictionary
                let token = JsonDic["access_token"] as! String
                let refreshToken = JsonDic["refresh_token"] as! String
                let userDefault = UserDefaults.standard
                userDefault.set(token, forKey: "token")//将token存入userDefault中
                userDefault.set(refreshToken, forKey: "refreshToken")
                waitalert.dismiss(animated: true, completion: {(_) in self?.performSegue(withIdentifier: seguename.logInToMain, sender: nil)})
                
                
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                waitalert.dismiss(animated: true, completion: {(_) in
                    let alert = UIAlertController(title: "登录失败", message: "输入用户名密码错误或者网络连接失败", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)})
                
                
            })
            
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userTextFIeld.delegate = self
        self.passwordTextField.delegate = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
