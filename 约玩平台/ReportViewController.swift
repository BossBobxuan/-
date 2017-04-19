//
//  ReportViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/19.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    var uid: Int!
    var attachType: Int!
    let manager = singleClassManager.manager
    @IBOutlet weak var descriptionTextView: UITextView!
    func report(_ sender: UIBarButtonItem)
    {
        if descriptionTextView.text == ""
        {
            let alert = UIAlertController(title: "描述不能为空", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            let alert1 = UIAlertController(title: "举报中", message: nil, preferredStyle: .alert)
            self.present(alert1, animated: true, completion: nil)
            let requestUrl = urlStruct.basicUrl + "admin/" + "report.json"
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
            manager.post(requestUrl, parameters: ["attach_type": attachType,"attach_id":uid,"description":descriptionTextView.text!], progress: {(progress) in}, success: {[weak self](dataTask,response) in
                alert1.dismiss(animated: true, completion: {let _ = self?.navigationController?.popViewController(animated: true)})
                }, failure: {[weak self](dataTask,error) in
                    print(error)
                    alert1.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    
                    })
                   
                    
                    
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "report:")
        
        
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
