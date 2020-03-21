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
    
    @IBAction func logOffButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let loginVC = self.navigationController?.viewControllers[1] as! ViewController
            self.navigationController?.popToViewController(loginVC, animated: true)
        } catch {
            print("could not sign out")
        }
    }
    
    
    var db: Firestore!
    var user: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyLabel.text = "Family: \(user.familyName)"
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
        print("MainMenuVC: password default value is: \(UserDefaults.standard.object(forKey: "password") as? String)")
        
    
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
            destinationVC.user = user
//        } else if segue.identifier == "backToLoginScreen" {
//            let destinationVC = segue.destination as! ViewController
//            destinationVC.cameFromMainMenu = true
        }
    }

}
