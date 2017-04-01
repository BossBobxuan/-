//
//  havePullfreshAndLoadmoreTableView.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/27.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import Foundation
protocol havePullfreshAndLoadmoreTableViewDelegate {
    func pullToRefresh() -> Void
    func loadMore() -> Void
}

//增加了下拉刷新与加载更多的tableview，使用时需要将控制器设置为其delegate并实现havePullfreshAndLoadmoreTableViewDelegate协议，在协议的方法中书写下拉更新与加载更多的函数
class havePullfreshAndLoadmoreTableView: UITableView {
    private var loadingstateUI:UIActivityIndicatorView!//加载更多的状态菊花
    private var btn:UIButton!//加载更多的按钮
    var pullDataDelegate: havePullfreshAndLoadmoreTableViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "pullToRefresh", for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "刷新中")
        //增加读取更多数据的按钮
        addGetMorebtn()

    }
    
    
    private func addGetMorebtn()
    {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        self.tableFooterView = view
        btn = UIButton(type: .system)
        btn.setTitle("加载更多", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        btn.addTarget(self, action: "loadMore:", for: .touchUpInside)
        view.addSubview(btn)
        loadingstateUI = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingstateUI.center = btn.center
        view.addSubview(loadingstateUI)
    }
    //无法使用private修饰，否则无法找到该函数
    func pullToRefresh()
    {
        self.pullDataDelegate.pullToRefresh()
    }
    func loadMore(_ sender: UIButton)
    {
        btn.isHidden = true
        loadingstateUI.startAnimating()
        self.pullDataDelegate.loadMore()
    }
    
    //在拉取数据成功后需要调用该方法来停止菊花的旋转
    func updateTableViewUIWhenPullDataEnd() -> Void
    {
        if self.refreshControl?.isRefreshing == true
        {
            self.refreshControl?.endRefreshing()
            
        }
        if self.loadingstateUI.isAnimating == true
        {
            loadingstateUI.stopAnimating()
            btn.isHidden = false
            
            
        }

    }
    
}
