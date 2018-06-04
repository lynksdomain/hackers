//
//  LevelSelectViewController.swift
//  workingTitle
//
//  Created by C4Q on 4/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet weak var internalTerminal: UIView!
    @IBOutlet weak var externalTerminal: UIView!
    @IBOutlet var levelButtons: [UIButton]!
    @IBOutlet weak var terminalBackground: UIImageView!
    
    let scanline = Scanline()
    let userDefaults = UserDefaultHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        terminalBackground.layer.cornerRadius = 10
        terminalBackground.clipsToBounds = true
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        if !MusicHelper.manager.mainMenuPlaying {
            MusicHelper.manager.playMainMenuTheme()
        }
        terminalBackground.layoutIfNeeded()
        terminalBackground.addShadow(to: [.top,.left,.right,.bottom], radius: 10.0)
        scanline.addScanline(to: terminalBackground)
        self.levelButtons.forEach(){addGlow(object: $0)}
        self.labelCollection.forEach(){addGlow(object: $0)}
        setLevels()
    }
    
    @IBAction func level0pressed(_ sender: UIButton) {
        print("level0Pressed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HackViewController{
            let selectedButton = sender as? UIButton
            destination.levelNumber = selectedButton?.tag
        }
    }
}



extension LevelSelectViewController{
    func addGlow(object: UIView){
        object.layer.shadowColor = UIColor.magenta.cgColor
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.masksToBounds = false
    }
    
    func setLevels() {
       let latestLevel = userDefaults.levelsUnlocked()
        for i in 0...latestLevel {
            let button = levelButtons[i]
            button.isEnabled = true
            button.alpha = 1.0
        }
    }
}
