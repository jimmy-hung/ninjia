//
//  extension+view.swift
//  sideProject-ninjia
//
//  Created by 洪立德 on 2019/2/20.
//  Copyright © 2019 蘇 郁傑. All rights reserved.
//

import UIKit


extension UIView{
    
    func useMotionEffect (magnitude: Float){
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        self.addMotionEffect(group)
    }
    
}
