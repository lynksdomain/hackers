//
//  Level.swift
//  workingTitle
//
//  Created by C4Q on 5/7/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

class Level {
    var cutscenes: [String]
    var state: gStates
    var levelName: levels
    var hasInstructional: Bool
    var instructions: [String]?
    var instructionButtons: [String]?
    var rootFolders: [String]
    var subFolders: [String : [String]]
    var scannedResponse: [String : String]
    var unscrambleWinWords: [String]
    var sourceCode: [String]
    var clickableVariables: [String]
    var outro: [String]
    
    init(cutscenes: [String], state: gStates, hasInstructional: Bool, instructions: [String]?, instructionButtons: [String]?, rootFolders: [String], subFolders: [String : [String]], scannedResponse: [String : String], unscrambleWinWords: [String], levelName: levels, sourceCode: [String], clickableVariables: [String], outro: [String]) {
        self.cutscenes = cutscenes
        self.state = state
        self.hasInstructional = hasInstructional
        self.instructions = instructions
        self.instructionButtons = instructionButtons
        self.rootFolders = rootFolders
        self.subFolders = subFolders
        self.scannedResponse = scannedResponse
        self.unscrambleWinWords = unscrambleWinWords
        self.levelName = levelName
        self.sourceCode = sourceCode
        self.clickableVariables = clickableVariables
        self.outro = outro
    }
}




