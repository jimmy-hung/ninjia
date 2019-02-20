
import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    var newPlayer     = SKSpriteNode(imageNamed: "")
    var newSecPlayer  = SKSpriteNode(imageNamed: "sun")
    var myBG          = SKSpriteNode(imageNamed: "bg")
    var scoreField    = SKSpriteNode(imageNamed: "icon_9")
    var starField     = SKSpriteNode(imageNamed: "icon_10")
    var gameOverG     = SKShapeNode()
    var gotPointG     = SKShapeNode()

    var pointLB = SKLabelNode()
    var point = starCollect{
        didSet{
            pointLB.text = "\(point)"
        }
    }
    
    var scoreLb = SKLabelNode()
    var score = 0{
        didSet{
            
            if isGame == true{
                scoreLb.text = "\(score)"
                NotificationCenter.default.post(name: Notification.Name("refreshScore"), object: nil, userInfo: ["SCORE":score])
            }else if isGame == false{
                return
            }
        }
    }
    
    var anemeyProductTime:Timer!
    
    var batessAry = ["bat1","bat2"]
    
    let noneCategory   : UInt32 = 0x1 << 0
    let batessCategory : UInt32 = 0x1 << 1
    let batBossCategory: UInt32 = 0x1 << 2
    let myStartCategory: UInt32 = 0x1 << 3
    let playerCategory : UInt32 = 0x1 << 4
    let endGCategory   : UInt32 = 0x1 << 5
    let secGCategory   : UInt32 = 0x1 << 6
    
    var setSPriteNodeValue = "index"
    var fireAttack = "sun"
    var grids = false
    var isGame = true
    var bossCount = 1
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        view.showsFPS = false       // 不顯示遊戲fps
        view.showsNodeCount = false // 不顯示出節點數
        
        scoreLb = SKLabelNode(text: "0")
        scoreLb.position = CGPoint(x:-100, y: self.frame.size.height/2 - 70)
        scoreLb.fontName = "AmericanTypewriter-Bold"
        scoreLb.fontSize = 36
        scoreLb.fontColor = UIColor.black
        scoreLb.zPosition = 3
        
        self.addChild(scoreLb)
        
        pointLB = SKLabelNode(text: "0")
        pointLB.position = CGPoint(x:100, y: self.frame.size.height/2 - 70)
        pointLB.fontName = "AmericanTypewriter-Bold"
        pointLB.fontSize = 36
        pointLB.fontColor = UIColor.black
        pointLB.zPosition = 3
        
        self.addChild(pointLB)
        
        setGame()
        
        anemeyProductTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addBatess), userInfo: nil, repeats: true)
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data{
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 1 + self.xAcceleration * 0.25
            }
        }
    }
    
    func setGame(){
        pointLB.text = "\(starCollect)"
        
        let bgScale = CGFloat(myBG.frame.width / myBG.frame.height)
        
        myBG.size.height = self.frame.height
        myBG.size.width = myBG.size.height * bgScale
        myBG.position = CGPoint(x: 0, y: 0 )
        myBG.zPosition = -1
        self.addChild(myBG)
        
        let playerScale = CGFloat(newPlayer.frame.width / newPlayer.frame.height)
        
        if currentCharacterChoice == .TheOldMan{
            newPlayer    = SKSpriteNode(imageNamed: "A.genin")
        }else if currentCharacterChoice == .TheHuman{
            newPlayer    = SKSpriteNode(imageNamed: "B.chunin")
        }else if currentCharacterChoice == .TheZombie{
            newPlayer    = SKSpriteNode(imageNamed: "C.jonin")
        }
        
        newPlayer.size.height = self.frame.height / 8
        newPlayer.size.width = newPlayer.size.height * playerScale
        newPlayer.position = CGPoint(x: 0, y:  -self.frame.size.height/2 + 80)
        newPlayer.zPosition = 2
        newPlayer.physicsBody?.categoryBitMask = playerCategory
        newPlayer.physicsBody?.contactTestBitMask = myStartCategory
        newPlayer.physicsBody?.collisionBitMask = playerCategory
        
        self.addChild(newPlayer)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        newSecPlayer.size.height = newPlayer.size.height / 2
        newSecPlayer.size.width  = newPlayer.size.width / 2
        newSecPlayer.position    = newPlayer.position
        newSecPlayer.zPosition   = 1
        
        // 隱藏功能太陽的光暈
        if currentSunRise == .LevelTwo{
            newSecPlayer.addGlow(radius: 150)
        }else if currentSunRise == .LevelThree{
            newSecPlayer.addGlow(radius: 120)
        }else if currentSunRise == .LevelFour{
            newSecPlayer.addGlow(radius: 90)
        }else if currentSunRise == .LevelFive{
            newSecPlayer.addGlow(radius: 30)
        }
        
        self.addChild(newSecPlayer)

        scoreField.size.height = self.frame.height / 15
        scoreField.size.width = newPlayer.size.height * playerScale * 1.2
        scoreField.position = CGPoint(x:-105, y: self.frame.size.height/2 - 55)
        scoreField.zPosition = 2
        
        self.addChild(scoreField)
        
        starField.size.height = self.frame.height / 15
        starField.size.width = newPlayer.size.height * playerScale * 1.2
        starField.position = CGPoint(x:95, y: self.frame.size.height/2 - 55)
        starField.zPosition = 2
        
        self.addChild(starField)

        // 設置一條判別遊戲結束的界線，已隱藏
        gameOverG = SKShapeNode(rectOf: CGSize(width: self.frame.width * 2, height: 5))
        gameOverG.fillColor = .red
        gameOverG.strokeColor = .clear
        gameOverG.position = CGPoint(x: self.frame.width / 2, y: -self.frame.size.height/2 + 35  )
        gameOverG.zPosition = 5
        gameOverG.alpha = grids ? 1 : 0
        
        gameOverG.physicsBody = SKPhysicsBody(rectangleOf: gameOverG.frame.size)
        gameOverG.physicsBody?.categoryBitMask = endGCategory
        gameOverG.physicsBody?.contactTestBitMask = batessCategory | myStartCategory
        gameOverG.physicsBody?.collisionBitMask = endGCategory
        gameOverG.physicsBody?.affectedByGravity = false
        gameOverG.physicsBody?.isDynamic = false
        self.addChild(gameOverG)
 
        // 設置判別有無碰到星星積分的界線，已隱藏
        gotPointG = SKShapeNode(rectOf: CGSize(width: self.frame.width * 2, height: 5))
        gotPointG.fillColor = .blue
        gotPointG.strokeColor = .clear
        gotPointG.position = CGPoint(x: self.frame.width / 2, y: -self.frame.size.height/2 + 100  )
        gotPointG.zPosition = 5
        gotPointG.alpha = grids ? 1 : 0
        
        gotPointG.physicsBody = SKPhysicsBody(rectangleOf: gameOverG.frame.size)
        gotPointG.physicsBody?.categoryBitMask = secGCategory
        gotPointG.physicsBody?.contactTestBitMask = myStartCategory
        gotPointG.physicsBody?.collisionBitMask = secGCategory
        gotPointG.physicsBody?.affectedByGravity = false
        gotPointG.physicsBody?.isDynamic = false
        self.addChild(gotPointG)
    }
    
       @objc func addBatess(){
        
        batessAry = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: batessAry) as! [String]
        
        let bat = SKSpriteNode(imageNamed: batessAry[0])
        let batScale = CGFloat(bat.frame.width / (bat.frame.height * 2)) // 新增 *2
        
        
        let a = Int(self.frame.size.width)/2
        let b = Int(bat.size.width)/5
        let randomEnemeyPosition = GKRandomDistribution(lowestValue: -a + b, highestValue: a - b)
        let position = CGFloat(randomEnemeyPosition.nextInt())
        
        bat.size.width = self.frame.size.width / 5  // 4
        bat.size.height = bat.size.width * batScale
        bat.position = CGPoint(x: position, y: self.frame.size.height/2 + bat.size.height)
        bat.zPosition = 3
        
        bat.physicsBody = SKPhysicsBody(rectangleOf: bat.size)
        bat.physicsBody?.isDynamic = true
        
        bat.physicsBody?.categoryBitMask = batessCategory
        bat.physicsBody?.contactTestBitMask = noneCategory | endGCategory
        bat.physicsBody?.collisionBitMask = 0
   
//        if let index = bat.userData?.value(forKey: setSPriteNodeValue) as? Int {
//            print(index)
//        }

        bat.name = batessAry[0]
        
        self.addChild(bat)
        
        skActionToGo(theNode: bat, xposition: position, animateTime: 6, ypositiion: 4.5)
    }
    
    func addMyStart(enemeyPosition: CGPoint){
        let myStart = SKSpriteNode(imageNamed: "start")
        let myStartScale = CGFloat(myStart.frame.width / myStart.frame.height)
        
        let position = enemeyPosition
        
        myStart.addGlow(radius: 20)
        
        myStart.position = position
        myStart.zPosition = 2
        myStart.size.width = self.frame.size.width / 7
        myStart.size.height = myStart.size.width * myStartScale
        myStart.physicsBody = SKPhysicsBody(rectangleOf: myStart.size)
        myStart.physicsBody?.isDynamic = true
        
        myStart.physicsBody?.categoryBitMask = myStartCategory
        myStart.physicsBody?.contactTestBitMask = playerCategory | endGCategory | secGCategory
        myStart.physicsBody?.collisionBitMask = 0
        
        self.addChild(myStart)
        
        skActionToGo(theNode: myStart, xposition: position.x, animateTime: 3, ypositiion: 10)
    }
    
    func skActionToGo(theNode: SKSpriteNode, xposition: CGFloat, animateTime: Double, ypositiion: CGFloat){
        
        let animationDuration : TimeInterval = animateTime // 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: xposition, y: -theNode.size.height * ypositiion), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        theNode.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if currentWeaponType == .BrownLevelOne{
            fireAttack = "SimpleShuriken"
        }else if currentWeaponType == .GreenLevelTwo{
            fireAttack = "FourthShuriken"
        }else if currentWeaponType == .BlueLevelThree{
            fireAttack = "MasterShuriken"
        }
        
        if isGame == true{
            getFire(img:fireAttack)
        }
        else if isGame == false{
            return
        }
    }
    
    func getFire(img:String){
        
        self.run(SKAction.playSoundFileNamed("Cartoon_Boing.mp3", waitForCompletion: false))
        
        let fireNode = SKSpriteNode(imageNamed: img)
        let fireNodeScale = CGFloat(fireNode.frame.width / fireNode.frame.height)
        fireNode.position = newPlayer.position
        fireNode.position.y += 50
        fireNode.zPosition = 3
        fireNode.size.width = self.frame.size.width / 10
        fireNode.size.height = fireNode.size.width * fireNodeScale
        
        fireNode.physicsBody = SKPhysicsBody(circleOfRadius: fireNode.size.width / 2)
        fireNode.physicsBody?.isDynamic = true
        
        fireNode.physicsBody?.categoryBitMask = noneCategory
        fireNode.physicsBody?.contactTestBitMask = batessCategory | batBossCategory
        fireNode.physicsBody?.collisionBitMask = 0
        fireNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(fireNode)
        
        if currentCharacterChoice == .TheZombie{
            let taillNode = SKNode()
            taillNode.zPosition = 0
            
            addChild(taillNode)
            
            let tail = SKEmitterNode(fileNamed: "ice")!
            tail.targetNode = taillNode
            
            fireNode.addChild(tail)
        }else if currentCharacterChoice == .TheHuman{
            let taillNode = SKNode()
            taillNode.zPosition = 0
            
            addChild(taillNode)
            
            let tail = SKEmitterNode(fileNamed: "fire")!
            tail.targetNode = taillNode
            
            fireNode.addChild(tail)
        }
        
        var animationDuration:TimeInterval = 0
        
        if currentAttackSpeed == .S6{
            animationDuration = 6
        }else if currentAttackSpeed == .S12{
            animationDuration = 3
        }else if currentAttackSpeed == .S24{
            animationDuration = 1.5
        }
        
        var actionArray = [SKAction]()
        var rotationArray = [SKAction]()
        var zRotat: CGFloat = 0
        if currentAttackSpeed == .S6{
            zRotat = 40
        }else if currentAttackSpeed == .S12{
            zRotat = 80
        }else if currentAttackSpeed == .S24{
            zRotat = 360
        }
        
        actionArray.append(SKAction.move(to: CGPoint(x: newPlayer.position.x, y: self.frame.size.height + 0), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
       
        rotationArray.append(SKAction.rotate(toAngle: zRotat, duration: animationDuration))
        
        fireNode.run(SKAction.sequence(rotationArray))
        fireNode.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        var bulletTypeBase = 0.0
        var fireStrongBase = 0.0
        var sunRiseBase    = 1.0
        
        if currentWeaponType == .BrownLevelOne{
            bulletTypeBase = 1
        }else if currentWeaponType == .GreenLevelTwo{
            bulletTypeBase = 3.1
        }else if currentWeaponType == .BlueLevelThree{
            bulletTypeBase = 3.1 * 3.1
        }
        
        if currentCharacterChoice == .TheOldMan{
            fireStrongBase = 1
        }else if currentCharacterChoice == .TheHuman{
            fireStrongBase = 3.1
        }else if currentCharacterChoice == .TheZombie{
            fireStrongBase = 3.3 * 3.1
        }
        
        if currentSunRise == .LevelTwo{
            sunRiseBase = 2
        }else if currentSunRise == .LevelThree{
            sunRiseBase = 3
        }else if currentSunRise == .LevelFour{
            sunRiseBase = 4
        }else if currentSunRise == .LevelFive{
            sunRiseBase = 5
        }
        
        let getRound = CGFloat(round(Double(score / 50)))
        
        var base = CGFloat(100 * bulletTypeBase * fireStrongBase * sunRiseBase)

        base = base / pow(getRound,3)
        
        
        if firstBody.categoryBitMask == myStartCategory && secondBody.categoryBitMask == endGCategory{
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.categoryBitMask == myStartCategory{
            let x = (firstBody.node?.position.x)! - newPlayer.position.x
            let y = (firstBody.node?.position.y)! - newPlayer.position.y
    
            let xy = sqrt(x*x + y*y)
            
            if isGame == true{
                if xy <= 150{
                    self.run(SKAction.playSoundFileNamed("Metallic_Clank.mp3", waitForCompletion: false))

                    firstBody.node?.removeFromParent()
                    point += 1
                    print("body point: \(point)")
                }
            }
            else if isGame == false  {
                return
            }
        }
        
        if firstBody.categoryBitMask == batessCategory || firstBody.categoryBitMask == batBossCategory && secondBody.categoryBitMask == endGCategory {
            if isGame == true{
                isGame = false
                
                NotificationCenter.default.post(name: Notification.Name("GameOver"), object: nil, userInfo:["GAME":isGame])
                
                starCollect = point
                UserDefaults().set(point, forKey: "Star")
                
                save()
            }
            else if isGame == false {
                NotificationCenter.default.post(name: Notification.Name("GameOver"), object: nil, userInfo:["GAME":isGame])
                return
            }
        }

        if firstBody.categoryBitMask == noneCategory && secondBody.categoryBitMask == batessCategory || secondBody.categoryBitMask == batBossCategory{
            
            let a = firstBody.node as! SKSpriteNode
            
            let b = secondBody.node as! SKSpriteNode
            
            let myStartWish = [0,1,0,1,0]

            if (secondBody.node?.alpha)! <= CGFloat(0.8){
                
                fireDidCollideWithEnemeyBoom(fireDid: a, enemey: b)

                let wish = myStartWish[5.arc4random]

                if wish == 1 {
                    addMyStart(enemeyPosition: (secondBody.node?.position)!)
                }

                if secondBody.node?.name == "bat1" || secondBody.node?.name == "bat2"{
                    
                    if score >= 0 && score < 100{
                        score += 5
                    }else{
                         score += 5 * Int(getRound)
                    }
                }else{
                    score += 100
                    anemeyProductTime.fireDate = NSDate.init() as Date
                }
            }
            else if secondBody.node?.name == "bat1" || secondBody.node?.name == "bat2"{
                
                fireDidCollideWithEnemey(fireDid: a, enemey: b)
                secondBody.node?.alpha -= base * 0.5/1000
            }
        }
    }
    
    func fireDidCollideWithEnemey (fireDid:SKSpriteNode, enemey: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "boom")!
        explosion.position = enemey.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("Cartoon_Boing.mp3", waitForCompletion: false))
        
        fireDid.removeFromParent()

        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
    }
    
    func fireDidCollideWithEnemeyBoom (fireDid:SKSpriteNode, enemey: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "boomboom")!
        explosion.position = enemey.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("Cartoon_Boing.mp3", waitForCompletion: false))
        
        fireDid.removeFromParent()
        enemey.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
    }

    override func didSimulatePhysics(){
        newPlayer.position.x += xAcceleration * 50
        newSecPlayer.position.x += xAcceleration * 50
        
        let a = self.size.width/2
        
        if newPlayer.position.x < -a - 20{
            newPlayer.position = CGPoint(x: a + 20, y: newPlayer.position.y)
            newSecPlayer.position = CGPoint(x: a + 20, y: newPlayer.position.y)
        }else if newPlayer.position.x > a + 20{
            newPlayer.position = CGPoint(x: -a - 20, y: newPlayer.position.y)
            newSecPlayer.position = CGPoint(x: -a - 20, y: newPlayer.position.y)
        }
    }
    
    func save(){
        let userdefault = UserDefaults.standard
        
        if var socreLry:[Int] = userdefault.array(forKey: "scoreList") as? [Int] {
            socreLry.append(score)
            socreLry.sort(by:>)
            userdefault.set(socreLry, forKey: "scoreList")
        }else{
            var socreLry:[Int] = []
            socreLry.append(score)
            userdefault.set(socreLry, forKey: "scoreList")
        }
    }
}

