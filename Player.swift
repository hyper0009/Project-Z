//
//  Player.swift
//  Test
//
//  Created by Unai Motriko on 21/06/2017.
//  Copyright © 2017 Sami. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    
    var health = 100
    static let enemyHitCategory = 1
    
    var jumpAction:SKAction?
    var walkAction:SKAction?
    var atlas:SKTextureAtlas?
    var textureIdle:SKAction?
    var xVelocity:CGFloat = 0
    
    var isDead = false
    
    var hasKey = false
    var hasWeapon = false
    var weaponCount:Int = 0
    
    func setUpPlayer() {
        
        let objectSize = CGSize(width: self.texture!.size().width * 0.4, height: self.texture!.size().height * 0.4)
        let body:SKPhysicsBody = SKPhysicsBody(texture: self.texture!, size: objectSize)
        
        self.physicsBody = body
        
        body.mass = 0.51282
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.restitution = 0
        body.categoryBitMask = BodyType.player.rawValue
        body.collisionBitMask = BodyType.door.rawValue | BodyType.enemy.rawValue | BodyType.ground.rawValue
        body.contactTestBitMask = BodyType.door.rawValue | BodyType.enemy.rawValue | BodyType.ground.rawValue
    }

    
    func setUpIdle() {
        let ninjaTexture = SKTexture(imageNamed: "idle")
        textureIdle = SKAction.setTexture(ninjaTexture)
        self.run(textureIdle!)
    }
    
    func jump() {
        self.run(SKAction.setTexture(SKTexture(imageNamed: "Image-1")))
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 450))
        
    }
    
    
    func walk(force: CGFloat) {
            self.physicsBody?.applyForce(CGVector(dx: force, dy: 0.0))
    }
    
    func statusCheck(){
        if (self.position.y < -200 || self.health <= 0){
            self.isDead = true
        }
        
        if (self.weaponCount == 0){
            self.hasWeapon = false
        }
    }
}
