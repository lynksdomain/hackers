//
//  SourceCodeViewController.swift
//  workingTitle
//
//  Created by C4Q on 6/4/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class SourceCodeViewController: UIViewController {
    @IBOutlet weak var sourceCodeTextView: CustomHackingUITextView!
   
    
    @IBOutlet weak var keyboardView: UIView!
    
    
    var sourceCode: String?
    var clickableVariables: [String]?
    var winRanges = [NSRange]()
    var variableIndex = 0
    var levelZeroKeyboard: LevelZeroKeyboard?
    var mainVC: HackViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainVC = self.presentingViewController as? HackViewController
        loadKeyboard()
        loadSourceCode()
    }

    private func loadKeyboard() {
        switch mainVC!.levelBrain!.levelName() {
        case .zero:
            self.levelZeroKeyboard = LevelZeroKeyboard()
            self.keyboardView.addSubview(self.levelZeroKeyboard!)
            self.levelZeroKeyboard?.translatesAutoresizingMaskIntoConstraints = false
            levelZeroKeyboard?.topAnchor.constraint(equalTo: keyboardView.topAnchor).isActive = true
            levelZeroKeyboard?.bottomAnchor.constraint(equalTo: keyboardView.bottomAnchor).isActive = true
            levelZeroKeyboard?.leadingAnchor.constraint(equalTo: keyboardView.leadingAnchor).isActive = true
            levelZeroKeyboard?.trailingAnchor.constraint(equalTo: keyboardView.trailingAnchor).isActive = true
        default:
            print("source keyboard fail")
        }
    }
    
    private func loadSourceCode() {
        let attributedBlock = NSMutableAttributedString(string: self.sourceCode!)
        for variable in clickableVariables! {
            winRanges.append(attributedBlock.mutableString.range(of: variable))
        }
        attributedBlock.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "CourierNewPS-BoldMT", size: 18) ?? UIFont.systemFont(ofSize: 18), range: NSRange.init(location: 0, length: attributedBlock.string.count))
       attributedBlock.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.magenta, range: NSRange.init(location: 0, length: attributedBlock.string.count))
        for range in winRanges {
            attributedBlock.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.cyan , range: range)
        }
        self.sourceCodeTextView.attributedText = attributedBlock
        let textViewTap = UITapGestureRecognizer(target: self, action: #selector(TextViewTapped(_:)))
        self.sourceCodeTextView.addGestureRecognizer(textViewTap)
    }
    
    
    @objc func TextViewTapped(_ sender: UITapGestureRecognizer) {
        if !self.keyboardView.isHidden {
            self.keyboardView.isHidden = true
        }
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for ranges in winRanges {
            if ranges.contains(characterIndex) {
                clickableVariablePressed(variablePressed: clickableVariables![self.variableIndex])
            }
        }
    }
    
    func clickableVariablePressed(variablePressed: String) {
        self.keyboardView.isHidden = false
    }

}
