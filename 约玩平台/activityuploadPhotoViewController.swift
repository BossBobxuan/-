//
//  activityuploadPhotoViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/8.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class activityuploadPhotoViewController: UIViewController, PullDataDelegate {
    var image: UIImage!
    var imageView: UIImageView!
    var descriptionTextField: UITextField!
    var activityId: Int!
    var model: ActivityPhotoModel!
    private let alert = UIAlertController(title: "正在上传图片", message: "", preferredStyle: .alert)
    
    func goback(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func done(_ sender: UIBarButtonItem)
    {
       
        
        if descriptionTextField.text != ""
        {
            model.uploadImage(activityId: activityId, description: descriptionTextField.text! , image: image, token: token)
        }else
        {
            model.uploadImage(activityId: activityId, description: nil, image: image, token: token)
        }
        self.present(alert, animated: true, completion: nil)//放在请求之前会阻塞当前的controller的运行
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 50))
        let item = UINavigationItem(title: "说两句吧")
        
        item.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: "goback:")
        item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "done:")
        navbar.pushItem(item, animated: true)
        self.view.addSubview(navbar)
        
        
        self.model = ActivityPhotoModel(delegate: self)
        imageView = UIImageView(frame: CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 120))
        imageView.image = image
        self.view.addSubview(imageView)
        
        descriptionTextField = UITextField(frame: CGRect(x: 8, y: UIScreen.main.bounds.height - 40, width: UIScreen.main.bounds.width - 16, height: 25))
        descriptionTextField.placeholder = "请输入图片描述"
        descriptionTextField.layer.borderWidth = 0.5
        descriptionTextField.layer.cornerRadius = 8
        self.view.addSubview(descriptionTextField)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func needUpdateUI() {
        alert.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
        
    }
    func getDataFailed() {
        alert.dismiss(animated: true, completion: {
            let alert1 = UIAlertController(title: "上传失败", message: "请检查网络连接", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert1, animated: true, completion: nil)
        })
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
