//
//  EditActivityViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/28.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos
class EditActivityViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, selectLocationDelegate, PullDataDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: - outlet
    
    @IBOutlet weak var stackView: UIStackView!
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
    @IBOutlet weak var deleteActivityButton: UIButton!
    
    @IBOutlet weak var catogeryButton: UIButton!
    //MARK: - let and var
    var tagViewArray: [UILabel] = []
    private var beginTimeStamp: Int = 0
    private var endTimeStamp: Int = 0
    var activityDetailModel:ActivityDetailModel?
    private let activityType: [String] = ["全部","聚餐","运动","旅行","电影","音乐","分享会","赛事","桌游","其他"]
    private var nowActivityType: String = "全部"
    private let colorArray = [UIColor.red,UIColor.blue,UIColor.green,UIColor.yellow]
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
            [weak self] (_) in
            let alert1 = UIAlertController(title: "添加标签", message: "请输入添加标签", preferredStyle: .alert)
            alert1.addTextField(configurationHandler: {(_) in })
            alert1.addAction(UIAlertAction(title: "添加", style: .default, handler: {(alert) in
                self?.tagsArray.append(alert1.textFields![0].text!)
                self?.addTagsIntoView()
            }))
            alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {(_) in }))
            self?.present(alert1, animated: true, completion: {})
        }))
        alert.addAction(UIAlertAction(title: "清除标签", style: .default, handler: {[weak self] (_) in
            self?.tagsArray.removeAll()
            self?.addTagsIntoView()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {[weak self] (_) in }))
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
        self.resignFirstResponder()
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
    
    @IBAction func deleteActivity(_ sender: UIButton) {
        let manager = singleClassManager.manager
        let alert = UIAlertController(title: "正在删除活动", message: "请稍等", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityDetailModel!.activityEnity.id).json"
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.delete(requestUrl, parameters: [],  success: {
            [weak self] (dataTask,response) in
            alert.dismiss(animated: true, completion: nil)
            let _ = self?.navigationController?.popViewController(animated: true)
            
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            //MARK: - 此处弹窗可能出错
            alert.dismiss(animated: true, completion: nil)
            let alert1 = UIAlertController(title: "删除失败", message: "请检查网络连接", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self?.present(alert1, animated: true, completion: nil)
            
        })
        
        
        
    }
    func deleteTapTag(_ sender: UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "删除", style: .default, handler: {_ in
            self.tagsArray.remove(at: index)
            self.addTagsIntoView()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func editDone(_ sender: UIBarButtonItem)
    {
        print("done")
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
            if latitude == nil || longitude == nil
            {
                let alert1 = UIAlertController(title: "请选择活动地点", message: "", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert1, animated: true, completion: nil)
            }else if imageMediaId == nil
            {
                let alert1 = UIAlertController(title: "请上传照片", message: "", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert1, animated: true, completion: nil)
            }else if feeTextField.text == ""
            {
                let alert1 = UIAlertController(title: "请输入活动花费", message: "", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(alert1, animated: true, completion: nil)
            }
            else
            {
            
                let alert = UIAlertController(title: "正在发布活动", message: "请等待", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                var tagString = ""
                for tag in tagsArray
                {
                    tagString += tag + "&"
                }
                
                let requestUrl = urlStruct.basicUrl + "user/~me/activity.json"
                let manager = singleClassManager.manager
                manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
                manager.post(requestUrl, parameters: ["title": activityTitleTextField.text!,"image": imageMediaId!,"beginTime":beginTimeStamp * 1000,"endTime":endTimeStamp * 1000,"address":addressTextField.text!,"latitude":latitude!,"longitude":longitude!,"fee": Int(feeTextField.text!)!,"category":categoryPickerView.selectedRow(inComponent: 0),"content":contentTextView.text!,"tags": tagString], progress: {(progress) in }, success: {
                    [weak self] (dataTask,response) in
                    print("success")
                    alert.dismiss(animated: true, completion: {self?.dismiss(animated: true, completion: nil)})
                    
                    
                    
                
                }, failure: {[weak self] (dataTask,error) in
                    print(error)
                    alert.dismiss(animated: true, completion: {
                        let alert1 = UIAlertController(title: "无法创建活动", message: "请检查网络连接或补全活动信息", preferredStyle: .alert)
                        alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        self?.present(alert1, animated: true, completion: nil)
                    })
                
                })
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityTitleTextField.delegate = self
        self.feeTextField.delegate = self
        self.addressTextField.delegate = self
        self.contentTextView.delegate = self
        
        
        
        
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
            addTagsIntoView()
            //异步获取图片
            let media = activityDetailModel!.activityEnity.image
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            
            //注册地理位置
            longitude = activityDetailModel!.activityEnity.longitude
            latitude = activityDetailModel!.activityEnity.latitude
            if let image = self.getImageFromCaches(mediaId: media)
            {
                self.activityImageImageView.image = image
            }else
            {
                
                DispatchQueue.global().async {
                    
                    if let data = try? Data(contentsOf: URL(string: url)!)
                    {
                        print("获取数据")
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data)
                            {
                                print("显示图片")
                                self.activityImageImageView.image = image
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
        }else
        {
            //MARK: - 稍等处理
            self.categoryPickerView.selectRow(0, inComponent: 0, animated: true)//添加初始值防止崩溃
            
            self.navigationItem.title = "创建活动"
            self.deleteActivityButton.isHidden = true
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
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        if activityDetailModel != nil
        {
            activityDetailModel!.editActivityImage(image: image!, token: token)
            activityImageImageView.image = image
        }else
        {
            let manager = singleClassManager.manager
            let data = UIImagePNGRepresentation(image!)
            let requestUrl = urlStruct.basicUrl + "media.json"
            manager.post(requestUrl, parameters: [], constructingBodyWith: {(fromData) in
                
                fromData.appendPart(withFileData: data!, name: "file", fileName: "image", mimeType: "application/x-www-form-urlencoded")
            }, progress: {(progress) in }, success: {
                [weak self] (dataTask,response) in
                if let JsonDictionary = response as? NSDictionary
                {
                    self?.imageMediaId = (JsonDictionary["media_id"] as! Int)
                    self?.activityImageImageView.image = image!
                }
                
                
                
            }, failure: {[weak self] (dataTask,error) in
                print(error)
                let alert = UIAlertController(title: "上传照片失败", message: "请检查网络连接", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
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
    private func addTagsIntoView()
    {
        var i = 0
        var nextWidth: CGFloat = 8
        var nextY = stackView.frame.maxY + 10
        tagViewArray.forEach({(label) in label.removeFromSuperview()})
        tagViewArray.removeAll()
        if activityDetailModel != nil
        {
            activityDetailModel?.activityEnity.tags = tagsArray as NSArray
            for tagString in tagsArray
            {
                print("1111")
                print("1111")
                let tagLabel = UILabel()
                tagLabel.font = UIFont(name: "Arial", size: 15)
                
                tagLabel.text = tagString
                let size = tagLabel.sizeThatFits(CGSize(width: self.view.frame.width - 16, height: 20))
                if (nextWidth + size.width) > self.view.frame.width - 8
                {
                    nextWidth = 8
                    nextY += 20 + 2
                    
                }
                tagLabel.frame = CGRect(x: nextWidth, y: nextY, width: size.width, height: 20)
                tagLabel.backgroundColor = colorArray[Int(arc4random() % 4)]
                if tagLabel.backgroundColor == UIColor.red || tagLabel.backgroundColor == UIColor.blue
                {
                    tagLabel.textColor = UIColor.white
                }else
                {
                    tagLabel.textColor = UIColor.black
                }
                print(tagString)
                nextWidth = nextWidth + 2 + size.width
                tagLabel.layer.borderWidth = 0.5
                tagLabel.layer.cornerRadius = 4
                tagLabel.layer.masksToBounds = true
                tagLabel.tag = i
                tagLabel.isUserInteractionEnabled = true
                tagLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "deleteTapTag:"))
                self.view.addSubview(tagLabel)
                self.tagViewArray.append(tagLabel)
                i += 1
            }
        }else
        {
            for tagString in tagsArray
            {
                print("1111")
                print("1111")
                let tagLabel = UILabel()
                tagLabel.font = UIFont(name: "Arial", size: 15)
                
                tagLabel.text = tagString
                let size = tagLabel.sizeThatFits(CGSize(width: self.view.frame.width - 16, height: 20))
                if (nextWidth + size.width) > self.view.frame.width - 8
                {
                    nextWidth = 8
                    nextY += 20 + 2
                    
                }
                tagLabel.frame = CGRect(x: nextWidth, y: nextY, width: size.width, height: 20)
                tagLabel.backgroundColor = colorArray[Int(arc4random() % 4)]
                if tagLabel.backgroundColor == UIColor.red || tagLabel.backgroundColor == UIColor.blue
                {
                    tagLabel.textColor = UIColor.white
                }else
                {
                    tagLabel.textColor = UIColor.black
                }
                print(tagString)
                nextWidth = nextWidth + 2 + size.width
                tagLabel.layer.borderWidth = 0.5
                tagLabel.layer.cornerRadius = 4
                tagLabel.layer.masksToBounds = true
                tagLabel.tag = i
                tagLabel.isUserInteractionEnabled = true
                tagLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "deleteTapTag:"))
                self.view.addSubview(tagLabel)
                self.tagViewArray.append(tagLabel)
                i += 1
            }
        }
        
    }
    
    
    
    
    
    // MARK: - pull Data Delegate
    func needUpdateUI() {
        let _ = self.navigationController?.popViewController(animated: true)
        let controller = self.navigationController?.viewControllers.last as! ActicityDetailViewController
        let _ = controller.navigationController?.popViewController(animated: true)
        controller.navigationItem.title = controller.activityModel.activityEnity.activityTitle
        controller.activityTitleLabel.text = controller.activityModel.activityEnity.activityTitle
        
        controller.categoryLabel.text = controller.activityModel.activityEnity.categoryString
        controller.beginTimeLabel.text = controller.activityModel.activityEnity.beginTime.date + " - " + controller.activityModel.activityEnity.endTime.date
        
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
    func selectLocationDone(latitude: Double, longitude: Double, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.addressTextField.text = address
        
    }
    //MARK: - textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //点击其他视图其他地方收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
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
