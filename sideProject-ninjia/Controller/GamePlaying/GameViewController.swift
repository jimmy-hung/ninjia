

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{
    
    @IBOutlet var final: UIView!
    @IBOutlet weak var resultBoom: UIButton!
    @IBOutlet weak var resultScore: UILabel!
    @IBOutlet weak var resultBack: UIButton!
    
    var score = 0
    
    var isGame = true{
        didSet{
            if isGame == false
            {
                final.isHidden = false
                resultBoom.flash(sender: resultBoom, repeatIs: 2)
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false       // 不顯示遊戲fps
            view.showsNodeCount = false // 不顯示出節點數
            
            // Game Notification
            let notificationName = Notification.Name("GameOver")
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.gamePlaying), name: notificationName, object: nil)
            
            let notificationScore = Notification.Name("refreshScore")
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.gotScore), name: notificationScore, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        // insert xib
        if let finalResult = Bundle.main.loadNibNamed("final", owner: self, options: nil)?.first as? final{
            
            final.frame.size.width = view.frame.size.width * 0.8
            final.frame.size.height = view.frame.size.height * 0.6
            final.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            final.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            
            final.gotCorner(radius: 30)
            self.view.addSubview(final)
            finalResult.isHidden = true
        }
    }
    
    @objc func gamePlaying(noti:Notification){
        isGame = noti.userInfo!["GAME"] as! Bool
    }
    
    @objc func gotScore(noti:Notification){
        score = noti.userInfo!["SCORE"] as! Int
        resultScore.text = "\(score)"
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func boomAtn (){
        resultBoom.pulsate(sender: resultBoom, repeatIs: 4)
    }
    
    func changeImg(){
        resultBoom.setBackgroundImage(#imageLiteral(resourceName: "mark"), for: .normal)
    }
    
    @IBAction func backAtn (){
        dismiss(animated: true, completion: nil)
    }
}


