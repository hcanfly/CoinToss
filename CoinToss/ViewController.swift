//
//  ViewController.swift
//  CoinToss
//
//  Created by main on 7/18/14.
//  Copyright (c) 2014 Gary.com. All rights reserved.
//

import UIKit
import QuartzCore


let kMAX_REPS_QUICK = 20
let kMAX_REPS_SLOW = 10
let kSLOW_ANIMATION: Double = 0.4
let kQUICK_ANIMATION: Double = 0.15



final class ViewController: UIViewController {
    
    @IBOutlet weak private var coinView: UIView!
    @IBOutlet weak private var flipButton: UIButton!
    
    private var repeatCount = 0
    private var animationDuration = kQUICK_ANIMATION
    private var maxReps = kMAX_REPS_QUICK
    
    private let headsImage = UIImage(named: "coin-heads-medium.png")!.cgImage
    private let tailsImage = UIImage(named: "coin-tails-medium.png")!.cgImage
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = coinView.layer
        layer.contents = self.headsImage
    }
    
    
    func doAnimation() {
        
        if repeatCount > maxReps {
            
            coinView.layer.contents = (Int(arc4random()) % 2 == 0) ? self.tailsImage : self.headsImage
            coinView.layer.transform = CATransform3DIdentity
            flipButton.isEnabled = true
            
            return
        }
        repeatCount += 1
        
        if repeatCount == 1 {                    // first time for this animation
            let duration = animationDuration * Double((maxReps+1))
            
            let startFrame = coinView.frame
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                var frame = self.coinView.frame
                
                frame.origin.y = 40.0
                self.coinView.frame = frame
            }, completion: {
                _ in
                
                UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                    self.coinView.frame = startFrame
                }, completion: nil)
            })
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            var rotation = CATransform3DIdentity
            
            rotation = CATransform3DRotate(rotation, 0.5 * CGFloat.pi, 1.0, 0.0, 0.0)
            self.coinView.layer.transform = rotation
        }, completion: {
            _ in
            
            self.coinView.layer.contents = self.tailsImage
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                
                var rotation = self.coinView.layer.transform;
                
                rotation = CATransform3DRotate(rotation, 1.0 * CGFloat.pi, 1.0, 0.0, 0.0);
                self.coinView.layer.transform = rotation;
            }, completion: {
                _ in
                
                self.coinView.layer.contents = self.headsImage
                self.doAnimation()
            })
        })
    }
    
    
    @IBAction func handleQuickTossButton(_ sender: Any) {
        if self.animationDuration < 0.2 {
            self.animationDuration = kSLOW_ANIMATION
            self.maxReps = kMAX_REPS_SLOW
        } else {
            self.animationDuration = kQUICK_ANIMATION
            self.maxReps = kMAX_REPS_QUICK
        }
    }
    
    
    @IBAction func doFlipCoin(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        
        self.repeatCount = 0;
        coinView.layer.removeAllAnimations()
        self.coinView.layer.contents = self.headsImage
        doAnimation()
    }
    
}

