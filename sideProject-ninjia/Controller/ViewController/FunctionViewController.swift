
import UIKit

class FunctionViewController: UIViewController
{
    var bgmchoose = UserDefaults().string(forKey: "Bgmchoose") ?? "One"
    var soundSetting = UserDefaults().string(forKey: "Sound") ?? "On"
    var heardSetting = UserDefaults().string(forKey: "Heard") ?? "On"

    @IBOutlet weak var bgmchooseOne: UIButton!
    @IBOutlet weak var bgmchooseTwo: UIButton!
    @IBOutlet weak var bgmchooseThree: UIButton!
    
    @IBOutlet weak var soundBtnOn: UIButton!
    @IBOutlet weak var soundBtnOff: UIButton!
    
    @IBOutlet weak var heardBtnOn: UIButton!
    @IBOutlet weak var heardBtnOff: UIButton!
    
    let soundManger = SoundManager.shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if bgmchoose == "One"
        {
            bgmchooseOne.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            bgmchooseTwo.setImage(nil, for: .normal)
            bgmchooseThree.setImage(nil, for: .normal)
        }
        else if bgmchoose == "Two"
        {
            bgmchooseOne.setImage(nil, for: .normal)
            bgmchooseTwo.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            bgmchooseThree.setImage(nil, for: .normal)
        }
        else if bgmchoose == "Three"
        {
            bgmchooseOne.setImage(nil, for: .normal)
            bgmchooseTwo.setImage(nil, for: .normal)
            bgmchooseThree.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
        
        // turn on or off sound
        if soundSetting == "On"
        {
            soundBtnOn.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            soundBtnOff.setImage(nil, for: .normal)
        }
        else if soundSetting == "Off"
        {
            soundBtnOn.setImage(nil, for: .normal)
            soundBtnOff.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
        
        // turn on or off heard
        if heardSetting == "On"
        {
            heardBtnOn.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            heardBtnOff.setImage(nil, for: .normal)
        }
        else if heardSetting == "Off"
        {
            heardBtnOn.setImage(nil, for: .normal)
            heardBtnOff.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
    }
    
    @IBAction func BgmChoice(_ sender: UIButton)
    {
        ringing()
        
        switch sender.tag {
        case 0:
            bgmchoose = "One"
            UserDefaults().set("One", forKey: "Bgmchoose")
            soundManger.playBGMwith(bgm: .BGM1)
            BgmChoose()
        case 1:
            bgmchoose = "Two"
            UserDefaults().set("Two", forKey: "Bgmchoose")
            soundManger.playBGMwith(bgm: .BGM2)
            BgmChoose()
        case 2:
            bgmchoose = "Three"
            UserDefaults().set("Three", forKey: "Bgmchoose")
            soundManger.playBGMwith(bgm: .BGM3)
            BgmChoose()
        case 3:
            soundSetting = "On"
            UserDefaults().set("On", forKey: "Sound")
            soundManger.SE_VolumState = .open
            soundCheck()
        case 4:
            soundSetting = "Off"
            UserDefaults().set("Off", forKey: "Sound")
            soundManger.SE_VolumState = .close
            soundCheck()
        case 5:
            heardSetting = "On"
            UserDefaults().set("On", forKey: "Heard")
            soundManger.bgmOnOrClose(state: .open)
            heardCheck()
        case 6:
            heardSetting = "Off"
            UserDefaults().set("Off", forKey: "Heard")
            soundManger.bgmOnOrClose(state: .close)
            heardCheck()
        default:
            return
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BgmChoose()
    {
        // to choose backgroud music
        if bgmchoose == "One"
        {
            bgmchooseOne.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            bgmchooseTwo.setImage(nil, for: .normal)
            bgmchooseThree.setImage(nil, for: .normal)
        }
        else if bgmchoose == "Two"
        {
            bgmchooseOne.setImage(nil, for: .normal)
            bgmchooseTwo.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            bgmchooseThree.setImage(nil, for: .normal)
        }
        else if bgmchoose == "Three"
        {
            bgmchooseOne.setImage(nil, for: .normal)
            bgmchooseTwo.setImage(nil, for: .normal)
            bgmchooseThree.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
    }
    
    func soundCheck()
    {
        // turn on or off sound
        if soundSetting == "On"
        {
            soundBtnOn.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            soundBtnOff.setImage(nil, for: .normal)
        }
        else if soundSetting == "Off"
        {
            soundBtnOn.setImage(nil, for: .normal)
            soundBtnOff.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
    }
    
    func heardCheck()
    {
        // turn on or off heard
        if heardSetting == "On"
        {
            heardBtnOn.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
            heardBtnOff.setImage(nil, for: .normal)
        }
        else if heardSetting == "Off"
        {
            heardBtnOn.setImage(nil, for: .normal)
            heardBtnOff.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        }
    }
    
    func ringing()
    {
        soundManger.playSEwith(sound: .SE2_wood)
    }
    
    @IBAction func backAtn()
    {
        soundManger.playSEwith(sound: .SE3_back)
        dismiss(animated: true, completion: nil)
    }
    
}
