//
//  unscrambleView.swift
//  workingTitle
//
//  Created by C4Q on 5/29/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

protocol unscrambleViewDelegate: class{
    func commandButtonPressed()
}

class unscrambleView: UIView {
    @IBOutlet weak var unscrambleTextView: UITextView!
    @IBOutlet weak var playerInputLabel: UILabel!
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var commandButton: UIButton!
    weak var delegate: unscrambleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
  
    private func commonInit() {
        Bundle.main.loadNibNamed("unscrambleView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    @IBAction func commandButtonPressed(_ sender: UIButton) {
        self.delegate?.commandButtonPressed()
    }
}
