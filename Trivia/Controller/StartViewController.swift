//
//  StartViewController.swift
//  Trivia
//
//  Created by user216397 on 5/18/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class StartViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var start_BTN_start: UIButton!
    @IBOutlet weak var start_LBL_score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastScore()
    }
    
    @IBAction func startGame(_ sender: UIButton) {
    }
    func getLastScore(){
        db.collection("score").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let lastScore = document.data()["last_score"] as! Int
                    self.start_LBL_score.text = "\(lastScore)/15"
                }
            }
        }
    }


}
