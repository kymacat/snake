//
//  Apple.swift
//  Snake
//
//  Created by Const. on 29/09/2019.
//  Copyright © 2019 Oleginc. All rights reserved.
//

import UIKit
import SpriteKit

class Apple: SKShapeNode {
    
    convenience init(position: CGPoint) {
        self.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        
        fillColor = UIColor.red
        
        strokeColor = UIColor.red
        
        lineWidth = 5
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: 7, center: CGPoint(x: 5, y: 5))
        
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Apple
    }
}
