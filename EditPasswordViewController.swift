//
//  EditPasswordViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/22.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class EditPasswordViewController: UIViewController {
    @IBOutlet weak var oldPassWordTextField: UITextField!
    let manager = singleClassManager.manager
    
    
    @IBOutlet weak var repeatPassWordTextFIeld: UITextField!
    @IBOutlet weak var newPassWordTextField: UITextField!
    @IBAction func changeDone(_ sender: UIButton) {
        if repeatPassWordTextFIeld.text == "" || oldPassWordTextField.text == "" || newPassWordTextField.text == ""
        {
            let alert = UIAlertController(title: "不可以为空", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }else if repeatPassWordTextFIeld.text != newPassWordTextField.text
        {
            let alert = UIAlertController(title: "两次输入不一致", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else
        {
            let alert = UIAlertController(title: "修改中", message: nil, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            let requestUrl = urlStruct.basicUrl + "user/~me.json"
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
            manager.post(requestUrl, parameters: ["old_password":oldPassWordTextField.text!,"new_password":newPassWordTextField.text!], progress: {(progress) in }, success: {
                [weak self] (dataTask,response) in
                alert.dismiss(animated: true, completion: {
                  
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                    let userd = UserDefaults.standard
                    userd.removeObject(forKey: "token")
                    userd.removeObject(forKey: "refreshToken")
                
                })
                
                
                }, failure: {[weak self] (dataTask,error) in
                    alert.dismiss(animated: true, completion: {
                        let alert1 = UIAlertController(title: "修改失败", message: "旧密码不正确或者网络连接错误", preferredStyle: .alert)
                        alert1.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                        self?.present(alert1, animated: true, completion: nil)
                    
                    })
                  
            })
 
        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
