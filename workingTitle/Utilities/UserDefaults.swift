//
//  UserDefaults.swift
//  workingTitle
//
//  Created by C4Q on 5/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation


class UserDefaultHelper {
    private let defaults = UserDefaults.standard
    
    
    func savelevel(level: Int) {
        defaults.set(level, forKey: "levelNumber")
    }
    
    func levelsUnlocked() -> Int {
        return defaults.integer(forKey: "levelNumber")
    }
}
