//
//  slideView.swift
//  test
//
//  Created by Bossxuan on 16/11/28.
//  Copyright © 2016年 Bossxuan. All rights reserved.
//

import UIKit

class slideView: UIScrollView {
    var containerviews : [UIView] = []
        {
        didSet{
            self.contentSize.width = self.frame.width * CGFloat(containerviews.count)
        }
    }
    
        /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(frame: CGRect,numberofview : Int,views: [UIView]?)
    {
        super.init(frame: frame)
        self.contentSize.width = self.frame.width * CGFloat(numberofview)
        self.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        containerviews = views!
        
        let leftgesture = UISwipeGestureRecognizer(target: self, action: "leftslideswitch:")
        leftgesture.direction = .left
        self.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: "rightslideswtich:")
        rightgesture.direction = .right
        self.addGestureRecognizer(rightgesture)
    }
    override func awakeFromNib() {
        
        self.isScrollEnabled = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        let leftgesture = UISwipeGestureRecognizer(target: self, action: "leftslideswitch:")
        leftgesture.direction = .left
        self.addGestureRecognizer(leftgesture)
        let rightgesture = UISwipeGestureRecognizer(target: self, action: "rightslideswtich:")
        rightgesture.direction = .right
        self.addGestureRecognizer(rightgesture)
        

    }
    override func layoutSubviews() {
        for view in containerviews
        {
            view.frame = CGRect(x: self.frame.width * CGFloat(containerviews.index(of: view)!), y: self.bounds.minY, width: self.frame.width, height: self.frame.height)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
    }
    func leftslideswitch(_ sender : UISwipeGestureRecognizer)
    {
        
            print("left")
            UIView.animate(withDuration: 0.5, animations: {
                if self.contentOffset.x != self.contentSize.width - self.frame.width
                {
                    self.contentOffset.x += self.frame.width
                }
            })
        
     
    }
    func rightslideswtich(_ sender : UISwipeGestureRecognizer)
    
    {
        
            print("right")
            UIView.animate(withDuration: 0.5, animations: {
                if self.contentOffset.x != 0
                {
                    self.contentOffset.x -= self.frame.width
                }
            })
        

    }
}
