//
//  EditActivityViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/28.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos
class EditActivityViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, selectLocationDelegate, PullDataDelegate {
    
    //MARK: - outlet
    @IBOutlet weak var tagsScrollView: UIScrollView!
    @IBOutlet weak var activityTitleTextField: UITextField!
    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
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
    private var beginTimeStamp: Int = 0
    private var endTimeStamp: Int = 0
    var activityDetailModel:ActivityDetailModel?
    private let activityType: [String] = ["全部","聚餐","运动","旅行","电影","音乐","分享会","赛事","桌游","其他"]
    private var nowActivityType: String = "全部"
    private var tagsArray: [String] = []//用于存放标签
    private var longitude: Double? //用于存放地理位置
    private var latitude: Double?
    private var imageMediaId: Int? //存放活动头图
    //MARK: - event func
    @IBAction func needSelectCategory(_ sender: UIButton) {
        self.categoryPickerParentView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {self.categoryPickerParentView.alpha = 1})
    }
    
    @IBAction func selectLocation(_ sender: UIButton) {
        performSegue(withIdentifier: seguename.toLocationSelect, sender: nil)
        
        
    }
    
    @IBAction func addTags(_ sender: UIButton) {
        let alert = UIAlertController(title: "标签", message: "请选择动作", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "添加标签", style: .default, handler: {
            (_) in
            let alert1 = UIAlertController(title: "添加标签", message: "请输入添加标签", preferredStyle: .alert)
            alert1.addTextField(configurationHandler: {(_) in })
            alert1.addAction(UIAlertAction(title: "添加", style: .default, handler: {(alert) in
                self.tagsArray.append(alert1.textFields![0].text!)
                self.addTagsIntoScrollView()
            }))
            alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {(_) in }))
            self.present(alert1, animated: true, completion: {})
        }))
        alert.addAction(UIAlertAction(title: "清除标签", style: .default, handler: {(_) in
            self.tagsArray.removeAll()
            self.addTagsIntoScrollView()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {(_) in }))
        self.present(alert, animated: true, completion: {})
        
        
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
            beginTimeStamp = Int(activityBeginAndEndTimeDatePicker.date.timeIntervalSince1970)
            
        }else if datePickerParentView.tag == 1
        {
            //证明endTime被选中
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            endTimeButton.setTitle(dformatter.string(from: activityBeginAndEndTimeDatePicker.date), for: .normal)
            endTimeStamp = Int(activityBeginAndEndTimeDatePicker.date.timeIntervalSince1970)
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
    
    func editDone(_ sender: UIBarButtonItem)
    {
        if activityDetailModel != nil
        {
            activityDetailModel?.activityEnity.activityTitle = activityTitleTextField.text!
            activityDetailModel?.activityEnity.address = addressTextField.text!
            activityDetailModel?.activityEnity.beginTime = beginTimeStamp * 1000

            activityDetailModel?.activityEnity.category = "\(categoryPickerView.selectedRow(inComponent: 0))"
           
            activityDetailModel?.activityEnity.content = contentTextView.text!
            activityDetailModel?.activityEnity.endTime = endTimeStamp * 1000
            activityDetailModel?.activityEnity.fee = Int(feeTextField.text!)!
            activityDetailModel?.activityEnity.latitude = latitude!
            activityDetailModel?.activityEnity.longitude = longitude!
            activityDetailModel!.editActivity(token: token)
        }else
        {
            let alert = UIAlertController(title: "正在发布活动", message: "请等待", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            var tagString = ""
            for tag in tagsArray
            {
                tagString += tag + "&"
            }
            
            let requestUrl = urlStruct.basicUrl + "user/~me/activity.json"
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
            manager.post(requestUrl, parameters: ["title": activityTitleTextField.text!,"image": imageMediaId!,"beginTime":beginTimeStamp * 1000,"endTime":endTimeStamp * 1000,"address":addressTextField.text!,"latitude":latitude!,"longitude":longitude!,"fee": Int(feeTextField.text!)!,"category":categoryPickerView.selectedRow(inComponent: 0),"content":contentTextView.text,"tags": tagString], progress: {(progress) in }, success: {
                (dataTask,response) in
                print("success")
                alert.dismiss(animated: true, completion: {})
                let _ = self.navigationController?.popViewController(animated: true)
                
                
            }, failure: {(dataTask,error) in
                print(error)
                alert.dismiss(animated: true, completion: {
                    let alert1 = UIAlertController(title: "无法创建活动", message: "请检查网络连接或补全活动信息", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
                
            })
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityDetailModel != nil//证明为修改活动
        {
            self.activityDetailModel?.delegate = self
            self.navigationItem.title = "修改活动"
            activityTitleTextField.text = activityDetailModel!.activityEnity.activityTitle
            contentTextView.text = activityDetailModel!.activityEnity.content
            beginTimeButton.setTitle(activityDetailModel!.activityEnity.beginTime.date, for: .normal)
            endTimeButton.setTitle(activityDetailModel!.activityEnity.endTime.date, for: .normal)
            catogeryButton.setTitle(activityDetailModel!.activityEnity.categoryString, for: .normal)
            feeTextField.text = "\(activityDetailModel!.activityEnity.fee)"
            addressTextField.text = activityDetailModel?.activityEnity.address
            beginTimeStamp = (activityDetailModel?.activityEnity.beginTime)! / 1000
            endTimeStamp = (activityDetailModel?.activityEnity.endTime)! / 1000
            //注册标签
            for element in (activityDetailModel?.activityEnity.tags)!
            {
                tagsArray.append(element as! String)
            }//MARK: - 有可能出问题
            print(tagsArray)
            addTagsIntoScrollView()
            //异步获取图片
            let media = activityDetailModel!.activityEnity.image
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            
            //注册地理位置
            longitude = activityDetailModel!.activityEnity.longitude
            latitude = activityDetailModel!.activityEnity.latitude
            DispatchQueue.global().async {
                
                if let data = try? Data(contentsOf: URL(string: url)!)
                {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data)
                        {
                            
                            self.activityImageImageView.image = image
                        }
                    }
                }
            }
        }else
        {
            //MARK: - 稍等处理
            self.navigationItem.title = "创建活动"
        }
        
        self.categoryPickerParentView.isHidden = true
        self.categoryPickerParentView.alpha = 0
        self.datePickerParentView.isHidden = true
        self.datePickerParentView.alpha = 0
        self.activityBeginAndEndTimeDatePicker.datePickerMode = .dateAndTime
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "editDone:")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - imagepicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        activityImageImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        if activityDetailModel != nil
        {
            activityDetailModel!.editActivityImage(image: activityImageImageView.image!, token: token)
        }else
        {
            let manager = AFHTTPSessionManager()
            let data = UIImagePNGRepresentation(activityImageImageView.image!)
            let requestUrl = urlStruct.basicUrl + "media.json"
            manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
                
                fromData.appendPart(withFileData: data!, name: "file", fileName: "image", mimeType: "application/x-www-form-urlencoded")
            }, progress: {(progress) in }, success: {
                (dataTask,response) in
                if let JsonDictionary = response as? NSDictionary
                {
                    self.imageMediaId = (JsonDictionary["media_id"] as! Int)
                }
                
                
                
            }, failure: {(dataTask,error) in
                print(error)
                let alert = UIAlertController(title: "上传照片失败", message: "请检查网络连接", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            })
            
        }
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
        tagsScrollView.contentSize.width = CGFloat(50 * (tagsArray.count + 1))
        if activityDetailModel != nil
        {
            activityDetailModel?.activityEnity.tags = tagsArray as NSArray
            for tagString in tagsArray
            {
                
                print("1111")
                let tagLabel = UILabel(frame: CGRect(x: CGFloat(50 * i), y: tagsScrollView.bounds.origin.y, width: CGFloat(40), height: tagsScrollView.bounds.height))
                tagLabel.font = UIFont(name: "Arial", size: 15)
                tagLabel.textColor = UIColor.black
                tagLabel.text = tagString
                print(tagString)
                tagsScrollView.addSubview(tagLabel)
                
                i += 1
            }
        }else
        {
            for tagString in tagsArray
            {
                
                print("1111")
                let tagLabel = UILabel(frame: CGRect(x: CGFloat(50 * i), y: tagsScrollView.bounds.origin.y, width: CGFloat(40), height: tagsScrollView.bounds.height))
                tagLabel.font = UIFont(name: "Arial", size: 15)
                tagLabel.textColor = UIColor.black
                tagLabel.text = tagString
                print(tagString)
                tagsScrollView.addSubview(tagLabel)
                
                i += 1
            }
        }
        
    }
    // MARK: - pull Data Delegate
    func needUpdateUI() {
        let _ = self.navigationController?.popViewController(animated: true)
        let controller = self.navigationController?.viewControllers.last as! ActicityDetailViewController
        controller.navigationItem.title = controller.activityModel.activityEnity.activityTitle
        controller.activityTitleLabel.text = controller.activityModel.activityEnity.activityTitle
        controller.contentTextView.text = controller.activityModel.activityEnity.content
        controller.categoryLabel.text = controller.activityModel.activityEnity.categoryString
        controller.beginTimeLabel.text = controller.activityModel.activityEnity.beginTime.date
        controller.endTimeLabel.text = controller.activityModel.activityEnity.endTime.date
        controller.creatTimeLabel.text = controller.activityModel.activityEnity.creatAt.date
        controller.wishedCountLabel.text = "\(controller.activityModel.activityEnity.wisherCount)"
        controller.participatedCountLabel.text = "\(controller.activityModel.activityEnity.participantCount)"
        controller.addressLabel.text = controller.activityModel.activityEnity.address
        controller.photoCountLabel.text = "\(controller.activityModel.activityEnity.photoCount)"
        controller.notificationCountLabel.text = "\(controller.activityModel.activityEnity.notificationCount)"
        controller.feeLabel.text = "\(controller.activityModel.activityEnity.fee)"
    }
    func getDataFailed() {
        let alert = UIAlertController(title: "修改失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    // MARK: - selectlocation Delegate
    func selectLocationDone(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        print(self.latitude)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.toLocationSelect
        {
            if let controller = segue.destination as? LocationSelectViewController
            {
                //做测试
                controller.longitude = longitude
                controller.latitude = latitude
                controller.delegate = self
            }
        }
        
        
    }
    

}
