//
//  AddNextUserViewController.swift
//  abseil
//
//  Created by Aleksandr Ozhogin on 12/3/20.
//

import UIKit
import Firebase

class AddNextUserViewController: UIViewController {

    var user: User?
//    var db: Firestore!
//    var email: String = ""
//    let defaults = UserDefaults.standard
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
          
        

        if loginTextField.text == "" || passwordTextField.text == "" {
            print("Please enter Login/Password")
            
        } else if String(passwordTextField.text!).count < 6 {
            print("Password should be at least 6 digits lengh")
        } else {
            if let user = loginTextField.text {
                var email = "\(user.lowercased())@mydomain.com"
                print(email)
            
                do {
                    try Auth.auth().signOut()
                } catch {print("could not sign out")
                }
                
                Auth.auth().createUser(withEmail: email, password:  passwordTextField.text!) { (user, error) in
                    if error != nil {
                                                                 
                        let message = error?.localizedDescription
                        if message!.contains("The email address is already in use by another account") {
                                print("The user already exists")
                        } else {
                            print("New error: \(String(describing: error))")
                        }
                        } else {
                            if let login = self.loginTextField.text?.lowercased() {
                                print("User \(login) created successfully")
//                                self.db.collection("\(String(self.modelController.user.familyName))").document("\(login)").setData([
//                                    "login": "\(login))",
//                                    "score": -1,
//                                    "name": "\(String(self.nameTextField.text!))",
//                                    "isAdult": "true"
//                                ]) {err in
//                                    if err != nil {
//                                        print("Error writing into the DB")
//                                    } else {
//                                        print("Record has been added to the db")
//                                    }
//                                }
                                                        
                             
                        }}}
                        
                        print("signing out")
                        do {
                            try Auth.auth().signOut()
                            } catch {print("could not sign out")
                            }
                        print("signing back in")
//                        email = "\(self.user.username)@mydomain.com"
                        print("logging back with email: \(email)")
                        if let password = UserDefaults.standard.object(forKey: "password") as? String {
                            Auth.auth().signIn(withEmail: email, password:  password) { (user, error) in
                                if error != nil {
                                    print("some fatal fuckup happened when tried to login back after new user creation: \(error)")
                                } else {print("logged in back successfully")
                                
                                }
                            }
                        
                        }
                        }
                }
        self.dismiss(animated: true, completion: nil)
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
