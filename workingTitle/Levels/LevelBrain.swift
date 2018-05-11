//
//  LevelBrain.swift
//  workingTitle
//
//  Created by C4Q on 5/7/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

enum gStates {
    case cutscene, instruction, gameOn
}

enum buttonLabelState {
    case primary, secondaryMain, secondaryFunc, secondaryTool
}



protocol LevelBrainDelegate: class {
    func getPlayerInputString(input: String)
    func disableButtons()
    func enableButtons()
    func endOfCutscene()
    func correctTutorialPressed()
    func enableFileTouch()
    func disableFileTouch()
}


class LevelBrain {
    //Current Level Variables
    private var currentLevel: Level?
    private var currentFilesShown = [String]()
    private var currentCutsceneIndex = 0
    private var currentInstructionIndex = 0
    private var currentInstructionButtonIndex = 0
    private var onRoot = true
    private var primaryButtonConfig = true
    private var primaryButtonLabels = ["main","func","tool"]
    private var secondaryMainButtons = ["back()","nav","scan"]
    private var secondaryFuncButtons = ["rep()","hold()","dup"]
    private var secondaryToolButtons = ["key()","img()","src"]
    private lazy var levels = [tutorialLevel]
    private var currentGameState: gStates = .cutscene
    private var currentButtonState: buttonLabelState = .primary
    weak var delegate: LevelBrainDelegate?
    init(levelNumber: Int) {
        currentLevel = levels[levelNumber]
    }
    
    
    

    //Levels
    lazy var tutorialLevel = Level.init(cutscenes: ["Hello there",
                                                    "....",
                                                    "...",
                                                    "RIIIING RIIIIIING",
                                                    ".....",
                                                    "Feel awake now?",
                                                    "Hm... ",
                                                    "Maybe working your magic will help", "let me take care of this.."],
                                        state: .cutscene,
                                        hasInstructional: true,
                                        instructions:  ["Press the button labeled Main",
                                                        "Great, now press nav",
                                                        "this is to navigate forward, select the folder named topSecret",
                                                        "now run it",
                                                        "Remmeber yet? try main.back() to go back",
                                                        "dope, we are getting somewhere. Now find me the file dontOpenMe.text",
                                                        "ah, now lets do main.scan, click the folder, and run", "Still not fully remembering huh? well maybe lets try a real hack"],
                                        instructionButtons: ["main","nav","topSecret","main.nav.topSecret","main.back()","back()", "main.nav.topSecret", "main.scan.dontOpenMe.txt"],
                                        rootFolders: ["testProject", "pictures", "music", "topSecret"],
                                        subFolders: ["testProject":["hangman.exe"],
                                                     "pictures":["ds001.png","ds002.png", "VacationPictures"],
                                                     "music":["beatIt.mp3", "dna.mp3", "mansnothot.mp3"],
                                                     "topSecret":["dontOpenMe.txt", "yesterdaysCalorieIntake.txt"],
                                                     "VacationPictures":["passedOut.jpg", "partyy.jpg"]
                                                     ])
    
    
    
    
    
    func Scan(file: String, level: Level) -> String {
        return ""
    }
    
    
    func displayRootFiles() -> [String] { return (currentLevel?.rootFolders)! }
    
    func displayFiles(fileName: String) {
        
        
        
    }
    
    
    func endOfCutscene() -> Bool {
        if currentCutsceneIndex == currentLevel?.cutscenes.count {
            if currentLevel?.instructions != nil{
                currentGameState = .instruction
            } else{
                currentGameState = .gameOn
            }
            self.delegate?.endOfCutscene()
            return true
        }
        return false
    }
    
    
    func needsInstructions() -> Bool {
        if currentGameState == .instruction {
            return true
        }
        return false
    }
    
    
    func presentInstruction() -> String {
        let Instruction = currentLevel?.instructions![currentInstructionIndex]
        currentInstructionIndex += 1
        return Instruction!
    }
    
    
    func presentCutscene() -> String {
        let cutscene = currentLevel?.cutscenes[currentCutsceneIndex]
        currentCutsceneIndex += 1
        return cutscene!
    }
    
    
    func getButtonLabels() -> [String] {
        switch currentButtonState {
        case .primary:
            return primaryButtonLabels
        case .secondaryMain:
            return secondaryMainButtons
        case .secondaryFunc:
            return secondaryFuncButtons
        case .secondaryTool:
            return secondaryToolButtons
            
        }
    }
    
    func checkAction(name: String) {
        let correctAction = currentLevel?.instructionButtons![currentInstructionButtonIndex]
        if correctAction == name {
            self.delegate?.correctTutorialPressed()
            currentInstructionButtonIndex += 1
        }
    }
    
    
    
    func firstButtonPressed() {
        switch currentButtonState {
        case .primary:
            self.delegate?.getPlayerInputString(input: "main.")
            currentButtonState = .secondaryMain
        case .secondaryMain:
            self.delegate?.getPlayerInputString(input: "main.back()")
        case .secondaryFunc:
            self.delegate?.getPlayerInputString(input: "func.rep()")
            self.delegate?.disableButtons()
        case .secondaryTool:
            self.delegate?.getPlayerInputString(input: "tool.key()")
        }
    }
    
    func secondButtonPressed() {
        switch currentButtonState {
        case .primary:
            self.delegate?.getPlayerInputString(input: "func.")
            currentButtonState = .secondaryFunc
        case .secondaryMain:
            self.delegate?.getPlayerInputString(input: "main.nav.")
            self.delegate?.enableFileTouch()
            self.delegate?.disableButtons()
        case .secondaryFunc:
            self.delegate?.getPlayerInputString(input: "func.hold()")
            self.delegate?.enableFileTouch()
            self.delegate?.disableButtons()
        case .secondaryTool:
            self.delegate?.getPlayerInputString(input: "tool.img()")
            self.delegate?.disableButtons()
        }
    }
    
    func thirdButtonPressed() {
        switch currentButtonState {
        case .primary:
            self.delegate?.getPlayerInputString(input: "tool.")
            currentButtonState = .secondaryTool
        case .secondaryMain:
            self.delegate?.getPlayerInputString(input: "main.scan.")
            self.delegate?.enableFileTouch()
            self.delegate?.disableButtons()
        case .secondaryFunc:
            self.delegate?.getPlayerInputString(input: "func.dup.")
            self.delegate?.enableFileTouch()
            self.delegate?.disableButtons()
        case .secondaryTool:
            self.delegate?.getPlayerInputString(input: "tool.src.")
            self.delegate?.enableFileTouch()
            self.delegate?.disableButtons()
        }
    }
    
    func clearButtonPressed() {
        currentButtonState = .primary
        self.delegate?.getPlayerInputString(input: "_")
        self.delegate?.enableButtons()
        self.delegate?.disableFileTouch()
    }
    
    func runButtonPressed(input:String) {
        currentButtonState = .primary
        if currentGameState == .instruction { checkAction(name: input) }
        if input.contains("scan") { print("contains scan") }
        self.delegate?.enableButtons()
        self.delegate?.disableFileTouch()
        self.delegate?.getPlayerInputString(input: "_")
    }
}
