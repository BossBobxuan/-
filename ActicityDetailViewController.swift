//
//  ActicityDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import UserNotifications
class ActicityDetailViewController: UIViewController, PullDataDelegate {
    //MARK: - outlet
    
    @IBOutlet weak var activityImageImageView: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
   
    @IBOutlet weak var wishedCountLabel: UILabel!
    @IBOutlet weak var participatedCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    
    @IBOutlet weak var creatorLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var stackView: UIStackView!//作为tag的定位来使用
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var wishedButton: UIButton!
    @IBOutlet weak var participateButton: UIButton!
   
    //MARK: - var and let
    var activityModel: ActivityDetailModel = ActivityDetailModel()
    var havePowerToEdit: Bool = false
    let manager = singleClassManager.manager
    private var nextY: CGFloat = 0
    private let colorArray = [UIColor.red,UIColor.blue,UIColor.green,UIColor.yellow]
    private let notificationCenter = UNUserNotificationCenter.current()
    //MARK: - event func
    func toEditActivity()
    {
        performSegue(withIdentifier: seguename.toEditActivity, sender: activityModel)
    }
    //分享活动
    func shareActivity(_ sender: UIBarButtonItem)
    {
        
        let urlString = urlStruct.basicUrl + "mobile.html?id=" + "\(activityModel.activityEnity.id)"
        let media = activityModel.activityEnity.image
        let url = urlStruct.basicUrl + "media/" + "\(media)"
        
        let newsObj = QQApiNewsObject(url: URL(string: urlString)!, title: activityModel.activityEnity.activityTitle, description: activityModel.activityEnity.content, previewImageURL: URL(string: url)!, targetContentType: QQApiURLTargetTypeNews)
        let req = SendMessageToQQReq(content: newsObj)
        let _ = QQApiInterface.send(req!)
        
        
    }
    @IBAction func toPhotoViewController(_ sender: UIButton) {
        performSegue(withIdentifier: seguename.toActivityPhoto, sender: nil)
    }
    
    
    //点击表示对活动感兴趣
    @IBAction func showWishedList(_ sender: UIButton) {
        //MARK: - 此处需要先进行setImage才有效果
        if sender.currentImage == #imageLiteral(resourceName: "interest.png")
        {
            sender.setImage(#imageLiteral(resourceName: "interestclicked.png"), for: .normal)
            wishedCountLabel.text = "\(activityModel.activityEnity.wisherCount + 1)"
            activityModel.interestActivity(token: token)
            sender.isEnabled = false
            
        }else if sender.currentImage == #imageLiteral(resourceName: "interestclicked.png")
        {
            sender.setImage(#imageLiteral(resourceName: "interest.png"), for: .normal)
            wishedCountLabel.text = "\(activityModel.activityEnity.wisherCount - 1)"
            activityModel.uninterestActivity(token: token)
            sender.isEnabled = false
        }
        
    }
    
    func showParticipateList(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: seguename.toActivityUserIn, sender: self)
    }
    @IBAction func showComment(_ sender: UIButton) {
        performSegue(withIdentifier: seguename.toComment, sender: self)
    }
    
    @IBAction func showNotification(_ sender: UIButton) {
        performSegue(withIdentifier: seguename.toNotificationTableView, sender: self)
      
    }
   
 
    @IBAction func participateActivity(_ sender: UIButton) {
        if participateButton.titleLabel?.text == "+ 参加"
        {
            activityModel.participateActivity(token: token)
            participateButton.isEnabled = false
            participateButton.setTitle("已参加", for: .normal)
            let date = Date(timeIntervalSinceNow: 0)
            let timeInterval = Double(activityModel.activityEnity.beginTime / 1000 - 1800) - date.timeIntervalSince1970
            print(date.timeIntervalSince1970)
            print(timeInterval)
            if timeInterval > 0
            {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: activityModel.activityEnity.activityTitle, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "你的活动将于" + activityModel.activityEnity.beginTime.date + "开始", arguments: nil)
                
                let triger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: "\(activityModel.activityEnity.id)", content: content, trigger: triger)
                notificationCenter.add(request, withCompletionHandler: nil)
            }
            
            
            
            
            
        }else if participateButton.titleLabel?.text == "已参加"
        {
            activityModel.unparticipateActivity(token: token)
            participateButton.isEnabled = false
            participateButton.setTitle("+ 参加", for: .normal)
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(activityModel.activityEnity.id)"])
        }
    }
    func toComment()
    {
        performSegue(withIdentifier: seguename.toComment, sender: self)
    }
    func toUserInformation(_ sender: UITapGestureRecognizer)
    {
        print("userInformation")
        performSegue(withIdentifier: seguename.ActivityDetailToUserInformation, sender: nil)
    }
    
    func toActivityLocation(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: seguename.toActivityLocation, sender: nil)
    }
    func toNotification()
    {
        performSegue(withIdentifier: seguename.toNotificationTableView, sender: self)
    }
    func toPhoto()
    {
        performSegue(withIdentifier: seguename.toActivityPhoto, sender: nil)
    }
    func reportActivity()
    {
        performSegue(withIdentifier: seguename.ActivityToReport, sender: nil)
    }
    
    
    
    //MARK: - viewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        activityModel.delegate = self
        // Do any additional setup after loading the view.
        navigationItem.title = activityModel.activityEnity.activityTitle
        activityTitleLabel.text = activityModel.activityEnity.activityTitle
        
        categoryLabel.text = activityModel.activityEnity.categoryString
        beginTimeLabel.text = activityModel.activityEnity.beginTime.date + " - " + activityModel.activityEnity.endTime.date
        wishedCountLabel.text = "\(activityModel.activityEnity.wisherCount)"
        participatedCountLabel.text = "\(activityModel.activityEnity.participantCount)"
        participatedCountLabel.isUserInteractionEnabled = true
        participatedCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showParticipateList:"))
        addressLabel.text = activityModel.activityEnity.address
        addressLabel.isUserInteractionEnabled = true
        addressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toActivityLocation:"))
        photoCountLabel.text = "\(activityModel.activityEnity.photoCount)"
        photoCountLabel.isUserInteractionEnabled = true
        photoCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toPhoto"))
        notificationCountLabel.text = "\(activityModel.activityEnity.notificationCount)"
        notificationCountLabel.isUserInteractionEnabled = true
        notificationCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toNotification"))
        feeLabel.text = "\(activityModel.activityEnity.fee)"
        commentCountLabel.text = "\(activityModel.activityEnity.commentCount)"
        commentCountLabel.isUserInteractionEnabled = true
        commentCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toComment"))
        creatorLabel.text = activityModel.activityEnity.creator.name
        creatorLabel.isUserInteractionEnabled = true
        creatorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toUserInformation:"))
        
       
        let bar = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: "shareActivity:")
        self.navigationItem.rightBarButtonItems = [bar]
        if havePowerToEdit
        {
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: "toEditActivity"))
        }else
        {
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: #imageLiteral(resourceName: "report.png"), style: .bordered, target: self, action: "reportActivity"))
        }
        
        let media = activityModel.activityEnity.image
        let url = urlStruct.basicUrl + "media/" + "\(media)"
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
        
        //以下用来获取活动状态
        let requestUrl = urlStruct.basicUrl + "activity/" + "\(activityModel.activityEnity.id).json"
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: [], progress: {(progress) in }, success: {
            [weak self] (dataTask,response) in
            print("success")
            if let JsonDic = response as? NSDictionary
            {
                if let wish = JsonDic["wish_relation"] as? String
                {
                    switch wish
                    {
                        case "0": self?.wishedButton.setImage(#imageLiteral(resourceName: "interest.png"), for: .normal)
                        case "1": self?.wishedButton.setImage(#imageLiteral(resourceName: "interestclicked.png"), for: .normal)
                        default: self?.wishedButton.setImage(#imageLiteral(resourceName: "interest.png"), for: .normal)
                    }
                }
                if let participate = JsonDic["participate_relation"] as? String
                {
                    switch participate
                    {
                        case "0": self?.participateButton.setTitle("+ 参加", for: .normal)
                        case "1": self?.participateButton.setTitle("已参加", for: .normal)
                      
                        
                        
                        
                        
                        default: break
                    }
                }
            }
         
            
            
        }, failure: {[weak self] (dataTask,error) in
            print(error)
            let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
            
        })
        addTagsIntoView()
        addContentLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addContentLabel()
    {
        let titleLabel = UILabel()
        titleLabel.text = "活动详情"
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 8, y: nextY + 30, width: self.containerView.frame.width - 16, height: 30)
        containerView.addSubview(titleLabel)
        nextY += 30
        
        
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = activityModel.activityEnity.content
        let size = contentLabel.sizeThatFits(CGSize(width: self.containerView.frame.width - 16, height: 900 - nextY - 60))
        contentLabel.frame = CGRect(x: 8, y: nextY + 30, width: size.width, height: size.height)
        containerView.addSubview(contentLabel)
        
        
    }
    
    
    
    
    
    func addTagsIntoView()
    {
        var i = 0
        var nextWidth: CGFloat = 8
        nextY = stackView.frame.maxY + 10
        for tag in activityModel.activityEnity.tags
        {
            if let tagString = tag as? String
            {
                print("1111")
                print("1111")
                let tagLabel = UILabel()
                tagLabel.font = UIFont(name: "Arial", size: 15)
                
                tagLabel.text = tagString
                let size = tagLabel.sizeThatFits(CGSize(width: self.containerView.frame.width - 16, height: 20))
                if (nextWidth + size.width) > self.containerView.frame.width - 8
                {
                    nextWidth = 8
                    nextY += 20 + 2
                    
                }
                tagLabel.frame = CGRect(x: nextWidth, y: nextY, width: size.width, height: 20)
                tagLabel.backgroundColor = UIColor(displayP3Red: 0.463, green: 0.565, blue: 0.647, alpha: 1)
                tagLabel.textColor = UIColor.white
                print(tagString)
                nextWidth = nextWidth + 2 + size.width
                tagLabel.layer.borderWidth = 0.5
                tagLabel.layer.cornerRadius = 4
                tagLabel.layer.masksToBounds = true
                containerView.addSubview(tagLabel)
            }
            i += 1
        }
        
    }
    //MARK: - pull Data Delegate
    func needUpdateUI() {
        print(wishedCountLabel.text!)
        activityModel.activityEnity.wisherCount = Int(wishedCountLabel.text!)!
        wishedButton.isEnabled = true
        participateButton.isEnabled = true
    }
    func getDataFailed() {
        let alert = UIAlertController(title: "无法关注活动", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        wishedCountLabel.text = "\(activityModel.activityEnity.wisherCount)"
        participateButton.isEnabled = true
        wishedButton.isEnabled = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguename.toActivityUserIn
        {
            if let controller = segue.destination as? ShowUserViewController
            {
                controller.uid = activityModel.activityEnity.id
                controller.type = "participant"
            }
        }
        else if segue.identifier == seguename.toComment
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.id = activityModel.activityEnity.id
                controller.type = "activity"
            }
        }else if segue.identifier == seguename.toEditActivity
        {
            if let controller = segue.destination as? EditActivityViewController
            {
                controller.activityDetailModel = self.activityModel
                
            }
        }else if segue.identifier == seguename.toNotificationTableView
        {
            if let controller = segue.destination as? NotificationListViewController
            {
                controller.activityId = activityModel.activityEnity.id
                controller.havePowerToEdit = self.havePowerToEdit
            }
        }else if segue.identifier == seguename.toActivityLocation
        {
            if let controller = segue.destination as? ActivityLocationViewController
            {
                controller.latitude = activityModel.activityEnity.latitude
                controller.longitude = activityModel.activityEnity.longitude
            }
        }else if segue.identifier == seguename.toActivityPhoto
        {
            if let controller = segue.destination as? ActivityPhotoListViewController
            {
                controller.activityId = self.activityModel.activityEnity.id
            }
        }else if segue.identifier == seguename.ActivityDetailToUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = activityModel.activityEnity.creator.id
            }
        }else if segue.identifier == seguename.ActivityToReport
        {
            if let controller = segue.destination as? ReportViewController
            {
                controller.uid = activityModel.activityEnity.id
                controller.attachType = 1
            }
        }
            
    }
 

}
