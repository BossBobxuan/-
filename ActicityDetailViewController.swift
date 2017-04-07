//
//  ActicityDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/23.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class ActicityDetailViewController: UIViewController, PullDataDelegate {
    //MARK: - outlet
    
    @IBOutlet weak var activityImageImageView: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var wishedCountLabel: UILabel!
    @IBOutlet weak var participatedCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var creatTimeLabel: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var wishedButton: UIButton!
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var tagsScrollView: UIScrollView!
    //MARK: - var and let
    var activityModel: ActivityDetailModel! = ActivityDetailModel()
    var havePowerToEdit: Bool = false
    //MARK: - event func
    func toEditActivity()
    {
        performSegue(withIdentifier: seguename.toEditActivity, sender: activityModel)
    }
    //分享活动
    func shareActivity(_ sender: UIBarButtonItem)
    {
        
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
    
    @IBAction func showParticipateList(_ sender: UIButton)
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
        }else if participateButton.titleLabel?.text == "已参加"
        {
            activityModel.unparticipateActivity(token: token)
            participateButton.isEnabled = false
            participateButton.setTitle("+ 参加", for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityModel.delegate = self
        // Do any additional setup after loading the view.
        navigationItem.title = activityModel.activityEnity.activityTitle
        activityTitleLabel.text = activityModel.activityEnity.activityTitle
        contentTextView.text = activityModel.activityEnity.content
        categoryLabel.text = activityModel.activityEnity.categoryString
        beginTimeLabel.text = activityModel.activityEnity.beginTime.date
        endTimeLabel.text = activityModel.activityEnity.endTime.date
        creatTimeLabel.text = activityModel.activityEnity.creatAt.date
        wishedCountLabel.text = "\(activityModel.activityEnity.wisherCount)"
        participatedCountLabel.text = "\(activityModel.activityEnity.participantCount)"
        addressLabel.text = activityModel.activityEnity.address
        photoCountLabel.text = "\(activityModel.activityEnity.photoCount)"
        notificationCountLabel.text = "\(activityModel.activityEnity.notificationCount)"
        feeLabel.text = "\(activityModel.activityEnity.fee)"
        commentCountLabel.text = "\(activityModel.activityEnity.commentCount)"
        
        
        let bar = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: "shareActivity:")
        self.navigationItem.rightBarButtonItems = [bar]
        if havePowerToEdit
        {
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: "toEditActivity"))
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
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.get(requestUrl, parameters: [], progress: {(progress) in }, success: {
            (dataTask,response) in
            print("success")
            if let JsonDic = response as? NSDictionary
            {
                if let wish = JsonDic["wish_relation"] as? String
                {
                    switch wish
                    {
                        case "0": self.wishedButton.setImage(#imageLiteral(resourceName: "interest.png"), for: .normal)
                        case "1": self.wishedButton.setImage(#imageLiteral(resourceName: "interestclicked.png"), for: .normal)
                        default: self.wishedButton.setImage(#imageLiteral(resourceName: "interest.png"), for: .normal)
                    }
                }
                if let participate = JsonDic["participate_relation"] as? String
                {
                    switch participate
                    {
                        case "0": self.participateButton.setTitle("+ 参加", for: .normal)
                        case "1": self.participateButton.setTitle("已参加", for: .normal)
                    default: break 
                    }
                }
            }
            
            
        }, failure: {(dataTask,error) in
            print(error)
            let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        })
        
        
        addTagsIntoScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTagsIntoScrollView()
    {
        var i = 0
        var nextWidth: CGFloat = 0.0
        for tag in activityModel.activityEnity.tags
        {
            if let tagString = tag as? String
            {
                print("1111")
                print("1111")
                let tagLabel = UILabel()
                tagLabel.font = UIFont(name: "Arial", size: 15)
                tagLabel.textColor = UIColor.black
                tagLabel.text = tagString
                let size = tagLabel.sizeThatFits(UIScreen.main.bounds.size)
                tagLabel.frame = CGRect(x: nextWidth, y: tagsScrollView.bounds.origin.y, width: size.width, height: tagsScrollView.bounds.height)
                print(tagString)
                nextWidth = nextWidth + 10 + size.width
                tagLabel.layer.borderWidth = 0.5
                tagLabel.layer.cornerRadius = 8
                tagsScrollView.addSubview(tagLabel)
            }
            i += 1
        }
         tagsScrollView.contentSize.width = nextWidth
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
        }
    }
 

}
