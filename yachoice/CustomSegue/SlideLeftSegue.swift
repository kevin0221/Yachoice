//
//  SlideLeftSegue.swift
//  yachoice
//
//  Created by Admin on 2/22/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class SlideLeftSegue: UIStoryboardSegue {

    override func perform() {
        let sourceVC:UIViewController = self.source 
        let destVC:UIViewController = self.destination
        
        let transition:CATransition = CATransition.init()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        transition.type = kCATransitionPush //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromRight //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        
        sourceVC.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        sourceVC.navigationController!.pushViewController(destVC, animated:false)
    }
}
