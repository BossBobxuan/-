//
//  ActivityPhotoListViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/7.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos
class ActivityPhotoListViewController: UIViewController,PullDataDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var containerScrollView: UIScrollView!
    var photoModel: ActivityPhotoModel!
    var activityId: Int!
    
    var nextX: CGFloat = 0
    var nextY: CGFloat = 0
    private var i = 0
    func pullToFresh(_ sender: UIRefreshControl)
    {
        photoModel.refreshActivityPhotoList(activityId: activityId)
    }
    
    func addPhoto(_ sender: UIBarButtonItem)
    {
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
    
    func imageTap(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: seguename.photoListToDetail, sender: sender.view!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photoModel = ActivityPhotoModel(delegate: self)
        photoModel.getActivityPhotoList(activityId: activityId)
      
        self.containerScrollView.refreshControl = UIRefreshControl()
        self.containerScrollView.refreshControl?.addTarget(self, action: "pullToFresh:", for: .valueChanged)
        self.containerScrollView.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        self.containerScrollView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: "addPhoto:")
        
        
        print(activityId)
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func needUpdateUI() {
        print("sucess")
        if containerScrollView.alwaysBounceVertical == false
        {
            containerScrollView.alwaysBounceVertical = true
        }
        
        
        i =  0
        containerScrollView.subviews.forEach({(view) in
            if let _ = view as? UIImageView
            {
                print("imageview")
                view.removeFromSuperview()
            }
        })
        nextY = 0.0
        nextX = 0.0
        if self.containerScrollView.refreshControl!.isRefreshing
        {
            self.containerScrollView.refreshControl?.endRefreshing()
        }
        var j = 0
        for enity in photoModel.enitys
        {
            print("1")
            i += 1
            let imageView = UIImageView(frame: CGRect(x: nextX, y: nextY, width: UIScreen.main.bounds.size.width / 3.0, height: UIScreen.main.bounds.size.width / 3.0))
            imageView.layer.borderWidth = 0.5
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageTap:"))
            imageView.tag = j
            imageView.gestureRecognizers?[0].isEnabled = false
            self.containerScrollView.addSubview(imageView)
            if i == 3
            {
                i = 0
                nextX = 0
                nextY += UIScreen.main.bounds.size.width / 3.0
            }else
            {
                nextX += UIScreen.main.bounds.size.width / 3.0
                
            }
            let media = enity.mediaId
            let url = urlStruct.basicUrl + "media/" + "\(media)"
            if let image = self.getImageFromCaches(mediaId: media)
            {
                imageView.image = image
                imageView.gestureRecognizers?[0].isEnabled = true
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
                                imageView.image = image
                                imageView.gestureRecognizers?[0].isEnabled = true
                                self.saveImageCaches(image: image, mediaId: media)
                            }
                        }
                    }
                }
            }
            
            j += 1

        }
        containerScrollView.contentSize.height = nextY + 10.0
        
    }
    
    func getDataFailed() {
        if containerScrollView.alwaysBounceVertical == false
        {
            containerScrollView.alwaysBounceVertical = true
        }
        if self.containerScrollView.refreshControl!.isRefreshing
        {
            self.containerScrollView.refreshControl?.endRefreshing()
        }
        let alert = UIAlertController(title: "获取数据失败", message: "请检查网络连接", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK: - imagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let controller = activityuploadPhotoViewController()
        
        controller.image = image
        controller.activityId = activityId
        
        picker.dismiss(animated: true, completion:{self.present(controller, animated: true, completion: nil)})
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 上拉刷新
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        {
            print("yes")
            photoModel.getActivityPhotoList(activityId: activityId)
            scrollView.alwaysBounceVertical = false
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.photoListToDetail
        {
            if let controller = segue.destination as? photoDetailViewController
            {
                let imageView = sender as! UIImageView
                controller.enity = photoModel.enitys[imageView.tag]
                controller.temImage = imageView.image!
            }
                
        }
    }
    

}
