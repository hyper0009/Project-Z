//
//  Key.swift
//  Test
//
//  Created by Unai Motriko on 25/06/2017.
//  Copyright © 2017 Sami. All rights reserved.
//

import SpriteKit
import XCTest
@testable import Test

class TestKey: XCTestCase {
    
    let key:Key = Key(texture: SKTexture(imageNamed: "key-gold"))
    
    override func setUp() {
        super.setUp()
        key.setUpKey()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAffectedByGravity() {
        XCTAssertEqual(key.physicsBody?.affectedByGravity, false)
    }
    
    func testIsDynamic() {
        XCTAssertEqual(key.physicsBody?.isDynamic, false)
    }
    
    func testRotates() {
        XCTAssertEqual(key.physicsBody?.allowsRotation, false)
    }
    
    func testCollisionBitMask(){
        XCTAssertEqual(key.physicsBody?.collisionBitMask, 0)
    }
    
    func testCategoryBitMask(){
        XCTAssertEqual(key.physicsBody?.categoryBitMask, BodyType.key.rawValue)
    }
    
    func testContactTestBitMask(){
        XCTAssertEqual(key.physicsBody?.contactTestBitMask, BodyType.player.rawValue)
    }
    
    
    func testPerformanceExample() {
        self.measure {}
    }
}
