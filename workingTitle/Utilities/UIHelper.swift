//
//  UIHelper.swift
//  workingTitle
//
//  Created by C4Q on 5/30/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

enum glowIntensity {
    case low, high
}

class UIHelper {
    public func addGlow(object: UIView){
        object.layer.shadowColor = UIColor.magenta.cgColor
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.masksToBounds = false
    }
    
}

extension UIView {
    
    func addBorder() {
        self.layer.borderColor = UIColor.magenta.cgColor
        self.layer.borderWidth = 1
    }
    
    
        func makeDashedBorder() {
        let mViewBorder = CAShapeLayer()
        mViewBorder.strokeColor = UIColor.magenta.cgColor
        mViewBorder.lineDashPattern = [2, 2]
        mViewBorder.frame = self.bounds
        mViewBorder.fillColor = nil
        mViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(mViewBorder)
    }
    func glow(glowIntensity: glowIntensity) {
        self.layer.shadowColor = UIColor.magenta.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        switch glowIntensity {
        case .low:
            self.layer.shadowRadius = 1
        case .high:
            self.layer.shadowRadius = 10
        }
    }
        func Blink(){
            self.alpha = 0.3
            UIView.animate(withDuration: 2, delay: 0, options:[.repeat,.autoreverse],
                           animations:{ self.alpha=1.0}, completion: nil)
        }
    
}
