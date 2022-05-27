//
//  ResultViewController.swift
//  Trivia
//
//  Created by user216397 on 5/18/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
class ResultViewController: UIViewController {
    
    @IBOutlet weak var result_LBL_score: UILabel!
    
    @IBOutlet weak var result_BTN_startover: UIButton!
    let db = Firestore.firestore()
    var playerScore: Int?
    var totalGamesNumber: Int?
    var gameOver: Bool = true
    
    
    @IBOutlet weak var result_LBL_gameover: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(gameOver){
            result_LBL_gameover.isHidden = false
        }else{
            result_LBL_gameover.isHidden = true
        }
        result_LBL_score.text = "\(playerScore!) / \(totalGamesNumber!)"
        
        getLastScore()
    }
    
    
    @IBAction func backToMenu(_ sender: Any) {
    }
    @IBAction func startOver(_ sender: Any) {
    }
    
    func getLastScore(){
        db.collection("score").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let lastScore = document.data()["last_score"] as! Int
                    self.gethighestScore(lastScore)
                }
            }
        }
    }
    
    func gethighestScore(_ lastScore : Int){
        if(playerScore ?? 0 > lastScore){
            updateScore(playerScore!)
        }
        
    }
    
    func updateScore(_ newScore : Int){
        db.collection("score").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "last_score": newScore])
            }
        }
    }
    
    func saveScore(_ newScore : Int){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("score").addDocument(data: [
            "last_score": newScore,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
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
