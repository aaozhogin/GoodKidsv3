//
//  MainMenuViewController.swift
//  Good Kids v3
//
//  Created by Aleksandr Ozhogin on 11/3/20.
//  Copyright © 2020 Aleksandr Ozhogin. All rights reserved.
//

import UIKit
import Firebase

class MainMenuViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBAction func addParentButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNextParentScreen", sender: self)
    }
    
    var db: Firestore!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.score >= 0 {
        balanceLabel.text = "Balance: \(user.score)"
        } else {
            balanceLabel.text = ""
        }
        if user.isAdult {
        welcomeLabel.text = "Hello \(user.username)! \n you are adult"
        } else {
        welcomeLabel.text = "Hello \(user.username)! \n you are kid"
        }
        
        familyLabel.text = "Family: \(user.familyName)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextParentScreen" {
            let destinationVC = segue.destination as! AddNextUserViewController
//            destinationVC.user = self.user
        }
    }

}
