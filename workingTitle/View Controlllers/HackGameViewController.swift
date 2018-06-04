//
//  HackGameViewController.swift
//  workingTitle
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class HackGameViewController: UIViewController {

    var levelName: levels?
    var hangmanBrain: HangmanBrain?
    var hangmanGame: hangManView?

    
  
    @IBOutlet weak var externalGameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let dismissTap = UITapGestureRecognizer.init(target: self, action: #selector(tappedOutside))
        self.view.addGestureRecognizer(dismissTap)
        let keyboardTap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardTapPressed))
        self.gameView.addGestureRecognizer(keyboardTap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var gameView: UIView!
    
    @objc func keyboardTapPressed() {
        let keyboardView = self.gameView.subviews[0] as? hangManView
        keyboardView?.playerTextField.resignFirstResponder()
    }
    
    @objc func tappedOutside(){
        self.dismiss(animated: true) {
        }
    }
    
    
    
    func loadGame() {
        switch self.levelName! {
        case .zero:
            self.hangmanGame = hangManView()
            self.hangmanBrain = HangmanBrain()
            self.gameView.addSubview(hangmanGame!)
            hangmanBrain?.delegate = self
            hangmanGame?.playerTextField.delegate = self
            hangmanGame?.playerTextField.layer.cornerRadius = 8
            hangmanGame!.clipsToBounds = true
            hangmanGame?.translatesAutoresizingMaskIntoConstraints = false
            hangmanGame?.topAnchor.constraint(equalTo: gameView.topAnchor).isActive = true
            hangmanGame?.bottomAnchor.constraint(equalTo: gameView.bottomAnchor).isActive = true
            hangmanGame?.leadingAnchor.constraint(equalTo: gameView.leadingAnchor).isActive = true
            hangmanGame?.trailingAnchor.constraint(equalTo: gameView.trailingAnchor).isActive = true
            hangmanGame?.imageView.glow(glowIntensity: .high)
            hangmanGame?.instructionLabel.glow(glowIntensity: .high)
            hangmanGame?.playerTextField.glow(glowIntensity: .high)
            hangmanGame?.playerTextField.addBorder()
            hangmanGame?.playerTextField.backgroundColor = .black
            hangmanGame?.wordToSolveLabel.glow(glowIntensity: .high)
            hangmanGame?.wordToSolveLabel.text = self.hangmanBrain?.setHangManWord()
            
        default:
            print("v")
        }
        
    }
    
}

extension HackGameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == hangmanGame?.playerTextField  && string.count > 0 {
            let LettersOnly = NSCharacterSet.letters
            let strValid = LettersOnly.contains(UnicodeScalar.init(string)!)
            return strValid && textString.count <= 1
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hangmanGame?.playerTextField {
            self.hangmanBrain?.checkLetter(letter: textField.text!)
            textField.text = ""
            textField.resignFirstResponder()
        }
        return true
    }
}


extension HackGameViewController: HangmanBrainDelegate {
    func newDisplay(stringDisplay: String) {
        self.hangmanGame?.wordToSolveLabel.text = stringDisplay
    }
}

