//
//  ResultViewController.swift
//  Trivia
//
//  Created by user216397 on 5/18/22.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var result_LBL_score: UILabel!
    var scoreValue: Int?
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
        result_LBL_score.text = "\(scoreValue!) / \(totalGamesNumber!)"
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
