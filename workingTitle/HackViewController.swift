//
//  HackViewController.swift
//  workingTitle
//
//  Created by C4Q on 4/17/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import GhostTypewriter

class HackViewController: UIViewController {
    
    // VARIABLES
    
    var levelBrain: LevelBrain?
    var levelNumber: Int!
    let scanline = Scanline()
    var buttons = [UIButton]()
    var terminals = [UIView]()
    var terminalInputs = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    let intro = "Hello there"
    let errorMSG = "error_"
    
    //STORYBOARD ELEMENTS
    
    @IBOutlet weak var mainExternalTerminal: UIView!
    @IBOutlet weak var subTerminalView: UITableView!
    @IBOutlet weak var mainInternalTerminal: UIImageView!
    @IBOutlet weak var aiInternalTerminal: UIView!
    @IBOutlet weak var aiExternalTerminal: UIView!
    @IBOutlet weak var controlExternalTerminal: UIView!
    @IBOutlet weak var controlInternalTerminal: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerInput: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButtons: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    //LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.manager.stopMusic()
        self.levelBrain = LevelBrain.init(levelNumber: levelNumber)
        self.levelBrain?.delegate = self
        self.tableView.separatorStyle = .none
        self.subTerminalView.delegate = self
        self.subTerminalView.dataSource = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        playerInput.text = "_"
        terminalInputs = levelOne().rootSubFolders
        self.subTerminalView.allowsSelection = false
        self.terminals = [mainInternalTerminal,mainExternalTerminal,aiInternalTerminal,controlExternalTerminal,controlInternalTerminal]
        self.terminals.forEach(){roundCorners(to: $0)}
        aiExternalTerminal.clipsToBounds = true
        aiExternalTerminal.layer.cornerRadius = 10
        aiExternalTerminal.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        buttons = [firstButton,secondButton,thirdButtons]
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subTerminalView.rowHeight = UITableViewAutomaticDimension
        subTerminalView.estimatedRowHeight = 40
        let internalTerminals = [mainInternalTerminal,aiInternalTerminal,controlInternalTerminal]
        internalTerminals.forEach(){setInternalTerminal(terminal: $0!)}
        scanline.addScanline(to: mainInternalTerminal)
        //        scanline.addScanlineTwo(to: controlInternalTerminal)
        //        scanline.addScanlineThree(to: aiInternalTerminal)
        cursorBlink()
        timerBlink()
        buttons.forEach(){addGlow(object: $0)}
        addGlow(object: clearButton)
        addGlow(object: runButton)
        addGlow(object: timerLabel)
        addGlow(object: playerInput)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCutscene()
        makeDashedBorder()
    }
    
    
    // BUTTON ACTIONS

    @IBAction func nextCutscene(_ sender: UIButton) {
        sender.isHidden = true
        setCutscene()
    }
    
    @IBAction func firstButtonPressed(_ sender: UIButton) {
        self.playerInput.layer.removeAllAnimations()
        levelBrain?.firstButtonPressed()
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
        if (levelBrain?.needsInstructions())!{
            levelBrain?.checkAction(name: (sender.titleLabel?.text)!)
        }
    }
    
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
        self.playerInput.layer.removeAllAnimations()
        levelBrain?.secondButtonPressed()
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
        if (levelBrain?.needsInstructions())!{
            levelBrain?.checkAction(name: (sender.titleLabel?.text)!)
        }
    }
    
    
    @IBAction func thirdButtonPressed(_ sender: UIButton) {
        self.playerInput.layer.removeAllAnimations()
        levelBrain?.thirdButtonPressed()
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
        if (levelBrain?.needsInstructions())!{
            levelBrain?.checkAction(name: (sender.titleLabel?.text)!)
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        levelBrain?.clearButtonPressed()
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
        self.tableView.allowsSelection = false
        cursorBlink()
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        levelBrain?.runButtonPressed(input: playerInput.text!)
        setButtonLabels(labels: (levelBrain?.getButtonLabels())!)
        subTerminalView.beginUpdates()
        cursorBlink()
        self.tableView.allowsSelection = false
        subTerminalView.endUpdates()
    }
    
    
    
    
    
    
    // UI Functions
    func makeDashedBorder()  {
        let mViewBorder = CAShapeLayer()
        mViewBorder.strokeColor = UIColor.magenta.cgColor
        mViewBorder.lineDashPattern = [2, 2]
        mViewBorder.frame = firstButton.bounds
        mViewBorder.fillColor = nil
        mViewBorder.path = UIBezierPath(rect: firstButton.bounds).cgPath
        let sViewBorder = CAShapeLayer()
        sViewBorder.strokeColor = UIColor.magenta.cgColor
        sViewBorder.lineDashPattern = [2, 2]
        sViewBorder.frame = secondButton.bounds
        sViewBorder.fillColor = nil
        sViewBorder.path = UIBezierPath(rect: secondButton.bounds).cgPath
        let tViewBorder = CAShapeLayer()
        tViewBorder.strokeColor = UIColor.magenta.cgColor
        tViewBorder.lineDashPattern = [2, 2]
        tViewBorder.frame = thirdButtons.bounds
        tViewBorder.fillColor = nil
        tViewBorder.path = UIBezierPath(rect: thirdButtons.bounds).cgPath
        let cViewBorder = CAShapeLayer()
        cViewBorder.strokeColor = UIColor.red.cgColor
        cViewBorder.lineDashPattern = [2, 2]
        cViewBorder.frame = clearButton.bounds
        cViewBorder.fillColor = nil
        cViewBorder.path = UIBezierPath(rect: clearButton.bounds).cgPath
        let rViewBorder = CAShapeLayer()
        rViewBorder.strokeColor = UIColor.magenta.cgColor
        rViewBorder.lineDashPattern = [2, 2]
        rViewBorder.frame = runButton.bounds
        rViewBorder.fillColor = nil
        rViewBorder.path = UIBezierPath(rect: runButton.bounds).cgPath
        firstButton.layer.addSublayer(mViewBorder)
        secondButton.layer.addSublayer(sViewBorder)
        thirdButtons.layer.addSublayer(tViewBorder)
        clearButton.layer.addSublayer(cViewBorder)
        runButton.layer.addSublayer(rViewBorder)
    }
    
    func roundCorners(to view: UIView){
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
    }
    
    func setInternalTerminal(terminal: UIView) {
        terminal.layoutIfNeeded()
        terminal.addShadow(to: [.top,.left,.right,.bottom], radius: 10.0)
    }
    
    var commandState = gameState.rootState
    var folderState = levelOneState.root
    
    func disableAllButtons(){
        buttons.forEach(){
            $0.isEnabled = false
            $0.alpha = 0.5
        }
    }
    
    func enableAllButtons(){
        buttons.forEach(){
            $0.isEnabled = true
            $0.alpha = 1
        }
    }
    
    func cursorBlink(){
        self.playerInput.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options:[.repeat,.autoreverse],
                       animations:{ self.playerInput.alpha=1.0}, completion: nil)
    }
    
    func timerBlink(){
        self.timerLabel.alpha=0
        UIView.animate(withDuration: 1, delay: 0.4, options:[.repeat,.autoreverse],
                       animations:{ self.timerLabel.alpha=1.0}, completion: nil)
    }
  
    func setButtonLabels(labels: [String]) {
        firstButton.setTitle(labels[0], for: .normal)
        secondButton.setTitle(labels[1], for: .normal)
        thirdButtons.setTitle(labels[2], for: .normal)
    }
    
    
    
    // AI functions
    
    func makeBotTalk(speech: String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.subTerminalView.cellForRow(at: indexPath) as? subTerminalTableViewCell
        cell?.subTerminalText.text = speech
        cell?.subTerminalText.typingTimeInterval = TimeInterval.init(0.04)
        cell?.subTerminalText.startTypewritingAnimation(completion: {cell?.nextCutsceneButton.isHidden = true})
    }
    func setInstructions() {
        subTerminalView.beginUpdates()
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.subTerminalView.cellForRow(at: indexPath) as? subTerminalTableViewCell
        cell?.subTerminalText.text = levelBrain?.presentInstruction()
        cell?.subTerminalText.typingTimeInterval = TimeInterval.init(0.04)
        cell?.subTerminalText.startTypewritingAnimation(completion: {cell?.nextCutsceneButton.isHidden = true})
        self.subTerminalView.endUpdates()
        
    }
    
    func setCutscene() {
        if (levelBrain?.endOfCutscene())!{
            if (levelBrain?.needsInstructions())!{
                setInstructions()
            }
            return
        }
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.subTerminalView.cellForRow(at: indexPath) as? subTerminalTableViewCell
        cell?.subTerminalText.text = levelBrain?.presentCutscene()
        cell?.subTerminalText.typingTimeInterval = 0.04
        self.subTerminalView.reloadData()
        cell?.subTerminalText.startTypewritingAnimation(completion: {
            cell?.nextCutsceneButton.isHidden = false
        })
    }
}




extension HackViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == subTerminalView{
            return 1
        }
        return terminalInputs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == subTerminalView{
            let cell = subTerminalView.dequeueReusableCell(withIdentifier: "subTerminalCell", for: indexPath) as? subTerminalTableViewCell
            addGlow(object: (cell?.subTerminalText!)!)
            addGlow(object: (cell?.nextCutsceneButton!)!)
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "terminalCell", for: indexPath)
        let terminalText = terminalInputs[indexPath.row]
        addGlow(object: (cell.textLabel!))
        cell.textLabel?.text = terminalText
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
}

extension HackViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let title = cell?.textLabel?.text
        playerInput.text = playerInput.text! + "\(title!)"
        tableView.allowsSelection = false
        tableView.deselectRow(at: indexPath, animated: true)
        self.levelBrain?.checkAction(name: title!)
    }
    
}

extension HackViewController {
    func addGlow(object: UIView){
        object.layer.shadowColor = UIColor.magenta.cgColor
        if object == clearButton{
            object.layer.shadowColor = UIColor.red.cgColor
        }
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.masksToBounds = false
        
    }
}


extension HackViewController: LevelBrainDelegate {
    func enableFileTouch() {
        self.tableView.allowsSelection = true
    }
    
    func disableFileTouch() {
        self.tableView.allowsSelection = true
    }
    
    func correctTutorialPressed() {
        setInstructions()
    }
    
    func enableButtons() {
        enableAllButtons()
    }
    
    func endOfCutscene() {
        enableAllButtons()
        runButton.isEnabled = true
        runButton.alpha = 1
        clearButton.isEnabled = true
        clearButton.alpha = 1
    }
    
    func disableButtons() {
        disableAllButtons()
    }
    
    func getPlayerInputString(input: String) {
        self.playerInput.text = input
    }
}



