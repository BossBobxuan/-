//
//  SearchViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/9.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,PullDataDelegate,havePullfreshAndLoadmoreTableViewDelegate{
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var typeSegmentCoutrol: UISegmentedControl!

    @IBOutlet weak var showTableView: havePullfreshAndLoadmoreTableView!
    private var nowtype = "activity"
    private var model: searchModel!
    private var nowKeyword: String?
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            print("0")
            nowtype = "activity"
            showTableView.reloadData()
        }else
        {
            print("1")
            nowtype = "user"
            showTableView.reloadData()
        }
    }
    
    func pullToRefresh() {
        
    }
    func loadMore() {
        if nowKeyword != nil
        {
            self.model.getmoreItem(type: nowtype, keyword: nowKeyword!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        
        self.model = searchModel(delegate: self)
        self.showTableView.delegate = self
        self.showTableView.dataSource = self
        
        showTableView.pullDataDelegate = self
        showTableView.refreshControl = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if nowtype == "user"
        {
            performSegue(withIdentifier: seguename.searchToUserInformation, sender: indexPath.row)
        }else
        {
            performSegue(withIdentifier: seguename.searchToActivityDetail, sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.Enitys[nowtype]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if nowtype == "user"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserInformationTableViewCell
            cell.nameLabel.text = (model.Enitys[nowtype]![indexPath.row] as! UserInformationEnity).name
            cell.discriptionTextView.text = (model.Enitys[nowtype]![indexPath.row] as! UserInformationEnity).description
            if let media = (model.Enitys[nowtype]![indexPath.row] as! UserInformationEnity).avatar
            {
                //在此处异步获取头像照片
                //在此处下载头像照片
                let url = urlStruct.basicUrl + "media/" + "\(media)"
                if let image = self.getImageFromCaches(mediaId: media)
                {
                    cell.avatarImageView.image = image
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
                                    cell.avatarImageView.image = image
                                    self.saveImageCaches(image: image, mediaId: media)
                                }
                            }
                        }
                    }
                }
            }
            cell.followStateButton.isHidden = true
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as! simplyActivityTableViewCell
            cell.activityTitleLabel.text = (model.Enitys[nowtype]![indexPath.row] as! ActiveEnity).activityTitle
            cell.activityBeginTimeLabel.text = (model.Enitys[nowtype]![indexPath.row] as! ActiveEnity).beginTime.date
            cell.activityStateLabel.text = (model.Enitys[nowtype]![indexPath.row] as! ActiveEnity).stateString
            //异步获取头像
            let media = (model.Enitys[nowtype]![indexPath.row] as! ActiveEnity).image
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                cell.activityImageView.image = image
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
                                cell.activityImageView.image = image
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
            return cell

        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model.searchItem(type: "user", keyword: textField.text!)
        model.searchItem(type: "activity", keyword: textField.text!)
        nowKeyword = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    
    func needUpdateUI() {
        showTableView.updateTableViewUIWhenPullDataEnd()
        showTableView.reloadData()
    }
    func getDataFailed() {
        showTableView.updateTableViewUIWhenPullDataEnd()
        let alert = UIAlertController(title: "搜索失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.searchToUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                controller.uid = (model.Enitys["user"]![sender! as! Int] as! UserInformationEnity).id
                controller.title = (model.Enitys["user"]![sender! as! Int] as! UserInformationEnity).name
            }
        }
        else if segue.identifier == seguename.searchToActivityDetail
        {
            if let controller = segue.destination as? ActicityDetailViewController
            {
                controller.activityModel.activityEnity = (model.Enitys["activity"]![sender! as! Int] as! ActiveEnity)
                
                
                
            }
        }
    }
    

}
