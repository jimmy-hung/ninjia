

import UIKit

class OriginalViewController: UIViewController
{
    var soundSetting = UserDefaults().string(forKey: "Sound") ?? "On"
    var heardSetting = UserDefaults().string(forKey: "Heard") ?? "On"
    var bgmchoose = UserDefaults().string(forKey: "Bgmchoose") ?? "One"
    
    @IBOutlet weak var myBG    : UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var soundBtn: UIButton!
    @IBOutlet weak var heardBtn: UIButton!
    
    @IBOutlet weak var hBtn: UIButton!
    @IBOutlet weak var mBtn: UIButton!
    @IBOutlet weak var fBtn: UIButton!
    @IBOutlet weak var rBtn: UIButton!
    
    @IBOutlet weak var authorLB: UILabel!
    
    @IBOutlet weak var contact_usBtn: UIButton!
    
    let soundManger = SoundManager.shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        applyMotionEffect(toView: myBG, magnitude: 5)
        applyMotionEffect(toView: startBtn, magnitude: -30)
        
        applyMotionEffect(toView: soundBtn, magnitude: -20)
        applyMotionEffect(toView: heardBtn, magnitude: 20)
        
        applyMotionEffect(toView: hBtn, magnitude: 30)
        applyMotionEffect(toView: mBtn, magnitude: -30)
        applyMotionEffect(toView: fBtn, magnitude: -30)
        applyMotionEffect(toView: rBtn, magnitude: 30)
        applyMotionEffect(toView: contact_usBtn, magnitude: 50)
        
        soundManger.SoundManagerSetting()
        
        if soundSetting == "On"
        {
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound on"), for: .normal)
            soundManger.SE_VolumState = .open
        }
        else if soundSetting == "Off"
        {
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound off"), for: .normal)
            soundManger.SE_VolumState = .close
        }
        
        if heardSetting == "On"
        {
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard on"), for: .normal)
            soundManger.bgmOnOrClose(state: .open)
            originBGM()
        }
        else if heardSetting == "Off"
        {
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard off"), for: .normal)
            soundManger.bgmOnOrClose(state: .close)
        }
        
        
        // contact us
        contact_usBtn.layer.cornerRadius = 20
        contact_usBtn.clipsToBounds = true
        
        authorLB.layer.cornerRadius = 15
        authorLB.clipsToBounds = true
        
        // 字數超過欄位時，自動調整大小
        authorLB.adjustsFontSizeToFitWidth = true
        authorLB.minimumScaleFactor = 0.5
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        authorLB.text = author
        
        contact_usBtn.pulsate(sender: contact_usBtn, repeatIs: .greatestFiniteMagnitude)
    }
    
    @IBAction func contact_usAtn(_ sender: UIButton)
    {
        if author != "Jimmy"
        {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "web") as! WebViewViewController
            self.present(nextVC, animated: true, completion: nil)
        }
        else
        {
            addAlert(titleContent: "Hello, weclome", messageContent: "We are sorry but the part of webSite is not ready")
        }
        
    }
    

    @IBAction func soundAtn()
    {
        soundManger.playSEwith(sound: .SE1_metal)
        
        if soundSetting == "On"
        {
            soundSetting = "Off"
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound off"), for: .normal)
            soundManger.SE_VolumState = .close
        }
        else if soundSetting == "Off"
        {
            soundSetting = "On"
            soundBtn.setBackgroundImage(#imageLiteral(resourceName: "sound on"), for: .normal)
            soundManger.SE_VolumState = .open
        }
    }

    @IBAction func heardAtn()
    {
        soundManger.playSEwith(sound: .SE1_metal)
        
        if heardSetting == "On"
        {
            heardSetting = "Off"
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard off"), for: .normal)
            soundManger.bgmOnOrClose(state: .close)
        }
        else if heardSetting == "Off"
        {
            heardSetting = "On"
            heardBtn.setBackgroundImage(#imageLiteral(resourceName: "heard on"), for: .normal)
            soundManger.bgmOnOrClose(state: .open)
        }
    }
    
    func originBGM()
    {
        if bgmchoose == "One"{
            soundManger.playBGMwith(bgm: .BGM1)
        }else if bgmchoose == "Two"{
            soundManger.playBGMwith(bgm: .BGM2)
        }else if bgmchoose == "Three"{
            soundManger.playBGMwith(bgm: .BGM3)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func ringing()
    {
        soundManger.playSEwith(sound: .SE3_back)
    }
    
    @IBAction func comeToRing()
    {
        ringing()
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
    
    func addAlert (titleContent: String, messageContent: String)
    {
        let alertController = UIAlertController(title: titleContent, message: messageContent, preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "okay", style: .default) { (alertAction) in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "web") as! WebViewViewController
            self.present(nextVC, animated: true, completion: nil)
            
        }
        
        alertController.addAction(setAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
