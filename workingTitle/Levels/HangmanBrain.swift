//
//  HangmanBrain.swift
//  workingTitle
//
//  Created by C4Q on 6/3/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

protocol HangmanBrainDelegate: class {
    func newDisplay(stringDisplay: String)
    func failed()
    func win()
    func loadNewWord(wordToSet: String, numberOfWins: String)
}

class HangmanBrain {
    private let wordBank = ["test","code","cake","artsy","dope"]
    private var wordsChosen = [String]()
    private var numberOfWins = 0
    weak var delegate: HangmanBrainDelegate?
    private var rightLettersGuessed = Set<String>()
    
    func setHangManWord() -> String {
        var randNum = Int(arc4random_uniform(UInt32(wordBank.count)))
        var wordToSet = wordBank[randNum]
        while wordsChosen.contains(wordToSet) {
            randNum = Int(arc4random_uniform(UInt32(wordBank.count)))
            wordToSet = wordBank[randNum]
        }
        wordsChosen.append(wordToSet)
        var underscoreString = String.init(repeating: "_ ", count: wordToSet.count)
        underscoreString.removeLast()
        return underscoreString
    }
    
    func currentWordToSolve() -> String { return wordsChosen.last! }
    
    func checkLetter(letter:String){
        let currentWord = wordsChosen.last
        if (currentWord?.contains(letter))! {
            self.rightLettersGuessed.insert(letter)
            var newDisplay = ""
            for char in currentWord! {
                if char.description == letter || self.rightLettersGuessed.contains(char.description){
                    newDisplay += "\(char.description) "
                } else {
                    newDisplay += "_ "
                }
            }
            newDisplay.removeLast()
            self.delegate?.newDisplay(stringDisplay: newDisplay)
            if !newDisplay.contains("_") {
                self.rightLettersGuessed.removeAll()
                self.numberOfWins += 1
                if numberOfWins == 2 {
                    self.delegate?.win()
                }
                self.delegate?.loadNewWord(wordToSet: setHangManWord(), numberOfWins: "Number of Wins: \(self.numberOfWins)")
            
            }
        } else {
            self.delegate?.failed()
        }
    }
    
    
    
}
