//
//  FirstUseViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/1/4.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class FirstUseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    override func viewDidAppear(_ animated: Bool) {
        let userd = UserDefaults.standard
        print(userd.object(forKey: "token"))
        if userd.object(forKey: "token") != nil
        {
            print("1")
            performSegue(withIdentifier: seguename.firstViewToMain, sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
