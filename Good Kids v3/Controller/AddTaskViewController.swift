//
//  AddTaskViewController.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 13/4/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var rewardTextField: UITextField!
    @IBOutlet weak var kidsPickerView: UIPickerView!
    
    @IBAction func addTaskButtonClicked(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add border to description field
        self.descriptionTextField.layer.borderWidth = 5.0
        let borderColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.descriptionTextField.layer.borderColor = borderColor.cgColor
        
    }

  

}
