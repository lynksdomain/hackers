//
//  mainTerminalHackView.swift
//  workingTitle
//
//  Created by C4Q on 5/31/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit


class mainTerminalHackView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var usernameView: UIView!
    @IBOutlet var passwordView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("mainTerminalHackView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
    }
}
