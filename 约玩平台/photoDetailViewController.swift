//
//  photoDetailViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/4/9.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit
import Photos

class photoDetailViewController: UIViewController {
    var enity: PhotoEnity!
    var temImage: UIImage!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBAction func toComment(_ sender: UIButton) {
        performSegue(withIdentifier: seguename.photoDetailToComment, sender: self)
        
    }
    func deleteImage(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "是否删除图片", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: {[weak self] (alert) in
            let alert1 = UIAlertController(title: "正在删除图片", message: nil, preferredStyle: .alert)
            self?.present(alert1, animated: true, completion: nil)
            let requestUrl = urlStruct.basicUrl + "photo/" + "\(self?.enity.id).json"
            let manager = singleClassManager.manager
            manager.requestSerializer.setValue(self?.token, forHTTPHeaderField: "token")
            manager.delete(requestUrl, parameters: nil, success: {(response,datatask) in
                alert1.dismiss(animated: true, completion: {let _ = self?.navigationController?.popViewController(animated: true)})
            
            
            }, failure: {(datatask,error) in
                print(error)
                let alert = UIAlertController(title: "删除失败", message: "请检查网络连接", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
        
        }))
        alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func saveImage(_ sender: UILongPressGestureRecognizer)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "保存", style: .default, handler: {(alert) in
            PHPhotoLibrary.requestAuthorization({(status) in
                if status == PHAuthorizationStatus.authorized
                {
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.9)
                    
                    UIImageWriteToSavedPhotosAlbum(UIImage(data: data!)!, self, "imageWasSavedSuccessfully:didFinishedwitherror:context:", nil)
                    
                }
                else if status == PHAuthorizationStatus.denied
                {
                    let alert1 = UIAlertController(title: "没有访问相册权限", message: "请前往设置打开设置权限", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    self.present(alert1, animated: true, completion: nil)
                }
                
            })
        
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func imageWasSavedSuccessfully(_ image: UIImage,didFinishedwitherror: NSError!,context: UnsafeMutableRawPointer)
    {
        let alert = UIAlertController(title: "保存图片到相册", message: nil, preferredStyle: .alert)
        alert.view.alpha = 0.5
        self.present(alert, animated: true, completion: nil)
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(_) in alert.dismiss(animated: true, completion: nil)})
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = temImage
        self.navigationItem.title = enity.creatAt.date
        self.descriptionLabel.text = enity.description
        self.commentCountLabel.text = "\(enity.commentCount)"
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "saveImage:"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: "deleteImage:")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == seguename.photoDetailToComment
        {
            if let controller = segue.destination as? commentListViewController
            {
                controller.type = "photo"
                controller.id = enity.id
            }
        }
        
        
    }
    

}
