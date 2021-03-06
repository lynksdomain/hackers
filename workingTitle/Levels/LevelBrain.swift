//
//  LevelBrain.swift
//  workingTitle
//
//  Created by C4Q on 5/7/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

enum gameState {
    case unscramble, hacking, cutscene, instruction, hackingInstruction, singleOutro
}

enum levels: String {
    case zero = "zero"
    case one
}



enum gStates {
    case cutscene, instruction, gameOn
}



enum buttonLabelState {
    case primary, secondaryMain, secondaryFunc, secondaryTool
}

enum fileFunctions {
    case nav, scan, rep(), hold(), dup, key(), img(), src
}

protocol LevelBrainDelegate: class {
    func getPlayerInputString(input: String)
    func disableButtons()
    func enableButtons()
    func endOfCutscene()
    func correctTutorialPressed()
    func enableFileTouch()
    func disableFileTouch()
    func sendFiles(files: [String])
    func scanResponse(scanResponse: String)
    func gameResult(didWin: Bool, nextLevel: Int)
    
    func removeUnscrambleScreen()
    func loadGame(controlView: UIView)
    func loadCutscene(cutsceneString: String)
    func loadMainScreen(mainScreen:UIView)
    func loadWordBank(wordBank:String)
    func turnOffWordBank()
    func loadHackingGame()
    func loadSourceCode(sourceCode: String, clickableVariables: [String])
    func enableSourceCodeButton()
    func hangmanGameWon(outro: String)
}


class LevelBrain {
    
    init(levelNumber: Int) {
        self.levelNumber = levelNumber
        currentLevel = levels[levelNumber]
        self.unscrambleV.tag = 0
        self.unscrambleV.delegate = self
    }
    
    //Current Level Variables
    public var currentSourceCode: NSMutableAttributedString?
    public var loadedSourceData = false
    private var currentLevel: Level?
    private var levelZeroDeveloperMode: Bool?
    private var levelNumber: Int
    private lazy var levels = [tutorialLevel,levelOne]
    var unscrambleV = unscrambleView()
    private var currentUnscrambleWinWordIndex = 0
    let uihelper = UIHelper()
    private var currentGameState: gameState = .cutscene
    weak var delegate: LevelBrainDelegate?
    private var currentCutsceneIndex = 0
    private var mainScreenOn = false
    private var unscrambleGameOn = false
    private var currentFilesShown = [String]()
    private var currentInstructionIndex = 0
    private var currentInstructionButtonIndex = 0
    private var onRoot = true
    private var primaryButtonConfig = true
    var unscrambleTap = UITapGestureRecognizer()
    private var fileOrder = [[String]]()
    private var hackViewToLoad: UIView?
    private var hangmanLoaded = false
    private var hangmanSourceLoaded = false
    private var levelZeroSourceCode = """
developerMode = false
hangman_border_color = .magenta
hangman_difficulty = .hard
"""
    

    //Levels
    lazy var tutorialLevel = Level.init(cutscenes: ["Hello there it has been a long time",
                                                    "....",
                                                    "RIIIING RIIIIIING",
                                                    ".....",
                                                    "Do you feel awake now?",
                                                    "Do you remember who you are?",
                                                    "I guess you have been asleep for longer than expected", "lets see if hacking into this terminal will help you remember"],
                                        state: .cutscene,
                                        hasInstructional: true,
                                        instructions:  ["Find and tap the word in the scrambled puzzle below",
                                                        "Great now press the arrow to gain access",
                                                        "Now you have access to the root files and the main lock. Tap on the lock to see the challenge",
                                                        "Pretty impossible right? Click on the source code file and in the next window see what you can change",
                                                        "now we can test your changes to the lock",
                                                        "dope, we are getting somewhere. Now find me the file dontOpenMe.text",
                                                        "ah, now lets do main.scan, click the file, and run", "presto, you did it!"],
                                        instructionButtons: ["main","nav","music","main.nav.music","main.back()", "main.nav.topSecret", "main.scan.dontOpenMe.txt"],
                                        rootFolders: ["testProject", "pictures", "music", "topSecret"],
                                        subFolders: ["testProject":["hangman.exe"],
                                                     "pictures":["ds001.png","ds002.png", "VacationPictures"],
                                                     "music":["beatIt.mp3", "dna.mp3", "mansnothot.mp3", "Dad Rock"],
                                                     "topSecret":["dontOpenMe.txt", "yesterdaysCalorieIntake.txt"],
                                                     "VacationPictures":["passedOut.jpg", "partyy.jpg"],
                                                     "Dad Rock":["crazyTrain.mp3", "test"],
                                                     "test":["no.txt"]],
                                        scannedResponse: ["ds001.png":"no",
                                                          "ds002.png":"easter egg?",
                                                          "ds003.png":"spicy",
                                                          "default":"nothing of value here..."],
                                        unscrambleWinWords: ["there","is", "no","spoon"],
                                        levelName: .zero, sourceCode: [self.levelZeroSourceCode], clickableVariables: ["developerMode"], outro: ["Well your skills are still there. Next time, you'll be alone .... and timed"])
    
   lazy var levelOne = Level.init(cutscenes: ["welcome to level one"],
                                   state: .cutscene,
                                   hasInstructional: false,
                                   instructions: nil,
                                   instructionButtons: nil,
                                   rootFolders: ["testing"],
                                   subFolders: [:],
                                   scannedResponse: [:],
                                   unscrambleWinWords: [],
                                   levelName: .one, sourceCode: ["developerMode"], clickableVariables: [], outro: [])
    
    
    
    public func loadCutscene() {
        if currentCutsceneIndex < (currentLevel?.cutscenes.count)! {
            let cutsceneString = currentLevel?.cutscenes[currentCutsceneIndex]
            currentCutsceneIndex += 1
            self.delegate?.loadCutscene(cutsceneString: cutsceneString!)
        }
        if currentCutsceneIndex == (currentLevel?.cutscenes.count)! - 1{
            let cutsceneString = currentLevel?.cutscenes[currentCutsceneIndex]
            if currentLevel?.instructions != nil {
                self.currentGameState = .instruction
            } else {
                self.currentGameState = .unscramble
            }
            self.delegate?.loadCutscene(cutsceneString: cutsceneString!)
        }
    }
    
    public func loadLevelZeroSourceCode(developerMode: Bool) {
        if developerMode {
            self.levelZeroDeveloperMode = true
            
        } else {
            self.levelZeroDeveloperMode = false
        }
    }
    
    public func loadMainScreen() {
        switch currentLevel?.levelName {
        case .zero?:
            self.hackViewToLoad = levelZeroHackView()
            let vcDelegate = self.hackViewToLoad as! levelZeroHackView
            vcDelegate.delegate = self
            self.hackViewToLoad?.tag = 1
            let vc = mainTerminalHackView()
            vc.usernameView.layer.borderColor = UIColor.magenta.cgColor
            vc.usernameView.layer.borderWidth = 1
            vc.passwordView.layer.borderColor = UIColor.magenta.cgColor
            vc.passwordView.layer.borderWidth = 1
            self.delegate?.loadMainScreen(mainScreen: vc)
            loadInstructions()
        default:
            print("bloop")
        }
        
        
    }
    
    public func checkIfMainScreenOn () -> Bool { return mainScreenOn }
    public func checkCurrentGameState() -> gameState { return currentGameState }
    public func mainScreenNowOn() { self.mainScreenOn = true }
    public func checkIfunscrambleGameOn() -> Bool { return self.unscrambleGameOn }
    public func unscrambleGameNowOn() { self.unscrambleGameOn = true }
    public func levelName() -> levels { return (currentLevel?.levelName)! }

    public func hangmanGameWon() {
        self.currentGameState = .singleOutro
        self.delegate?.hangmanGameWon(outro: (self.currentLevel?.outro[0])!)
    }
    
    public func levelZeroDeveloperModeIsOn() -> Bool {
        guard let status = levelZeroDeveloperMode else { return false }
        return status
    }
    
    private func loadInstructions() {
        if currentInstructionIndex < (currentLevel?.instructions!.count)! {
        let instruction = currentLevel?.instructions![currentInstructionIndex]
        self.currentInstructionIndex += 1
            self.delegate?.loadCutscene(cutsceneString: instruction!)
        }
    }
    
    
    private func loadView() -> UIView {
        switch currentGameState {
        case .unscramble:
            return unscrambleV
        default:
            return UIView()
        }
    }
    
    
    func loadUnscrambleGame() {
        switch currentGameState {
        case .instruction:
            setUnscrambleView()
            self.delegate?.loadGame(controlView: self.unscrambleV)
            self.delegate?.loadWordBank(wordBank: (self.currentLevel?.unscrambleWinWords[currentUnscrambleWinWordIndex])!)
        case .hackingInstruction:
            self.delegate?.loadGame(controlView: hackViewToLoad!)
        default:
            print("loadunscramblegame default")
        }
        
    }
    
    
    
    
    var winRange = NSRange()
    
    func setUnscrambleView() {
        let winningWord = currentLevel?.unscrambleWinWords[currentUnscrambleWinWordIndex]
        let attributedBlock = NSMutableAttributedString(string: self.UnscrambleString(winningWord: winningWord!, blockLength: 100))
        self.winRange = attributedBlock.mutableString.range(of: winningWord!)
        self.unscrambleV.unscrambleTextView.attributedText = attributedBlock
        self.unscrambleV.unscrambleTextView.textColor = UIColor.magenta
        self.unscrambleV.unscrambleTextView.font = UIFont(name: "CourierNewPS-BoldMT", size: 18)
        self.unscrambleTap = UITapGestureRecognizer(target: self, action: #selector(unscrambleTextViewTapped(_:)))
        self.unscrambleV.unscrambleTextView.addGestureRecognizer(unscrambleTap)
    }
    
    
    @objc func unscrambleTextViewTapped(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if self.winRange.contains(characterIndex) {
            winningWordPressed()
        }
    }
    

    
    
    
    private func winningWordPressed() {
        if currentUnscrambleWinWordIndex == (currentLevel?.unscrambleWinWords.count)! - 1 {
            let winningWord = currentLevel?.unscrambleWinWords[currentUnscrambleWinWordIndex]
            self.unscrambleV.playerInputLabel.text = self.unscrambleV.playerInputLabel.text! + "\(winningWord!)"
            self.delegate?.turnOffWordBank()
            if currentGameState == .instruction {
                let instruction = currentLevel?.instructions![currentInstructionIndex]
                currentInstructionIndex += 1
                self.delegate?.loadCutscene(cutsceneString: instruction!)
            }
            self.unscrambleV.commandButton.isHidden = false
            self.currentUnscrambleWinWordIndex += 1
            self.unscrambleV.unscrambleTextView.text = ""
            return
        } else if currentUnscrambleWinWordIndex < (currentLevel?.unscrambleWinWords.count)! {
            let winningWord = currentLevel?.unscrambleWinWords[currentUnscrambleWinWordIndex]
            self.unscrambleV.playerInputLabel.text = self.unscrambleV.playerInputLabel.text! + "\(winningWord!)."
            self.currentUnscrambleWinWordIndex += 1
            loadUnscrambleGame()
        } else {
            print("winning")
        }
    }
    
    
    
    private func UnscrambleString(winningWord: String, blockLength: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*(){}[];':><?"
        let maxLength = UInt32(characters.count - 1)
        let winningWordIndex = arc4random_uniform(UInt32(blockLength))
        var stringBlock = ""
        for i in 0...blockLength {
            let randNum = arc4random_uniform(maxLength)
            if i == winningWordIndex {
                stringBlock += winningWord
            } else {
                let newChar = characters[characters.index(characters.startIndex, offsetBy: Int(randNum))]
                stringBlock += newChar.description
            }
        }
        return stringBlock
    }
    
    func hangmanDismissed() {
        if !hangmanLoaded {
            hangmanLoaded = true
            self.delegate?.enableSourceCodeButton()
            loadInstructions()
        }
    }
    
    func hangmanSourceCodeDismissed() {
        if !hangmanSourceLoaded {
            hangmanSourceLoaded = true
            loadInstructions()
        }
    }
    
    
    
    func createWordBank(words: [String]) -> String {
        var wordBank = ""
        for word in words {
            wordBank += "\(word),"
        }
        wordBank.removeLast()
        return wordBank
    }
}


extension LevelBrain: unscrambleViewDelegate {
    func commandButtonPressed() {
        if currentGameState == .instruction {
            let instruction = currentLevel?.instructions![currentInstructionIndex]
            currentInstructionIndex += 1
            self.currentGameState = .hackingInstruction
            self.delegate?.loadCutscene(cutsceneString: instruction!)
            self.delegate?.removeUnscrambleScreen()
        }
    }
}

extension LevelBrain: levelZeroHackViewDelegate {
    func lockFolderPressed() {
        self.delegate?.loadHackingGame()
    }
    func sourceFolderPressed(sourceCodeTag: Int) {
        let sourceCode = self.currentLevel?.sourceCode[sourceCodeTag]
        let clickableVariables = self.currentLevel?.clickableVariables
        self.delegate?.loadSourceCode(sourceCode: sourceCode!, clickableVariables: clickableVariables! )
    }
}


