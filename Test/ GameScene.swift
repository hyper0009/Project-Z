//
//  GameScene.swift
//  Test
//
//  Created by Sami on 21/06/2017.
//  Copyright © 2017 Sami. All rights reserved.
//
import SpriteKit
import GameplayKit

enum BodyType:UInt32 {
    case player = 1
    case door = 2
    case key = 4
    case enemy = 8
    case weapon = 16
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    static let enemyHitCategory = 1
    var force:CGFloat = 16.0
    var thePlayer:Player = Player()
    var theKey:Key = Key()
    var theWeapon:Weapon = Weapon()
    var enemies = [Enemy]()
    var button:SKSpriteNode = SKSpriteNode()
    var leftButton:SKSpriteNode = SKSpriteNode()
    var rightButton:SKSpriteNode = SKSpriteNode()
    var theCamera:SKCameraNode = SKCameraNode()
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    private var lastUpdateTime : TimeInterval = 0
    let jump = SKAction.moveBy(x: 0, y: 100, duration: 0.2)
    let jumpTexture = SKAction.setTexture(SKTexture(imageNamed: "zombie_jump"))
    var jumpAction = SKAction()
    var isTouching = false
    var movingRight = false
    var movingLeft = false
    var xVelocity: CGFloat = 0
    var directionHandling: CGFloat = 1
    
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        if (self.childNode(withName: "Player") != nil){
            thePlayer = self.childNode(withName: "Player") as! Player
            thePlayer.setUpPlayer()
        }
        
        if (self.childNode(withName: "TheCamera") != nil){
            theCamera = self.childNode(withName: "TheCamera") as! SKCameraNode
            self.camera = theCamera
        }
        
        if (self.childNode(withName: "button") != nil){
            button = self.childNode(withName: "button") as! SKSpriteNode
        }
        
        if (self.childNode(withName: "leftButton") != nil){
            leftButton = self.childNode(withName: "leftButton") as! SKSpriteNode
        }
        
        if (self.childNode(withName: "rightButton") != nil){
            rightButton = self.childNode(withName: "rightButton") as! SKSpriteNode
        }
        
        if (self.childNode(withName: "Key") != nil) {
            theKey = self.childNode(withName: "Key") as! Key
            theKey.setUpKey()
        }
        
        if (self.childNode(withName: "Weapon") != nil) {
            theWeapon = self.childNode(withName: "Weapon") as! Weapon
            theWeapon.setUpWeapon()
        }
        
        if (self.childNode(withName: "Weapon2") != nil) {
            theWeapon = self.childNode(withName: "Weapon2") as! Weapon
            theWeapon.setUpWeapon()
        }
        
        for node in self.children {
            if let theDoor:Door = node as? Door {
                theDoor.setUpDoor()
            }
        }
        //        let wait = SKAction.wait(forDuration: 10)
        //        let spawn = SKAction.run {
        //            let theEnemy:Enemy = Enemy()
        //            theEnemy.xScale = fabs(theEnemy.xScale) * -1
        //            theEnemy.position = CGPoint(x: 300, y: 10)
        //            self.addChild(theEnemy)
        //            self.enemies.append(theEnemy)
        //            print(self.enemies.count)
        //            print(theEnemy.health)
        //        }
        //
        //        let constantSpawn = SKAction.sequence([spawn, wait])
        //        self.run(SKAction.repeatForever(constantSpawn))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.door.rawValue && thePlayer.hasKey) {
            if let theDoor = contact.bodyB.node as? Door {
                loadAnotherLevel (levelName: theDoor.goesWhere)
            }
            
        } else if ( contact.bodyA.categoryBitMask == BodyType.door.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue && thePlayer.hasKey)  {
            if let theDoor = contact.bodyA.node as? Door {
                loadAnotherLevel (levelName: theDoor.goesWhere)
            }
            
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy.rawValue){
            
            if let theBody = contact.bodyB.node as? Enemy {
                theBody.attacking = true
                thePlayer.physicsBody?.applyImpulse(CGVector(dx:-10, dy:10))
                theBody.attacking = false
                if (theBody.hasHit == false) {
                    thePlayer.health -= 50
                    theBody.delayHit()
                    print(thePlayer.health)
                }
            }
        } else if (contact.bodyA.categoryBitMask == BodyType.enemy.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue){
            
            if let theBody = contact.bodyA.node as? Enemy {
                theBody.attacking = true
                thePlayer.physicsBody?.applyImpulse(CGVector(dx:-5, dy:5))
                theBody.attacking = false
                if (theBody.hasHit == false) {
                    thePlayer.health -= 50
                    theBody.delayHit()
                    print(thePlayer.health)
                }
            }
        }
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.key.rawValue) {
            thePlayer.hasKey = true
            print(thePlayer.hasKey)
        }
        
        if ( contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.weapon.rawValue) {
            if let theWeapon = contact.bodyB.node as? Weapon {
                if theWeapon.pickedUp == false {
                    theWeapon.pickedUp = true
                    theWeapon.removeFromParent()
                    thePlayer.hasWeapon = true
                    thePlayer.weaponCount += 50
                }
            }
            
        }
    }
    
    
    func loadAnotherLevel( levelName:String) {
        if let scene = GameScene(fileNamed: levelName) {
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.1))
        }
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchlocation = touch!.location(in: self)
        let buttonJump = childNode(withName: "button") as! SKSpriteNode
        let buttonLeft = childNode(withName: "leftButton") as! SKSpriteNode
        let buttonRight = childNode(withName: "rightButton") as! SKSpriteNode
        let velocityCheck: CGFloat = -20.0
        
        
        
        if buttonJump.contains(touchlocation) && (thePlayer.physicsBody?.velocity.dy)! >= velocityCheck  {
            thePlayer.jump()
            
        } else if buttonRight.contains(touchlocation){
            directionHandling = 1
            isTouching = true
            movingRight = true
            xVelocity = 300
            
        } else if buttonLeft.contains(touchlocation){
            directionHandling = -1
            isTouching = true
            movingLeft = true
            xVelocity = -300
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        movingRight = false
        movingLeft = false
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, enemy) in enemies.enumerated() {
            if enemy.position.y < -100 {
                enemy.removeFromParent()
                enemies.remove(at: index)
            } else if !enemy .hasActions() && enemy.attacking == false{
                enemy.enemyWalk()
            } else if enemy.attacking == true && !enemy .hasActions() {
                enemy.attack()
            }
        }
        
        theCamera.position = CGPoint(x: thePlayer.position.x ,y: theCamera.position.y)
        button.position = CGPoint(x: thePlayer.position.x + 260 ,y: theCamera.position.y)
        leftButton.position = CGPoint(x: thePlayer.position.x - 280 ,y: theCamera.position.y)
        rightButton.position = CGPoint(x: thePlayer.position.x - 220 ,y: theCamera.position.y)
        
        
        if theCamera.position.y > -150 {
            
            theCamera.position = CGPoint(x: thePlayer.position.x ,y: thePlayer.position.y)
            button.position = CGPoint(x: thePlayer.position.x + 260 ,y: thePlayer.position.y)
            leftButton.position = CGPoint(x: thePlayer.position.x - 280 ,y: thePlayer.position.y)
            rightButton.position = CGPoint(x: thePlayer.position.x - 220 ,y: thePlayer.position.y)
        }
        
        thePlayer.statusCheck()
        
        if thePlayer.isDead {
            restartLevel()
        }
        
        if thePlayer.hasKey {
            theKey.removeFromParent()
        }
        
        thePlayer.xScale = fabs(thePlayer.xScale)*directionHandling
        
        if isTouching && movingRight && !thePlayer .hasActions(){
            thePlayer.walk(force: xVelocity)
            
        } else if isTouching && movingLeft && !thePlayer .hasActions(){
            thePlayer.walk(force: xVelocity)
            
        } else if !isTouching {
            thePlayer.setUpIdle()
        }
    }
    
    
    func restartLevel() {
        loadAnotherLevel (levelName: "EndPage")
        
    }
}



