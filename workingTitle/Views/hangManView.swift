//
//  hangManView.swift
//  workingTitle
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit


class hangManView: UIView {
override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
}

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var wordToSolveLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var playerTextField: UITextField!
    
    @IBOutlet weak var numberOfWinsLabel: CustomHackingUILabel!
    @IBOutlet weak var guessLeftLabel: CustomHackingUILabel!
    @IBOutlet weak var wordSolutionLabel: CustomHackingUILabel!
    
    @IBOutlet weak var developerModeLabel: CustomHackingUILabel!
    
    @IBOutlet var contentView: UIView!
    private func commonInit() {
    Bundle.main.loadNibNamed("hangManView", owner: self, options: nil)
    guard let content = contentView else { return }
    content.frame = self.bounds
    content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.addSubview(content)
}
}
