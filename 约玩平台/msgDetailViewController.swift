//
//  msgDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/12.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
class testModel  {
    var direction: String
    var content: String
    init(direction: String,content: String) {
        self.direction = direction
        self.content = content
    }
}
class msgDetailViewController: UIViewController, PullDataDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet weak var containScrollView: UIScrollView!
    var uid: Int!
    private var inputTextField: UITextField!
    private var beShowingList: [PrivateEnity] = []//缓存来表示当前屏幕上显示的对象
    private var page = 1//表示当前请求的页数
    private var isRequesting: Bool = false//表示是否正在请求避免重复请求
    private var avatarImage: UIImage?
    private var personalAvatarImage: UIImage?
    private var isGetmore: Bool = false
    private var addNumber: Int = 0
    private var nextY: CGFloat = 8
    private var screentrailing: CGFloat
        {
            return containScrollView.bounds.width - 8
    }
    private var borderDisdance: CGFloat
    {
        let contentLabel = UILabel()
        contentLabel.text = "0"
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byTruncatingTail
        let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 444440))
        return (40 - size.height) / 2
    }
    var model: DetailPrivateModel!
    var timer: Timer!
    func toUserInformation(_ sender: UITapGestureRecognizer)
    {
        if uid == -255
        {
            
        }else
        {
            if sender.view!.tag == 0
            {
                performSegue(withIdentifier: seguename.msgDetailToUserInformation, sender: 1)
            }else
            {
                performSegue(withIdentifier: seguename.msgDetailToUserInformation, sender: nil)
            }
        }
      
    }
    func toUser(_ sender: UIBarButtonItem)
    {
        if uid != -255
        {
            performSegue(withIdentifier: seguename.msgDetailToUserInformation, sender: nil)
        }
    }
    func resignKeyBoard()
    {
        print("re")
        self.inputTextField.resignFirstResponder()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        containScrollView.delegate = self
        containScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignKeyBoard"))
        
        model = DetailPrivateModel(delegate: self)
        model.getPersonalAvatar(token: token)
        model.getMsgDetailList(token: token, uid: uid)
        print(self.view.frame.maxY)
        print(containScrollView.frame.height)
        print(UIScreen.main.bounds.height)
        self.inputTextField = UITextField(frame: CGRect(x: 8, y: containScrollView.frame.maxY + 5, width: UIScreen.main.bounds.width - 16, height: 25))
        
        inputTextField.layer.borderWidth = 0.5
        inputTextField.layer.cornerRadius = 5
        self.view.addSubview(inputTextField)
        inputTextField.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "people.png"), style: .bordered, target: self, action: "toUser:")
        //设置定时器轮询获得新消息
        timer = Timer(timeInterval: 2, repeats: true, block: {[weak self](_) in
            
            print("timer")
            if !(self?.isRequesting)!
            {
                self?.isRequesting = true
                if (self?.beShowingList.count)! > 20
                {
                    for _ in 0 ..< 20
                    {
                        self?.beShowingList.removeLast()
                    }
                }else
                {
                    self?.beShowingList.removeAll()
                }
                
                self?.model.getMsgDetailList(token: (self?.token)!, uid: (self?.uid)!)
            }
            
            
        })//此处需要释放
        DispatchQueue.global().async {
            print("子线程")
            RunLoop.current.add(self.timer, forMode: .commonModes)
            RunLoop.current.run()//必须手动使当前runloop运行
            
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        print("2")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    //MARK: - textFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {
            self.inputTextField.frame =  CGRect(x: 8, y: self.containScrollView.frame.maxY + 5 - 235, width: UIScreen.main.bounds.width - 16, height: 25)
            self.containScrollView.frame.origin.y -= 235
            self.containScrollView.contentInset.top += 235

//            if self.inputTextField.frame.minY > self.nextY
//            {
//            }
            
            
        })
        
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        model.sendMsgToUser(token: token, uid: uid, content: textField.text!)
        textField.text = ""
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("1")
        UIView.animate(withDuration: 0.25, animations: {
            self.inputTextField.frame =  CGRect(x: 8, y: self.containScrollView.frame.maxY + 5 + 235, width: UIScreen.main.bounds.width - 16, height: 25)
            self.containScrollView.frame.origin.y += 235
            if self.containScrollView.contentInset.top > 0
            {
                self.containScrollView.contentInset.top = 0
            }
        })
    }
    //MARK: - scrollview delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y < 0 && scrollView.contentInset.top == 0) || (scrollView.contentOffset.y < -235 && scrollView.contentInset.top > 0)
        {
            timer.fireDate = Date.distantFuture
            isGetmore = true
            model.getMoreMsgDetailList(token: token, uid: uid, success:{[weak self] in
                self?.isGetmore = false
                
                self?.timer.fireDate = Date.distantPast
            
            }, page: page)
            scrollView.isScrollEnabled = false
        }
    }
  
    //MARK: - pulldata delegate
    func needUpdateUI() {
        
        containScrollView.isScrollEnabled = true
        if !isRequesting
        {
            addNumber = model.enitys.count - beShowingList.count
            if addNumber > 0
            {
                print("in")
                beShowingList.removeAll()
                for enity in model.enitys.reversed()
                {
                    beShowingList.append(enity)
                }
                page += 1

            }
        }else
        {
            for enity in model.enitys.reversed()
            {
                beShowingList.append(enity)
            }
            
        }
        
        
        
        
        
        if avatarImage == nil
        {
            let media = model.avatar!
            print(media)
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                self.avatarImage = image
                
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
                                self.avatarImage = image
                            }
                        }
                    }
                }
            }
        }
        if personalAvatarImage == nil
        {
            let media = model.personalavatar!
            print(media)
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                self.personalAvatarImage = image
                
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
                                self.personalAvatarImage = image
                            }
                        }
                    }
                }
            }
        }
        showMsgList(array: beShowingList)
        self.isRequesting = false
        
        
        
    }
    func getDataFailed() {
        let alert = UIAlertController(title: "获取列表失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    private func showMsgList(array: [PrivateEnity])
    {
        nextY = 0
        var i = 0
        var sizey: CGFloat = 0
        for view in containScrollView.subviews
        {
            view.removeFromSuperview()
        }
        
        for enity in array
        {
            i = i + 1
            if enity.direction == "0"//我发送的
            {
                let avatar = UIImageView(frame: CGRect(x: screentrailing - 40, y: nextY, width: 40, height: 40))
                avatar.isUserInteractionEnabled = true
                avatar.tag = 0//证明为自己
                avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toUserInformation:"))
                avatar.layer.cornerRadius = 20
                avatar.layer.masksToBounds = true
                avatar.image = personalAvatarImage
                let contentLabel = UILabel()
                contentLabel.text = enity.content
                if contentLabel.text == ""
                {
                    contentLabel.text = " "
                }
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byTruncatingTail
                let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 444440))
                
                contentLabel.frame = CGRect(x: borderDisdance, y: borderDisdance, width: size.width, height: size.height)
                let containView = UIView(frame: CGRect(x: avatar.frame.minX - 8 - (size.width + 2 * borderDisdance), y: nextY, width: size.width + 2 * borderDisdance, height: size.height + 2 * borderDisdance))
                containView.layer.borderWidth = 0.5
                containView.layer.cornerRadius = 4
                containView.backgroundColor = UIColor.yellow
                containView.addSubview(contentLabel)
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(containView)
                
                nextY = containView.frame.maxY + 10
                
                
            }else //对方发送的
            {
                let avatar = UIImageView(frame: CGRect(x: 8, y: nextY, width: 40, height: 40))
                avatar.isUserInteractionEnabled = true
                avatar.tag = 1//证明为自己
                avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "toUserInformation:"))
                avatar.layer.cornerRadius = 20
                avatar.layer.masksToBounds = true
                avatar.image = avatarImage
                let contentLabel = UILabel()
                contentLabel.text = enity.content
                if contentLabel.text == ""
                {
                    contentLabel.text = " "
                }
                contentLabel.numberOfLines = 0
                contentLabel.lineBreakMode = .byTruncatingTail
                let size = contentLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 110, height: 4444440))
                let containView = UIView(frame: CGRect(x: 56, y: nextY, width: size.width + 2 * borderDisdance, height: size.height + 2 * borderDisdance))
                contentLabel.frame = CGRect(x: borderDisdance, y: borderDisdance, width: size.width, height: size.height)
                containView.layer.borderWidth = 0.5
                containView.layer.cornerRadius = 4
                containView.addSubview(contentLabel)
                containScrollView.addSubview(avatar)
                containScrollView.addSubview(containView)
                nextY = containView.frame.maxY + 10
            }
            if i == addNumber
            {
                sizey = nextY
            }
           
            
            
           

        }
        containScrollView.contentSize.height = nextY + 10
        if !isRequesting
        {
            if containScrollView.contentSize.height - containScrollView.frame.height > 0
            {
                containScrollView.contentOffset.y = containScrollView.contentSize.height - containScrollView.frame.height
            
            }else
            {
                containScrollView.contentOffset.y = 0
            }
            
        }
        if isGetmore
        {
            containScrollView.contentOffset.y = sizey
        }
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.msgDetailToUserInformation
        {
            if let controller = segue.destination as? PersonalInfomationViewController
            {
                if sender == nil
                {
                    controller.uid = uid
                }
            }
        }
        
        
    }
    

}
