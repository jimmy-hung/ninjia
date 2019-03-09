

import UIKit
import GoogleMobileAds

var admob = 0
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
    
    var interstitial: GADInterstitial?
    
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
        
        interstitial = createInterstitial()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.8) {
            self.view.alpha = 1
        }
        
        if admob != 0{
            if interstitial!.isReady{
                interstitial!.present(fromRootViewController: self)
            }else{
                print("Ad wasn't ready")
            }
        }else{
            print("nothing")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.alpha = 0
    }
    
    func createInterstitial() -> GADInterstitial{
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6580741437448841/5883859607")
        let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID ]
        interstitial!.load(request)
        interstitial!.delegate = self
        return interstitial!
        //將事前建立的code用createInterstitial包起來
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createInterstitial()
        //關掉廣告的同時就讓 interstitial = createInterstitial()
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

extension OriginalViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
