//
//  EditActivityViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/28.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos
class EditActivityViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK: - outlet
    @IBOutlet weak var tagsScrollView: UIScrollView!
    @IBOutlet weak var activityTitleTextField: UITextField!
    @IBOutlet weak var feeTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var activityImageImageView: UIImageView!
    @IBOutlet weak var beginTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var datePickerParentView: UIView!
    @IBOutlet weak var activityBeginAndEndTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var categoryPickerParentView: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
        {
        didSet{
            categoryPickerView.delegate = self
            categoryPickerView.dataSource = self
        }
    }
    
    @IBOutlet weak var catogeryButton: UIButton!
    //MARK: - let and var
    var activityDetailModel:ActivityDetailModel!
    private let activityType: [String] = ["全部","聚餐","运动","旅行","电影","音乐","分享会","赛事","桌游","其他"]
    private var nowActivityType: String!
    //MARK: - event func
    @IBAction func needSelectCategory(_ sender: UIButton) {
        self.categoryPickerParentView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {self.categoryPickerParentView.alpha = 1})
    }
    
    @IBAction func needSelectBeginTime(_ sender: UIButton) {
        self.datePickerParentView.tag = 0//选取beginTime时tag为0
        self.datePickerParentView.isHidden = false
        self.activityBeginAndEndTimeDatePicker.minimumDate = Date(timeIntervalSinceNow: 0)
        UIView.animate(withDuration: 0.5, animations: {self.datePickerParentView.alpha = 1})
    }
    
    @IBAction func needSelectEndTime(_ sender: UIButton) {
        self.datePickerParentView.tag = 1//选取endTime时tag为1
        self.datePickerParentView.isHidden = false
        //MARK: - 需要设置最小时间为begintime
        UIView.animate(withDuration: 0.5, animations: {self.datePickerParentView.alpha = 1})
    }
    
    @IBAction func categoryPickerDone(_ sender: UIButton) {
        catogeryButton.setTitle(self.nowActivityType, for: .normal)
        UIView.animate(withDuration: 0.5, animations: {self.categoryPickerParentView.alpha = 0}, completion: {(_) in self.categoryPickerParentView.isHidden = true})
    }
    
    @IBAction func categoryPickerCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {self.categoryPickerParentView.alpha = 0}, completion: {(_) in self.categoryPickerParentView.isHidden = true})
    }
   
    @IBAction func datePickDone(_ sender: UIButton) {
        if datePickerParentView.tag == 0
        {
            //证明beginTime被选中
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            beginTimeButton.setTitle(dformatter.string(from: activityBeginAndEndTimeDatePicker.date), for: .normal)
        }else if datePickerParentView.tag == 1
        {
            //证明endTime被选中
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            endTimeButton.setTitle(dformatter.string(from: activityBeginAndEndTimeDatePicker.date), for: .normal)
        }
        UIView.animate(withDuration: 0.5, animations: {self.datePickerParentView.alpha = 0}, completion: {(_) in self.datePickerParentView.isHidden = true})
    }
    
    @IBAction func datePickCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {self.datePickerParentView.alpha = 0}, completion: {(_) in self.datePickerParentView.isHidden = true})
    }
    
    @IBAction func editActivityImage(_ sender: UIButton) {
        //若不收起键盘会崩溃尚未解决
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
    override func viewDidLoad() {
        super.viewDidLoad()

//        activityTitleTextField.text = activityDetailModel.activityEnity.activityTitle
//        contentTextView.text = activityDetailModel.activityEnity.content
//        beginTimeButton.setTitle(activityDetailModel.activityEnity.beginTime.date, for: .normal)
//        endTimeButton.setTitle(activityDetailModel.activityEnity.endTime.date, for: .normal)
//        catogeryButton.setTitle(activityDetailModel.activityEnity.categoryString, for: .normal)
//        feeTextField.text = "\(activityDetailModel.activityEnity.fee)"
//        addTagsIntoScrollView()
//        //异步获取图片
//        let media = activityDetailModel.activityEnity.image
//        let url = urlStruct.basicUrl + "media/" + "\(media)"
//        DispatchQueue.global().async {
//            
//            if let data = try? Data(contentsOf: URL(string: url)!)
//            {
//                
//                DispatchQueue.main.async {
//                    if let image = UIImage(data: data)
//                    {
//                        
//                        self.activityImageImageView.image = image
//                    }
//                }
//            }
//        }
        self.categoryPickerParentView.isHidden = true
        self.categoryPickerParentView.alpha = 0
        self.datePickerParentView.isHidden = true
        self.datePickerParentView.alpha = 0
        self.activityBeginAndEndTimeDatePicker.datePickerMode = .dateAndTime
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - imagepicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        activityImageImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        activityDetailModel.editActivityImage(image: activityImageImageView.image!, token: token)
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK: - pikcerView delegate and Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nowActivityType = activityType[row]
    }
    //MARK: - other func
    func addTagsIntoScrollView()
    {
        var i = 0
        tagsScrollView.subviews.forEach({(view) in view.removeFromSuperview()})//清空所有子视图
        tagsScrollView.contentSize.width = CGFloat(40 * (activityDetailModel.activityEnity.tags.count + 1))
        for tag in activityDetailModel.activityEnity.tags
        {
            if let tagString = tag as? String
            {
                print("1111")
                let tagLabel = UILabel(frame: CGRect(x: CGFloat(40 * i), y: tagsScrollView.bounds.origin.y, width: CGFloat(30), height: tagsScrollView.bounds.height))
                tagLabel.font = UIFont(name: "Arial", size: 15)
                tagLabel.textColor = UIColor.black
                tagLabel.text = tagString
                print(tagString)
                tagsScrollView.addSubview(tagLabel)
            }
            i += 1
        }
        
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
