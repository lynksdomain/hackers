//
//  MainMenuViewController.swift
//  workingTitle
//
//  Created by C4Q on 4/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import QuartzCore

class MainMenuViewController: UIViewController {

    var objectsForGlow = [UIView]()
    let scanline = Scanline()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.manager.playMusic()
        titleBlink()
        objectsForGlow = [startButton,startLabel,settingsLabel,settingsButtons,titleLabel]
        objectsForGlow.forEach(){addGlow(object: $0)}
        terminalBackground.layer.cornerRadius = 10
        terminalBackground.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanline.addScanline(to: internalTerminal)
        terminalBackground.addShadow(to: [.top,.bottom,.left,.right], radius: 10.0)
    }

    
    @IBOutlet weak var terminalBackground: UIImageView!
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsButtons: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var internalTerminal: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    
    
    func titleBlink(){
        self.titleLabel.alpha=0
        UIView.animate(withDuration: 1, delay: 1, options:[.repeat,.autoreverse],
                       animations:{ self.titleLabel.alpha=1.0}, completion: nil)
    }
    
  
   
}



extension MainMenuViewController{
    
    
    func addGlow(object: UIView){
        object.layer.shadowColor = UIColor.magenta.cgColor
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.masksToBounds = false
        
    }
    
}

extension UIView{
    
    func addShadow(to edges:[UIRectEdge], radius:CGFloat){
        
        let toColor = UIColor.clear
        let fromColor = UIColor.black
        // Set up its frame.
        let viewFrame = self.frame
        for edge in edges{
            let gradientlayer          = CAGradientLayer()
            gradientlayer.colors       = [fromColor.cgColor,toColor.cgColor]
            gradientlayer.shadowRadius = radius
            
            switch edge {
            case UIRectEdge.top:
                gradientlayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientlayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientlayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: gradientlayer.shadowRadius)
            case UIRectEdge.bottom:
                gradientlayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientlayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientlayer.frame = CGRect(x: 0.0, y: viewFrame.height - gradientlayer.shadowRadius, width: viewFrame.width, height: gradientlayer.shadowRadius)
            case UIRectEdge.left:
                gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientlayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientlayer.frame = CGRect(x: 0.0, y: 0.0, width: gradientlayer.shadowRadius, height: viewFrame.height)
            case UIRectEdge.right:
                gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientlayer.frame = CGRect(x: viewFrame.width - gradientlayer.shadowRadius, y: 0.0, width: gradientlayer.shadowRadius, height: viewFrame.height)
            default:
                break
            }
            self.layer.addSublayer(gradientlayer)
        }
        
    }
    
    func removeAllSublayers(){
        if let sublayers = self.layer.sublayers, !sublayers.isEmpty{
            for sublayer in sublayers{
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
}
