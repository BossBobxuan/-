//
//  PersonalInfomationViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/16.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class PersonalInfomationViewController: UIViewController,getPersonalInformationDelegate {
    //MARK: - outlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fansCountsLabel: UILabel!
    @IBOutlet weak var followerCountsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    fileprivate var personalInformationModel: PersonalInformationModel!
    //MARK: - Event func
    
    //此函数用于改变用户活动列表（感兴趣，参加，发布）
    @IBAction func needChangeUserActivityShowList(_ sender: UISegmentedControl) {
    }
    
    //MARK: - viewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.personalInformationModel = PersonalInformationModel(delegate: self)
        
        //此处以后需要更改该token
        personalInformationModel.getPersonalInformation(token: "222")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - delegate
    //此函数用于拉取数据后更新UI
    func needUpdateUI()
    {
        self.nameLabel.text = personalInformationModel.personalInformationEnity!.name
        self.descriptionTextView.text = personalInformationModel.personalInformationEnity!.description
        self.fansCountsLabel.text = "\(personalInformationModel.personalInformationEnity!.fansCount)"
        self.followerCountsLabel.text = "\(personalInformationModel.personalInformationEnity!.followersCount)"
        if let media = personalInformationModel.personalInformationEnity!.avatar
        {
            //在此处下载头像照片
        }
    }
    //此函数用于拉取数据失败的处理
    func getPersonalInformationFailed()
    {
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
