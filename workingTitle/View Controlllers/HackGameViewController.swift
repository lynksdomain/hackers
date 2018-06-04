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
    var mainViewController: HackViewController?

    
  
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
            self.mainViewController?.levelBrain?.hangmanDismissed()
        }
    }
    
   
    
    
    func loadGame() {
        self.mainViewController = self.presentingViewController as? HackViewController
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
            if (self.mainViewController?.levelBrain?.levelZeroDeveloperModeIsOn())! {
                hangmanGame?.developerModeLabel.isHidden = false
                hangmanGame?.wordSolutionLabel.isHidden = false
                hangmanGame?.wordSolutionLabel.text = "Word to Solve: \(self.hangmanBrain!.currentWordToSolve())"
            }
            
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
    func loadNewWord(wordToSet: String, numberOfWins: String) {
        hangmanGame?.wordSolutionLabel.text = "Word to Solve: \(self.hangmanBrain!.currentWordToSolve())"
        hangmanGame?.wordToSolveLabel.text = wordToSet
        hangmanGame?.numberOfWinsLabel.text = numberOfWins
    }
    
    func win() {
        self.hangmanGame?.playerTextField.isEnabled = false
        MusicHelper.manager.playAccess()
        self.hangmanGame?.failedLabel.text = "UNLOCKED"
        self.hangmanGame?.failedLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true) {
                self.mainViewController?.levelBrain?.hangmanDismissed()
                self.mainViewController?.levelBrain?.hangmanGameWon()
            }
        }
    }
    
    
    func failed() {
        self.hangmanGame?.playerTextField.isEnabled = false
        self.hangmanGame?.imageView.image = #imageLiteral(resourceName: "hangmanLose")
        MusicHelper.manager.playError()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.hangmanGame?.guessLeftLabel.text = "Guesses Left: 0"
        self.hangmanGame?.failedLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            self.dismiss(animated: true) {
                self.mainViewController?.levelBrain?.hangmanDismissed()
            }
        }
    }
    
    func newDisplay(stringDisplay: String) {
        self.hangmanGame?.wordToSolveLabel.text = stringDisplay
        hangmanGame?.wordSolutionLabel.text = "Word to Solve: \(self.hangmanBrain!.currentWordToSolve())"
    }
}

