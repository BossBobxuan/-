//
//  EditPersonalInformationViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/20.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos
class EditPersonalInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate//要实现ImagePicker协议必须增加navigation的协议
{
    //MARK: - outlet
    var userInformationModel: PersonalInformationModel!
    private var pickerViewNowTitle: String = "男"
    var avatarimage: UIImage?
    @IBOutlet weak var genderPickerParentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var discriptionTextField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var genderButton: UIButton!
    
    //MARK: - Event func
    //使选择视图出现
    @IBAction func showPickerView(_ sender: UIButton)
    {
        self.genderPickerParentView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.genderPickerParentView.alpha = 1.0
            
        })

    }
    //编辑头像
    @IBAction func EditAvatar(_ sender: UIButton)
    {
        let imagePicker = UIImagePickerController()
        PHPhotoLibrary.requestAuthorization({(status) in
            if status == PHAuthorizationStatus.authorized
            {
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            else if status == PHAuthorizationStatus.denied
            {
                let alert = UIAlertController(title: "没有访问相册权限", message: "请前往设置打开设置权限", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
        })
        
    }
    //取消选择
    @IBAction func cancelPick(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.genderPickerParentView.alpha = 0.0
        }, completion: {
            (is) in
            self.genderPickerParentView.isHidden = true
        })
    }
    //确定选择
    @IBAction func finishPick(_ sender: UIButton)
    {
        genderButton.setTitle(pickerViewNowTitle, for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.genderPickerParentView.alpha = 0.0
        }, completion: {
            (is) in
            self.genderPickerParentView.isHidden = true
        })
    }
    //确定编辑
    func editFinish(_ sender: UIBarButtonItem)
    {
        userInformationModel.personalInformationEnity?.name = nameTextField.text!
        if genderButton.titleLabel?.text == "男"
        {
            userInformationModel.personalInformationEnity?.gender = "0"
        }else if genderButton.titleLabel?.text == "女"
        {
            userInformationModel.personalInformationEnity?.gender = "1"
        }
        userInformationModel.personalInformationEnity?.description = discriptionTextField.text!
        userInformationModel.editUserInformation(token: token)
        //MARK: - 使用AFNetworking传入数据时，不能传入可选类型，否则会出错
        
        
        _ = navigationController?.popViewController(animated: true)
       
    }
    
    //点击屏幕空白处收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        discriptionTextField.resignFirstResponder()
    }
    //MARK: - viewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "修改个人信息"
        
        nameTextField.delegate = self
        discriptionTextField.delegate = self
        
        genderPickerParentView.isHidden = true
        genderPickerParentView.alpha = 0
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        //添加成功按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "editFinish:")
        
        self.avatarImageView.image = avatarimage
        self.nameTextField.text = userInformationModel.personalInformationEnity?.name
       
        self.discriptionTextField.text = userInformationModel.personalInformationEnity?.description
        if let gender = userInformationModel.personalInformationEnity?.gender
        {
            if gender == "0"
            {
                self.genderButton.setTitle("男", for: .normal)
            }else if gender == "1"
            {
                self.genderButton.setTitle("女", for: .normal)
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - pickerViewdelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0
        {
            pickerViewNowTitle = "男"
        }
        else if row == 1
        {
            pickerViewNowTitle = "女"
        }
    }
    //MARK: - pickerViewDataSourve
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0
        {
            return "男"
        }
        else if row == 1
        {
            return "女"
        }
        return "其他"
    }
    
    //MARK: - textField delegate
    //点击返回按钮收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - iamgePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImageView.image = info[UIImagePickerControllerEditedImage] as! UIImage
        userInformationModel.uploadImage(image: avatarImageView.image!,token: token)
        
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
