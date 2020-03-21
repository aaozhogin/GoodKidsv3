import Firebase

class User {
     
    
    var login: String
    var username: String
    var familyName: String
    var isAdult: Bool
    var score: Int
    var addedToDB: Bool

    init(login:String = "", username:String = "", familyName: String = "", isAdult:Bool = true, score:Int = -1) {
        self.login = login
        self.username = username
        self.familyName = familyName
        self.isAdult = isAdult
        self.score = score
        self.addedToDB = false
    }
    
        
    func addToDB() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let db = Firestore.firestore()
        
        db.collection("users").document("\(self.login)").setData([
            "login": self.login,
            "score": self.score,
            "name": self.username,
            "isAdult": self.isAdult,
            "familyName": self.familyName
        ]) {err in
            if err != nil {
                print("Error writing into the DB")
            } else {
                print("Record has been added to the users db")
                db.collection("families").document("\(self.familyName)").setData([
                    self.username: self.login
                ]) {err in
                    if err != nil {
                        print("Error writing into the DB")
                    } else {
                        print("Record has been added to the famliies db")
        
                        }
                    }
            }
        }
    }
        
    func updateUserDefauls(password: String) {
        let defaults = UserDefaults.standard
        defaults.set("\(self.username)@domain.com", forKey: "email")
        defaults.set(password, forKey: "password")
        
    }
}

