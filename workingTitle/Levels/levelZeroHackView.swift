//
//  levelZeroHackView.swift
//  workingTitle
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

protocol levelZeroHackViewDelegate: class{
    func lockFolderPressed()
}

class levelZeroHackView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var rootButton: UIButton!
    
    @IBOutlet weak var rootLabel: UILabel!
    
    @IBOutlet weak var sourceFolder: UIButton!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    weak var delegate: levelZeroHackViewDelegate?
    
    @IBAction func lockFolderPressed(_ sender: UIButton) {
        self.delegate?.lockFolderPressed()
    }
    
    @IBAction func sourceFolderPressed(_ sender: UIButton) {
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
        Bundle.main.loadNibNamed("levelZeroHackView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    
}
