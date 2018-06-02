//
//  HackViewController.swift
//  workingTitle
//
//  Created by C4Q on 4/17/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import GhostTypewriter

class HackViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    // VARIABLES
    var levelBrain: LevelBrain?
    let userDefaults = UserDefaultHelper()
    var levelNumber: Int!
    let scanline = Scanline()
    let uihelper = UIHelper()
    
 
   
    
    //STORYBOARD ELEMENTS
    
    @IBOutlet weak var wordBankLabel: UILabel!
    @IBOutlet weak var mainExternalTerminal: UIView!
    @IBOutlet weak var subTerminalView: UITableView!
    @IBOutlet weak var mainInternalTerminal: UIImageView!
    @IBOutlet weak var aiInternalTerminal: UIView!
    @IBOutlet weak var aiExternalTerminal: UIView!
    @IBOutlet weak var controlExternalTerminal: UIView!
    @IBOutlet weak var controlInternalTerminal: UIView!

    
    //LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.manager.playMusic()
        self.levelBrain = LevelBrain.init(levelNumber: levelNumber)
        self.levelBrain?.delegate = self
        self.levelBrain?.unscrambleTap.delegate = self
        self.subTerminalView.dataSource = self
        self.subTerminalView.allowsSelection = false
        aiExternalTerminal.clipsToBounds = true
        aiExternalTerminal.layer.cornerRadius = 10
        aiExternalTerminal.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func viewDidLayoutSubviews() {
        self.levelBrain?.unscrambleV.unscrambleTextView.setContentOffset(CGPoint.zero, animated: false)
        self.levelBrain?.unscrambleV.unscrambleTextView.layer.borderColor = UIColor.magenta.cgColor
        self.levelBrain?.unscrambleV.unscrambleTextView.layer.borderWidth = 1.0
        self.levelBrain?.unscrambleV.playerInputLabel.layer.borderColor = UIColor.magenta.cgColor
        self.levelBrain?.unscrambleV.playerInputLabel.layer.borderWidth = 1.0
        self.levelBrain?.unscrambleV.unscrambleTextView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subTerminalView.rowHeight = UITableViewAutomaticDimension
        subTerminalView.estimatedRowHeight = 40
        let internalTerminals = [mainInternalTerminal,aiInternalTerminal,controlInternalTerminal]
        internalTerminals.forEach(){setInternalTerminal(terminal: $0!)}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            self.levelBrain?.loadCutscene()
        }
    }
    
    
    // BUTTON ACTIONS

    @IBAction func nextCutscene(_ sender: UIButton) {
        sender.isHidden = true
        self.levelBrain?.loadCutscene()
        repositionAIText()
    }
    
   
    
    // UI Functions
    
    func showResult(didWin: Bool, nextLevel: Int) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameResult") as? GameResultViewController
        vc?.modalPresentationStyle = .overCurrentContext
        if didWin {
            userDefaults.savelevel(level: nextLevel)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func repositionAIText(){
        self.subTerminalView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.subTerminalView.setNeedsLayout()
    }

    
    func roundCorners(to view: UIView){
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func setInternalTerminal(terminal: UIView) {
        terminal.layoutIfNeeded()
        terminal.addShadow(to: [.top,.left,.right,.bottom], radius: 10.0)
    }

    
  
    // AI functions
    
    func makeBotTalk(speech: String) {
        subTerminalView.beginUpdates()
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.subTerminalView.cellForRow(at: indexPath) as? subTerminalTableViewCell
        let editedString = speech.replacingOccurrences(of: " ", with: "/")
        cell?.subTerminalText.text = "@://\(editedString)/"
        cell?.subTerminalText.typingTimeInterval = TimeInterval.init(0.04)
        cell?.subTerminalText.startTypewritingAnimation(completion: {
            self.botEndedSpeech(cell: cell!)
        })
        subTerminalView.endUpdates()
    }
    
    func botEndedSpeech(cell: subTerminalTableViewCell) {
        if self.levelBrain?.checkCurrentGameState() == .cutscene {
            cell.nextCutsceneButton.isHidden = false
        } else if self.levelBrain?.checkCurrentGameState() == .instruction {
            if !(self.levelBrain?.checkIfMainScreenOn())! {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.levelBrain?.loadMainScreen()
                    self.levelBrain?.mainScreenNowOn()
                }
            }else if !(self.levelBrain?.checkIfunscrambleGameOn())!{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.levelBrain?.loadUnscrambleGame()
                    self.levelBrain?.unscrambleGameNowOn()
                }
            }
        } else if self.levelBrain?.checkCurrentGameState() == .hackingInstruction {
            self.levelBrain?.loadUnscrambleGame()
        }
    }
    
    
}




extension HackViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = subTerminalView.dequeueReusableCell(withIdentifier: "subTerminalCell", for: indexPath) as? subTerminalTableViewCell
            addGlow(object: (cell?.subTerminalText!)!)
            addGlow(object: (cell?.nextCutsceneButton!)!)
            return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
}



extension HackViewController {
    func addGlow(object: UIView){
        object.layer.shadowColor = UIColor.magenta.cgColor
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.masksToBounds = false
        
    }
}


extension HackViewController: LevelBrainDelegate {
    func loadWordBank(wordBank: String) {
        self.wordBankLabel.addBorder()
        self.wordBankLabel.glow(glowIntensity: .high)
        self.wordBankLabel.text = wordBank
    }
    
    func loadMainScreen(mainScreen: UIView) {
        self.mainInternalTerminal.alpha = 1
        self.mainInternalTerminal.glow(glowIntensity: .low)
        self.mainInternalTerminal.backgroundColor = UIColor.clear
        self.scanline.addScanline(to: mainInternalTerminal)
        self.mainInternalTerminal.addSubview(mainScreen)
        mainScreen.translatesAutoresizingMaskIntoConstraints = false
        mainScreen.topAnchor.constraint(equalTo: mainInternalTerminal.topAnchor).isActive = true
        mainScreen.bottomAnchor.constraint(equalTo: mainInternalTerminal.bottomAnchor).isActive = true
        mainScreen.leadingAnchor.constraint(equalTo: mainInternalTerminal.leadingAnchor).isActive = true
        mainScreen.trailingAnchor.constraint(equalTo: mainInternalTerminal.trailingAnchor).isActive = true
    }
    
    func loadCutscene(cutsceneString: String) { self.makeBotTalk(speech: cutsceneString) }
    func removeUnscrambleScreen() { self.controlInternalTerminal.subviews.first?.removeFromSuperview() }
    func loadGame(controlView: UIView) {
        self.controlInternalTerminal.subviews.first?.removeFromSuperview()
        self.controlInternalTerminal.addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.topAnchor.constraint(equalTo: controlInternalTerminal.topAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: controlInternalTerminal.bottomAnchor).isActive = true
        controlView.leadingAnchor.constraint(equalTo: controlInternalTerminal.leadingAnchor).isActive = true
        controlView.trailingAnchor.constraint(equalTo: controlInternalTerminal.trailingAnchor).isActive = true
        if controlView.tag == 0 {
            let vc = controlView as? unscrambleView
            self.uihelper.addGlow(object: (vc?.playerInputLabel!)!)
            self.uihelper.addGlow(object: (vc?.unscrambleTextView)!)
        }
    }
    
    func gameResult(didWin: Bool, nextLevel: Int) {
        showResult(didWin: didWin, nextLevel: nextLevel)
    }
    
    func scanResponse(scanResponse: String) {
        repositionAIText()
    }
    
    func sendFiles(files: [String]) {
    }
    
    func enableFileTouch() {
    }
    
    func disableFileTouch() {
    }
    
    func correctTutorialPressed() {
        repositionAIText()
    }
    
    func enableButtons() {
    }
    
    func endOfCutscene() {
        
    }
    
    func disableButtons() {
    }
    
    func getPlayerInputString(input: String) {
    }
}



