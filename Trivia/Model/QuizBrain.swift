//
//  QuizBrain.swift
//  Trivia
//
//  Created by user216397 on 5/13/22.
//

import Foundation

struct QuizBrian {
    
    var dogList:[Dog]=[]
    var currentDog: Dog? = nil
    var data: [String:Any] = [:]
    var dogNameList : [String] = []
    var question = Question()
    var nextQuestionIndex = 0
    

    
    
    //random numbers
    func getRandomNumber(maxNumber:Int) -> Int{
        let rand = Int.random(in: 0 ..< maxNumber)
        return rand
    }
    
    mutating func setDogsData(firebaseData : [String:Any]){
        self.data = firebaseData
        initDogList()
    }
    
    mutating func initDogList(){
        for (name, path) in data {
            // print("The path to '\(name)' is '\(path)'.")
            let url = URL(string:path as! String)!
            let dog = Dog(name,url)
            dogList.append(dog)
            dogNameList.append(name)
        }
        // print("dogsImages[0].url \(dogsImages[0].url)")
    }
    
    mutating func setNextQuestion(){
        currentDog = dogList[nextQuestionIndex]
        question.rightAnswer = currentDog!.name
        print("---> right answer: \(question.rightAnswer)")
        question.answers.append(question.rightAnswer)
        
        for _ in 1...3{
            var rand = getRandomNumber(maxNumber: dogList.count)
            while (rand == nextQuestionIndex || question.answers.contains(where: { $0 == dogList[rand].name})){
                rand = getRandomNumber(maxNumber: dogList.count)
            }
            
            print("---> add answer: \(dogList[rand].name)")
            question.answers.append(dogList[rand].name)
        }
        question.answers.shuffle()
        nextQuestionIndex+=1
    }
    
    func getCurrentDogUrl() -> URL{
        return currentDog!.url
    }
    
   mutating func getNextQuestion() -> Question{
       question.answers = []
        setNextQuestion()
        return question
    }
    
    
    
    
}
