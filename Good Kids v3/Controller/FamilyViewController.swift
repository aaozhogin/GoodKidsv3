//
//  LeaderboardTableViewController.swift
//  Multiplication Game for Lera
//
//  Created by Aleksandr Ozhogin on 30/10/19.
//  Copyright © 2019 Aleksandr Ozhogin. All rights reserved.
//

import UIKit
//import RealmSwift
import Firebase
//import ChameleonFramework

class FamilyViewController: UITableViewController {
    
//  let color = UIColor.flatWatermelon()
    var db: Firestore!
    var user: User!
    var lineArray: Dictionary<Int, (String, String, String)> = [0: ("", "family loading", "")]
    @IBOutlet var family: UITableView!
    
    override func viewDidLoad() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
             
        db = Firestore.firestore()
//        tableView.separatorStyle = .none
        
        family.delegate = self
        family.dataSource = self
        family.register(UINib(nibName: "FamilyTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyTableViewCell")
//        family.rowHeight = 50.0
        loadFamilyMembers()

        print("Family board loaded")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("lineArray.count is: \(lineArray.count)")
        return lineArray.count
    }
    
    func loadFamilyMembers() {
        print("loadFamilyMembers method triggered - Looking for documents with familyName = \(user.familyName)")
        self.lineArray[0] = ("Name", "Type", "Score")
        db.collection("users").whereField("familyName", isEqualTo: "\(user.familyName)").order(by: "isAdult", descending: true)
                   .getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                            var count: Int = 1
                            for document in querySnapshot!.documents {
                                var familyMemberType = ""
                                if let score = document.get("score") as? Int {
                                    print("the score is: \(score)")
                                    if let familyMemberName = document.get("name") as? String {
                                        print("the family member name is: \(familyMemberName)")
                                        if let isAdult = document.get("isAdult") as? Bool {
                                            if isAdult {
                                                familyMemberType = "Adult"
                                            } else {
                                                familyMemberType = "Kid"
                                            }
                                            let familyMemberScore = String(score)
                                            self.lineArray[count] = (familyMemberName, familyMemberType, familyMemberScore)
                                            count += 1
                                        } else {
                                            print("Could not cast isAdult as Bool")
                                        }
                                    } else {
                                        print("Could not cast name as String")
                                    }
                                } else {
                                    print("Could not cast score as Int")
                                }
                           }
                       }
                    self.tableView.reloadData()
               }
    }

    override func viewWillAppear(_ animated: Bool) {
        guard (navigationController?.navigationBar) != nil else {fatalError("Navigation controller does not exist")}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = family.dequeueReusableCell(withIdentifier: "FamilyTableViewCell", for: indexPath) as! FamilyTableViewCell
        if indexPath.row == 0 {
            cell.nameTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
            cell.userTypeTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
            cell.scoreTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        }
        cell.nameTextField.text = lineArray[indexPath.row]?.0
        cell.userTypeTextField.text = lineArray[indexPath.row]?.1
        if lineArray[indexPath.row]?.1 == "Adult" {
            cell.scoreTextField.text = "N/A"
        } else {
            cell.scoreTextField.text = lineArray[indexPath.row]?.2
        }
        return cell
    }
}


