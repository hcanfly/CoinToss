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



class ViewController: UIViewController {
                            
	@IBOutlet var coinView: UIView
	@IBOutlet var flipButton: UIButton
	
	var repeatCount = 0
	var animationDuration: Double = kQUICK_ANIMATION
	var maxReps = kMAX_REPS_QUICK
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var layer:CALayer = coinView.layer
		layer.contents = UIImage(named: "coin-heads-medium.png").CGImage
	}
	
	
	func doAnimation() {

		if ( repeatCount++ > maxReps ) {
			
			coinView.layer.contents = (arc4random() % 2 == 0) ? UIImage(named: "coin-tails-medium.png").CGImage : UIImage(named: "coin-heads-medium.png").CGImage
			coinView.layer.transform = CATransform3DIdentity
			flipButton.enabled = true
			
			return
		}
			
		if ( repeatCount == 1 ) {					// first time for this animation
			let duration: Double = (animationDuration * Double((maxReps+1)))
			
			let startFrame = coinView.frame
			UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
				
				var frame = self.coinView.frame
				
				frame.origin.y = 40.0
				self.coinView.frame = frame
				}, completion: {
					_ in
					
					UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
						
						self.coinView.frame = startFrame
						}, completion: nil)
				})
		}
		
		UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
			
			var rotation: CATransform3D = CATransform3DIdentity
			
			rotation = CATransform3DRotate(rotation, 0.5 * CGFloat(M_PI), 1.0, 0.0, 0.0)
			self.coinView.layer.transform = rotation
			}, completion: {
				_ in
				
				self.coinView.layer.contents = UIImage(named: "coin-tails-medium.png").CGImage
				UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
					
					var rotation: CATransform3D = self.coinView.layer.transform;
					
					rotation = CATransform3DRotate(rotation, 1.0 * CGFloat(M_PI), 1.0, 0.0, 0.0);
					self.coinView.layer.transform = rotation;
					}, completion: {
						_ in
						
						self.coinView.layer.contents = UIImage(named: "coin-heads-medium.png").CGImage
						self.doAnimation()
					})
			})
	}


	@IBAction func quickTossButtonAction(sender: AnyObject) {
		
		if animationDuration < 0.2 {
			animationDuration = kSLOW_ANIMATION
			maxReps = kMAX_REPS_SLOW
		} else {
			animationDuration = kQUICK_ANIMATION
			maxReps = kMAX_REPS_QUICK
		}
	}
	
	@IBAction func flipCoinAction(sender: AnyObject) {
		
		let button = sender as UIButton
		button.enabled = false
		
		repeatCount = 0;
		coinView.layer.removeAllAnimations()
		self.coinView.layer.contents = UIImage(named: "coin-heads-medium.png").CGImage
		doAnimation()
	}

}

