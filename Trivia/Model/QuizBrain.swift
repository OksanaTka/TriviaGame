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
    
    //set dictionary
    mutating func setDogsData(firebaseData : [String:Any]){
        self.data = firebaseData
        initDogList()
    }
    
    //init dogs list and dogs name list
    mutating func initDogList(){
        for (name, path) in data {
            let url = URL(string:path as! String)!
            let dog = Dog(name,url)
            dogList.append(dog)
            dogNameList.append(name)
        }
    }
    
    //set next question
    mutating func setNextQuestion(){
        //get next dog and init right answer
        currentDog = dogList[nextQuestionIndex]
        question.rightAnswer = currentDog!.name
        question.answers.append(question.rightAnswer)
        
        //add more 3 answers
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
    
    // check player life and question number
    func playGame() ->Bool{
        let gameNumber = nextQuestionIndex
        return gameNumber < dogList.count && player.life > 0
    }
    
    func getGameOver() -> Bool{
        return gameOver
    }
    
    // return progress percentage
    func getGameProgress() -> Float{
        let gameNumber = nextQuestionIndex
        return Float(gameNumber) / Float(dogList.count)
    }
    
    //clear answers array and set next question
    mutating func getNextQuestion() -> Question{
        question.answers = []
        setNextQuestion()
        return question
    }
    
    
    
    
}
