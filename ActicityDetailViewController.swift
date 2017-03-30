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
    }
   
 
    @IBAction func participateActivity(_ sender: UIButton) {
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
        
        if havePowerToEdit
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: "toEditActivity")
        }
        
        
        addTagsIntoScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTagsIntoScrollView()
    {
        var i = 0
        tagsScrollView.contentSize.width = CGFloat(50 * (activityModel.activityEnity.tags.count + 1))
        for tag in activityModel.activityEnity.tags
        {
            if let tagString = tag as? String
            {
                print("1111")
                let tagLabel = UILabel(frame: CGRect(x: CGFloat(50 * i), y: tagsScrollView.bounds.origin.y, width: CGFloat(40), height: tagsScrollView.bounds.height))
                tagLabel.font = UIFont(name: "Arial", size: 15)
                tagLabel.textColor = UIColor.black
                tagLabel.text = tagString
                print(tagString)
                tagsScrollView.addSubview(tagLabel)
            }
            i += 1
        }
        
    }
    //MARK: - pull Data Delegate
    func needUpdateUI() {
        print(wishedCountLabel.text!)
        activityModel.activityEnity.wisherCount = Int(wishedCountLabel.text!)!
        wishedButton.isEnabled = true
        
    }
    func getDataFailed() {
        let alert = UIAlertController(title: "无法关注活动", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        }
    }
 

}
