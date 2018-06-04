//
//  LevelZeroKeyboard.swift
//  workingTitle
//
//  Created by C4Q on 6/4/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

protocol LevelZeroKeyboardDelegate: class{
    func truePressed()
    func falsePressed()
}


class LevelZeroKeyboard: UIView {
    @IBOutlet var contentView: UIView!
    weak var delegate: LevelZeroKeyboardDelegate?
    
    @IBAction func truePressed(_ sender: CustomHackingUIButton) {
        self.delegate?.truePressed()
    }
    
    @IBAction func falsePressed(_ sender: CustomHackingUIButton) {
        self.delegate?.falsePressed()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LevelZeroKeyboard", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
}
