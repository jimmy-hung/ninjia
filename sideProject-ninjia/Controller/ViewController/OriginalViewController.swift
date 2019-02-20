

import UIKit

class OriginalViewController: UIViewController{
    
    var soundSetting = UserDefaults().string(forKey: "Sound") ?? "On"
    var heardSetting = UserDefaults().string(forKey: "Heard") ?? "On"
    var bgmchoose = UserDefaults().string(forKey: "Bgmchoose") ?? "One"
    
    @IBOutlet weak var myBG    : UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var soundBtn: UIButton!
    @IBOutlet weak var heardBtn: UIButton!
    
    @IBOutlet weak var howBtn: UIButton!
    @IBOutlet weak var modeBtn: UIButton!
    @IBOutlet weak var functionBtn: UIButton!
    @IBOutlet weak var rankBtn: UIButton!
    
    let soundManger = SoundManager.shared
    
    override func viewDidLoad(){
        super.viewDidLoad()

        myBG.useMotionEffect(magnitude: 5)
        startBtn.useMotionEffect(magnitude: -30)
        
        soundBtn.useMotionEffect(magnitude: -20)
        heardBtn.useMotionEffect(magnitude: 20)
        
        howBtn.useMotionEffect(magnitude: 30)
        modeBtn.useMotionEffect(magnitude: -30)
        functionBtn.useMotionEffect(magnitude: -30)
        rankBtn.useMotionEffect(magnitude: 30)

        soundManger.SoundManagerSetting()
        
        if soundSetting == "On"{
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound on"), for: .normal)
            soundManger.SE_VolumState = .open
        }
        else if soundSetting == "Off"{
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound off"), for: .normal)
            soundManger.SE_VolumState = .close
        }
        
        if heardSetting == "On"{
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard on"), for: .normal)
            soundManger.bgmOnOrClose(state: .open)
            originBGM()
        }
        else if heardSetting == "Off"{
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard off"), for: .normal)
            soundManger.bgmOnOrClose(state: .close)
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func soundAtn(){
        
        soundManger.playSEwith(sound: .SE1_metal)
        
        if soundSetting == "On"{
            
            soundSetting = "Off"
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound off"), for: .normal)
            soundManger.SE_VolumState = .close
        }
        else if soundSetting == "Off"{
            
            soundSetting = "On"
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound on"), for: .normal)
            soundManger.SE_VolumState = .open
        }
    }

    @IBAction func heardAtn(){
        
        soundManger.playSEwith(sound: .SE1_metal)
        
        if heardSetting == "On"{
            
            heardSetting = "Off"
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard off"), for: .normal)
            soundManger.bgmOnOrClose(state: .close)
        }
        else if heardSetting == "Off"{
            
            heardSetting = "On"
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard on"), for: .normal)
            soundManger.bgmOnOrClose(state: .open)
        }
    }
    
    func originBGM(){
        
        if bgmchoose == "One"{
            soundManger.playBGMwith(bgm: .BGM1)
        }else if bgmchoose == "Two"{
            soundManger.playBGMwith(bgm: .BGM2)
        }else if bgmchoose == "Three"{
            soundManger.playBGMwith(bgm: .BGM3)
        }
    }
    
    override func didReceiveMemoryWarning(){
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func ringing(){
        
        soundManger.playSEwith(sound: .SE3_back)
    }
    
    @IBAction func comeToRing(){
        
        ringing()
    }
    
    func applyMotionEffect (toView view: UIView, magnitude: Float){
        
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
