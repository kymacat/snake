//
//  GameScene.swift
//  Snake
//
//  Created by Const. on 29/09/2019.
//  Copyright © 2019 Oleginc. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let EdgeBody: UInt32 = 0x1 << 3
    static let SnakeNeck: UInt32 = 0x1 << 4
}

class GameScene: SKScene {
    
    var snake: Snake?
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
                
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame.insetBy(dx: -1, dy: -1))
        self.physicsBody?.allowsRotation = false
        
        view.showsPhysics = true
        
        let counterClockwiseButton = SKShapeNode()

        counterClockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 60, height: 60)).cgPath
        
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX+3+25, y: view.scene!.frame.minY+30)
        
        counterClockwiseButton.fillColor = UIColor.gray
        counterClockwiseButton.lineWidth = 5
        
        counterClockwiseButton.name = "counterClockwiseButton"
        self.addChild(counterClockwiseButton)
        
        let clockwiseButton = SKShapeNode()

        clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 60, height: 60)).cgPath
        
        clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX-63-25, y: view.scene!.frame.minY+30)
        
        clockwiseButton.fillColor = UIColor.gray
        clockwiseButton.lineWidth = 5
        
        clockwiseButton.name = "clockwiseButton"
        self.addChild(clockwiseButton)
        createApple()
        
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
        self.physicsWorld.contactDelegate = self
        
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode, touchedNode.name == "clockwiseButton" || touchedNode.name == "counterClockwiseButton" else {
                return
            }
            
            touchedNode.fillColor = UIColor.green
            
            if touchedNode.name == "clockwiseButton" {
                snake!.moveClockwise()
            } else if touchedNode.name == "counterClockwiseButton" {
                snake!.moveCounterClockwise()
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let leftButton = self.childNode(withName: "counterClockwiseButton") as? SKShapeNode
        leftButton?.fillColor = UIColor.gray
        
        let rightButton = self.childNode(withName: "clockwiseButton") as? SKShapeNode
        rightButton?.fillColor = UIColor.gray
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
    }
    
    func createApple() {
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX-20)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY-20)) + 1)
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodyes ^ CollisionCategories.SnakeHead
        
        switch collisionObject {
        case CollisionCategories.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
            
        case CollisionCategories.EdgeBody:
            snake?.removeFromParent()
            snake = Snake(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
            self.addChild(snake!)
            
        case CollisionCategories.Snake:
            snake?.removeFromParent()
            snake = Snake(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
            self.addChild(snake!)
            
        default:
            break
        }
    }
}
