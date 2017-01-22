//
//  SignUpViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/4.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

struct constants
{
    static let url : String = "http://127.0.0.1:8000"
}
class SignUpViewController: UIViewController,UITextFieldDelegate {
    // MARK: - var and let
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet var interestedLabel: [UIButton]!
    
    // MARK: - touch event
    @IBAction func interestedLabelEvent(_ sender: UIButton)
    {
        if sender.backgroundColor != nil
        {
            sender.backgroundColor = nil
        }else
        {
            sender.backgroundColor = UIColor.black
        }
    }
    
    @IBAction func signUpEvent(_ sender: UIButton)
    {
        if passwordTextField.text == ""
        {
            let alert = UIAlertController(title: "请输入密码", message: "密码不可以为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if userNameTextField.text == "" && passwordTextField.text != ""
        {
            let alert = UIAlertController(title: "请输入用户名", message: "用户名不可以为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if passwordTextField.text == passwordRepeatTextField.text && passwordTextField.text != "" && userNameTextField.text != ""
        {
            let manager = AFHTTPSessionManager()
            
            let urlpost = constants.url + "/piaoapp/signup/"
            var labelstr = ""
            for label in interestedLabel
            {
                if label.backgroundColor != nil
                {
                    labelstr += "1"
                }else
                {
                    labelstr += "0"
                }
            }
            // MARK: -需要在此更改数据请求
            manager.post(urlpost, parameters: ["username":self.userNameTextField.text!,"password":self.passwordTextField.text!,"label":labelstr], progress: { (progress) in
                
            }, success: { (DataTask, response) in
                if let res = response as? NSDictionary
                {
                    if res["state"] as! String == "success"
                    {
                        self.performSegue(withIdentifier: "signUpToMain", sender: self)
                    }else if res["state"] as! String == "repeat"
                    {
                        let alert = UIAlertController(title: "请重新输入用户名", message: "用户名重复", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }, failure: { (DataTask, error) in
                print(error)
                let alert = UIAlertController(title: "无法连接", message: "请检查网络连接  ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            
        }else if passwordTextField.text != passwordRepeatTextField.text && passwordTextField.text != "" && userNameTextField.text != ""
        {
            let alert = UIAlertController(title: "请重新输入密码", message: "密码不一致", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func cancelEvent(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - viewController lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordRepeatTextField.delegate = self
        userNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
