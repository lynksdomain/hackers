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
    var hasInstructional: Bool
    var instructions: [String]?
    var instructionButtons: [String]?
    var rootFolders: [String]
    var subFolders: [String : [String]]
    
    init(cutscenes: [String], state: gStates, hasInstructional: Bool, instructions: [String], instructionButtons: [String], rootFolders: [String], subFolders: [String : [String]]) {
        self.cutscenes = cutscenes
        self.state = state
        self.hasInstructional = hasInstructional
        self.instructions = instructions
        self.instructionButtons = instructionButtons
        self.rootFolders = rootFolders
        self.subFolders = subFolders
    }
}




