//
//  FirstViewController.swift
//  bao-2018-ninjiaFighting111
//
//  Created by 蘇 郁傑 on 2018/10/12.
//  Copyright © 2018 蘇 郁傑. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController
{
    @IBOutlet weak var showMyLb: UILabel!
    @IBOutlet weak var firstMyBG: UIImageView!
    @IBOutlet weak var playGameBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        playGameBtn.layer.cornerRadius = 20
        playGameBtn.clipsToBounds = true
        
        applyMotionEffect(toView: playGameBtn, magnitude: 50)
        
        // 字數超過欄位大小時，自動提調整字體縮小最小為0.8倍
        showMyLb.adjustsFontSizeToFitWidth = true
        showMyLb.minimumScaleFactor = 0.8
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let url = URL(string: firstBGImg) // 初始化url图片
        
        let data : NSData! = NSData(contentsOf: url!) //转为data类型
        
        if data != nil { //判斷data不为空，這裡是因为swift對類型要求很嚴格，如果未空的话，會崩潰
            
            firstMyBG.image = UIImage.init(data: data as Data, scale: 1) // 賦值圖片
            
        }else{
            
            firstMyBG.image = UIImage.init(named: "bg_home") // 否則就賦值默認圖片
            showMyLb.adjustsFontSizeToFitWidth = true
        }
        
        playGameBtn.pulsate(sender: playGameBtn, repeatIs: .greatestFiniteMagnitude)
        
        showMyLb.text = showText
        playGameBtn.setTitle(playText, for: .normal)
    }
    
    @IBAction func playGameAtn(_ sender: UIButton)
    {
        if UserDefaults().string(forKey: "Author")! == "Jimmy"
        {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "origin") as! OriginalViewController
            present(nextVC, animated: true, completion: nil)
        }
        else
        {
            // come in to learn us more
            author = "Jimmy"
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "web") as! WebViewViewController
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func applyMotionEffect (toView view: UIView, magnitude: Float)
    {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
}
