//
//  EditActivityViewController.swift
//  约玩平台
//
//  Created by Bossxuan on 17/3/28.
//  Copyright © 2017年 Bossxuan. All rights reserved.
//

import UIKit

class EditActivityViewController: UIViewController {
    @IBOutlet weak var tagsScrollView: UIScrollView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var activityImageImageView: UIImageView!
    @IBOutlet weak var beginTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var datePickerParentView: UIView!
    @IBOutlet weak var activityBeginAndEndTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var categoryPickerParentView: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet weak var catogeryButton: UIButton!
    
    
    @IBAction func needSelectCategory(_ sender: UIButton) {
    }
    
    @IBAction func needSelectBeginTime(_ sender: UIButton) {
    }
    
    @IBAction func needSelectEndTime(_ sender: UIButton) {
    }
    
    @IBAction func categoryPickerDone(_ sender: UIButton) {
    }
    
    @IBAction func categoryPickerCancel(_ sender: UIButton) {
    }
   
    @IBAction func datePickDone(_ sender: UIButton) {
    }
    
    @IBAction func datePickCancel(_ sender: UIButton) {
    }
    
    @IBAction func editActivityImage(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
