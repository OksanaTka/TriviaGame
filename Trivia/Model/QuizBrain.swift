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
    var player = Player()
    let max_life = 3
    var gameOver =  false
    
    
    init() {
        player.life = max_life
    }
    
    
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
        question.answers.append(question.rightAnswer)
        
        for _ in 1...3{
            var rand = getRandomNumber(maxNumber: dogList.count)
            while (rand == nextQuestionIndex || question.answers.contains(where: { $0 == dogList[rand].name})){
                rand = getRandomNumber(maxNumber: dogList.count)
            }
            
            question.answers.append(dogList[rand].name)
        }
        question.answers.shuffle()
        nextQuestionIndex+=1
    }
    mutating func calcScore(){
        player.score += 1
    }
    
    func getPlayerLife() -> Int{
        return player.life
    }
    
    mutating func calcLife() {
        player.life -= 1
        if(player.life == 0){
            gameOver = true
        }
    }
    
    
    func getCurrentDogUrl() -> URL{
        return currentDog!.url
    }
    
    func getPlayerScore() -> Int{
        return player.score
    }
    
    func getTotalGamesNumber() -> Int{
        return dogList.count
        
    }
    func getCurrentGameNumber() -> Int{
        let gameNumber = nextQuestionIndex+1
        return gameNumber
    }
    
    func playGame() ->Bool{
        let gameNumber = nextQuestionIndex
        print("\(gameNumber) < \(dogList.count)")
        return gameNumber < dogList.count && player.life > 0
    }
    
    func getGameOver() -> Bool{
        return gameOver
    }
    
    func getGameProgress() -> Float{
        let gameNumber = nextQuestionIndex
        return Float(gameNumber) / Float(dogList.count)
    }
    
    mutating func getNextQuestion() -> Question{
        question.answers = []
        setNextQuestion()
        return question
    }
    
    
    
    
}
