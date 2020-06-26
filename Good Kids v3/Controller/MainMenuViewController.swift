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
    
    var db: Firestore!
    var user: User!

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var addKidButton: UIButton!
    @IBOutlet weak var addParentButton: UIButton!
    
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddTask", sender: self)
    }
    
    @IBAction func addParentButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNextParentScreen", sender: self)
    }
    
    @IBAction func familyButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toFamilyScreen", sender: self)
    }
    
    @IBAction func addKidButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateKid", sender: self)
        
    }

    @IBAction func logOffButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let loginVC = self.navigationController?.viewControllers[0] as! ViewController
            loginVC.cameFromMainMenu = true
            loginVC.loginTextField.text = ""
            loginVC.passwordTextField.text = ""
            self.navigationController?.popToViewController(loginVC, animated: true)
        } catch {
            print("could not sign out")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
            balanceLabel.isHidden = false
            addParentButton.isHidden = true
            addKidButton.isHidden = true
            balanceLabel.text = "Balance: \(user.score)"
            if user.isBoy {
                print("User is a boy: \(user.isBoy). Setting color to blue")
                view.backgroundColor = UIColor(red: 0.69, green: 0.85, blue: 0.96, alpha: 1.00)
            } else {
                print("User is a girl: \(user.isBoy). Setting color to pink")
                view.backgroundColor = UIColor(red: 0.95, green: 0.90, blue: 0.92, alpha: 1.00)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextParentScreen" {
            print("Preparing segue toNextParentScreen")
            let destinationVC = segue.destination as! AddNextUserViewController
            destinationVC.user = user
        } else if segue.identifier == "toCreateKid" {
            print("Preparing segue toCreateKid")
            let destinationVC = segue.destination as! AddKidViewController
            destinationVC.user = user
        } else if segue.identifier == "toFamilyScreen" {
            print("Preparing segue toFamilyScreen")
            let destinationVC = segue.destination as! FamilyViewController
            destinationVC.user = user
        } else if segue.identifier == "toAddTask" {
            print("Preparing segue toAddTask")
            let destinationVC = segue.destination as! AddTaskViewController
            destinationVC.user = user
        } else {print("wtf is this option?")}
    }

}
