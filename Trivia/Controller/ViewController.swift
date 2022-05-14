

import UIKit
import FirebaseFirestore
import FirebaseCore

class ViewController: UIViewController {
    
    @IBOutlet weak var main_PB_progress: UIProgressView!
    @IBOutlet weak var main_LBL_games: UILabel!
    @IBOutlet weak var main_LBL_life: UILabel!
    @IBOutlet weak var main_IMG_image: UIImageView!
    @IBOutlet weak var main_BTN_choice4: UIButton!
    @IBOutlet weak var main_BTN_choice3: UIButton!
    @IBOutlet weak var main_BTN_choice2: UIButton!
    @IBOutlet weak var main_BTN_choice1: UIButton!
    
    
    var quizBrain = QuizBrian()
    var timer = Timer()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initImageBorder()
        // initQuestions()
        
        getDogsListFromFirestore()
        
    }
    
    
    @IBAction func onClickAnswer(_ sender: UIButton) {
        let userAnswer = sender.currentTitle

        print("userAnswer: \(String(describing: userAnswer)) rightAnswer: \(self.quizBrain.question.rightAnswer)")
        if(userAnswer == self.quizBrain.question.rightAnswer){
            sender.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            print("---> rignt")
        }
        else{
            sender.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            print("---> wrong")
        }
        
        timer.invalidate()
       timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            sender.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
           self.initTriviaView()
           
            }

        // sender.tintColor = UIColor.blue
        
        // initTriviaView()
    }

    
    func getDogsListFromFirestore(){
        db.collection("dogs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("There was an issue retriving data from Firestore.  \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //init dogs list
                    self.quizBrain.setDogsData(firebaseData: document.data())
                    
                }
                
                self.initTriviaView()
            }
        }
        
    }
    
    
    func initImageBorder(){
        main_IMG_image.layer.masksToBounds = true
        main_IMG_image.layer.borderWidth = 3
        main_IMG_image.layer.borderColor = UIColor.white.cgColor
        main_IMG_image.layer.cornerRadius = main_IMG_image.bounds.width / 3.5
    }
    
    
    
    func initTriviaView(){
        let question = quizBrain.getNextQuestion()
        
        main_BTN_choice1.setTitle(question.answers[0], for: .normal)
        main_BTN_choice2.setTitle(question.answers[1], for: .normal)
        main_BTN_choice3.setTitle(question.answers[2], for: .normal)
        main_BTN_choice4.setTitle(question.answers[3], for: .normal)
        
        let url = quizBrain.getCurrentDogUrl()
        print("---> image: \(url)")
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    self.main_IMG_image.image = UIImage(data: data)
                }
            }
        }
        
        
        
    }
    
    
    
    func initQuestions(){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("dogs").addDocument(data: [
            "Shepherd": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Shepherd.jpg",
            "Rottweiler": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Rottweiler.jpg",
            "Bulldog": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Bulldog.jpg",
            "Cocker Spaniel": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Cocker%20Spaniel.jpg",
            "Corgis": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Corgis.jpg",
            "Dackel": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Dackel.jpg",
            "Husky": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Husky.jpg",
            "Labrador": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Labrador.jpg",
            "Poodle": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Poodle.jpg",
            "Pug": "https://raw.githubusercontent.com/OksanaTka/TriviaGame/main/Images/Pug.jpg"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        
        
    }
    
    
}

extension UIImageView{
    func imageFrom(url:URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data:data){
                    DispatchQueue.main.async{
                        self?.image = image
                    }
                }
            }
        }
    }
}
