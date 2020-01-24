//
//  SnakeNeck.swift
//  Snake
//
//  Created by Const. on 29/09/2019.
//  Copyright © 2019 Oleginc. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeNeck: SnakeBodyPart {
    
    
    
    override init(atPoint point: CGPoint) {
        super.init(atPoint: point)
        
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeNeck
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple | CollisionCategories.SnakeHead
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
