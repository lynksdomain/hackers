//
//  scanline.swift
//  workingTitle
//
//  Created by C4Q on 4/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//
import UIKit


class Scanline {
   private var scanlineRect = CGRect.zero
   private var scanlineStartY: CGFloat = 0
   private var scanlineStopY: CGFloat = 0
   private var topBottomMargin: CGFloat = -20
   private var scanLine: UIView = UIView()
    private var scanLineTwo: UIView = UIView()
    private var scanLineThree: UIView = UIView()
    
    public func endScanline(to screen: UIView){
        screen.willRemoveSubview(scanLine)
        scanLine.layer.removeAllAnimations()
    }
    private var scanlineRect2 = CGRect.zero
    private var scanlineStartY2: CGFloat = 0
    private var scanlineStopY2: CGFloat = 0
    private var topBottomMargin2: CGFloat = -20
    
    private var scanlineRect3 = CGRect.zero
    private var scanlineStartY3: CGFloat = 0
    private var scanlineStopY3: CGFloat = 0
    private var topBottomMargin3: CGFloat = -20
    
    public func addScanline(to screen: UIView) {
        screen.addSubview(scanLine)
        scanLine.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
        scanlineRect = CGRect(x: 0, y: 0, width: screen.frame.width, height: 2)
        scanLine.layer.shadowColor = UIColor.magenta.cgColor
        scanLine.layer.shadowRadius = 10
        scanLine.layer.shadowOpacity = 1
        scanLine.layer.shadowOffset = CGSize.zero
        scanLine.layer.masksToBounds = false
        scanlineStartY = 0
        scanlineStopY = screen.frame.size.height
        scanLine.frame  = scanlineRect
        scanLine.center = CGPoint(x: scanLine.center.x, y: scanlineStartY)
        scanLine.isHidden = false
        weak var weakSelf = scanLine
        UIView.animate(withDuration: 7, delay: 0.0, options: [.repeat, .beginFromCurrentState, .curveLinear], animations: {() -> Void in
            weakSelf!.center = CGPoint(x: weakSelf!.center.x, y: self.scanlineStopY)
        }, completion: nil)
    }
    
    public func addScanlineTwo(to screen: UIView) {
        screen.addSubview(scanLineTwo)
        scanLineTwo.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
        scanlineRect2 = CGRect(x: 0, y: 0, width: screen.frame.width, height: 2)
        scanLineTwo.layer.shadowColor = UIColor.magenta.cgColor
        scanLineTwo.layer.shadowRadius = 10
        scanLineTwo.layer.shadowOpacity = 1
        scanLineTwo.layer.shadowOffset = CGSize.zero
        scanLineTwo.layer.masksToBounds = false
        scanlineStartY2 = 0
        scanlineStopY2 = screen.frame.size.height - topBottomMargin2
        scanLineTwo.frame  = scanlineRect2
        scanLineTwo.center = CGPoint(x: scanLineTwo.center.x, y: scanlineStartY2)
        scanLineTwo.isHidden = false
        weak var weakSelf = scanLineTwo
        UIView.animate(withDuration: 5, delay: 3, options: [.repeat, .beginFromCurrentState, .curveLinear], animations: {() -> Void in
            weakSelf!.center = CGPoint(x: weakSelf!.center.x, y: self.scanlineStopY2)
        }, completion: nil)
    }
    
    
    public func addScanlineThree(to screen: UIView) {
        screen.addSubview(scanLineThree)
        scanLineThree.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
        scanlineRect3 = CGRect(x: 0, y: 0, width: screen.frame.width, height: 2)
        scanLineThree.layer.shadowColor = UIColor.magenta.cgColor
        scanLineThree.layer.shadowRadius = 10
        scanLineThree.layer.shadowOpacity = 1
        scanLineThree.layer.shadowOffset = CGSize.zero
        scanLineThree.layer.masksToBounds = false
        scanlineStartY3 = 0
        scanlineStopY3 = screen.frame.size.height - topBottomMargin3
        scanLineThree.frame  = scanlineRect3
        scanLineThree.center = CGPoint(x: scanLineThree.center.x, y: scanlineStartY3)
        scanLineThree.isHidden = false
        weak var weakSelf = scanLineThree
        UIView.animate(withDuration: 8, delay: 5, options: [.repeat, .beginFromCurrentState, .curveLinear], animations: {() -> Void in
            weakSelf!.center = CGPoint(x: weakSelf!.center.x, y: self.scanlineStopY3)
        }, completion: nil)
    }
    
}
