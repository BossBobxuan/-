//
//  SignUpViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/4.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos

class SignUpViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - var and let
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var genderPickerParentView: UIView!
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    private var nowGender = "男"
    private var genderString: String
        {
        switch nowGender {
        case "男":
            return "0"
        case "女":
            return "1"
        default:
            return "1"
        }
    }
    let manager = singleClassManager.manager
    var MediaId: Int!
    // MARK: - touch event
    @IBAction func showPicker(_ sender: UIButton) {
        self.genderPickerParentView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {self.genderPickerParentView.alpha = 1.0})
    }
    
    
    @IBAction func editAvatar(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        PHPhotoLibrary.requestAuthorization({[weak self] (status) in
            if status == PHAuthorizationStatus.authorized
            {
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                self?.present(imagePicker, animated: true, completion: nil)
            }
            else if status == PHAuthorizationStatus.denied
            {
                let alert = UIAlertController(title: "没有访问相册权限", message: "请前往设置打开设置权限", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
        })
        
    }
    
    @IBAction func cancelPick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {self.genderPickerParentView.alpha = 0.0}, completion: {(_) in self.genderPickerParentView.isHidden = true})
    }
    
    @IBAction func donePick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {self.genderPickerParentView.alpha = 0.0}, completion: {(_) in self.genderPickerParentView.isHidden = true})
        self.genderButton.setTitle(nowGender, for: .normal)
    }
   
    
    @IBAction func signUpEvent(_ sender: UIButton)
    {
        if MediaId == nil
        {
            let alert = UIAlertController(title: "未上传头像", message: "请上传头像", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if nameTextField.text! == "" || userTextField.text! == "" || passwordTextField.text! == "" || passwordRepeatTextField.text! == "" || descriptionTextField.text! == ""
        {
            let alert = UIAlertController(title: "请完整输入信息", message: "有信息未填写", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if passwordTextField.text! != passwordRepeatTextField.text!
        {
            let alert = UIAlertController(title: "两次输入密码不一致", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            let requestUrl = urlStruct.basicUrl + "register.json"
            let waitalert = UIAlertController(title: "正在注册", message: "", preferredStyle: .alert)
            self.present(waitalert, animated: true, completion: nil)
            manager.post(requestUrl, parameters: ["user": userTextField.text!,"password": passwordTextField.text!,"gender": genderString, "avatar": MediaId, "description": descriptionTextField.text!,"name": nameTextField.text!], progress: {(progress) in }, success: {
                [weak self] (dataTask,response) in
                print("success")
                print(response)
                let JsonDic = response as! NSDictionary
                let token = JsonDic["access_token"] as! String
                let refreshToken = JsonDic["refresh_token"] as! String
                let userDefault = UserDefaults.standard
                userDefault.set(token, forKey: "token")//将token存入userDefault中
                userDefault.set(refreshToken, forKey: "refreshToken")
                waitalert.dismiss(animated: true, completion: {(_) in self?.performSegue(withIdentifier: seguename.signupToMain, sender: nil)})
                
                
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                waitalert.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "注册失败", message: "用户名重复或者网络连接失败", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
            })
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
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderPickerParentView.isHidden = true
        self.genderPickerParentView.alpha = 0.0
        
        self.genderButton.setTitle(nowGender, for: .normal)
        
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordRepeatTextField.delegate = self
        self.userTextField.delegate = self
        
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
    
    //MARK: - dataPicker delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 1:
            return "女"
        default:
            return "男"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 1:
            nowGender = "女"
            
        default:
            
            nowGender = "男"
        }
    }
    //MARK: - image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
            let data = UIImagePNGRepresentation(image!)
            let requestUrl = urlStruct.basicUrl + "media.json"
            manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
                
                fromData.appendPart(withFileData: data!, name: "file", fileName: "image", mimeType: "application/x-www-form-urlencoded")
            }, progress: {(progress) in }, success: {
                [weak self] (dataTask,response) in
                if let JsonDictionary = response as? NSDictionary
                {
                    self?.MediaId = (JsonDictionary["media_id"] as! Int)
                }
                self?.avatarImageView.image = image!
                
                
                
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                let alert = UIAlertController(title: "上传照片失败", message: "请检查网络连接", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
            })
            
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
