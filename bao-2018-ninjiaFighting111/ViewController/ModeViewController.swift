
import UIKit

enum attackSpeed
{
    case S6
    case S12
    case S24
}

enum weaponType
{
    case BrownLevelOne
    case GreenLevelTwo
    case BlueLevelThree
}

enum characterChoice
{
    case TheOldMan
    case TheHuman
    case TheZombie
}

enum theSunRise
{
    case LevelOne
    case LevelTwo
    case LevelThree
    case LevelFour
    case LevelFive
}

var currentAttackSpeed     :attackSpeed = .S6
var currentWeaponType      :weaponType    = .BrownLevelOne
var currentCharacterChoice :characterChoice = .TheOldMan
var currentSunRise         :theSunRise  = .LevelOne

class ModeViewController: UIViewController
{
    // 紀錄前一項是否開通
    var speedRecord = UserDefaults().integer(forKey: "SPEED")
    var typeRecord = UserDefaults().integer(forKey: "TYPE")
    var characterRecord = UserDefaults().integer(forKey: "CHARACTER")
    var theSunRecord = UserDefaults().integer(forKey: "SUN")
    
    let soundManger = SoundManager.shared

    @IBOutlet weak var attack6s: UIButton!
    @IBOutlet weak var attack12s: UIButton!
    @IBOutlet weak var attack24s: UIButton!
    
    @IBOutlet weak var simpleShuriken: UIButton!
    @IBOutlet weak var FourthShuriken: UIButton!
    @IBOutlet weak var MasterShuriken: UIButton!
    
    @IBOutlet weak var genin: UIButton!
    @IBOutlet weak var chunin: UIButton!
    @IBOutlet weak var jonin: UIButton!
    
    @IBOutlet weak var theSunBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        setFirst()
        setSecond()
        setThird()
        print("theSunRecord: \(theSunRecord)")
        print("currentSunRise: \(currentSunRise)")
        
        theSunBtn.isHidden = true
        theSunBtn.isEnabled = false
        
        if speedRecord == 3 && typeRecord == 3 && characterRecord == 3{
            theSunBtn.isHidden = false
            theSunBtn.isEnabled = true
        }
    }
    
    @IBAction func bulletSpeed6()
    {
        if speedRecord == 3{
            setBtn(first: attack6s, second: attack12s, third: attack24s)
            currentAttackSpeed = .S6
        }else if speedRecord == 2{
            setBtn(first: attack6s, second: attack12s, third: attack24s)
            attack24s.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentAttackSpeed = .S6
        }else{
            addAlertBulletSpeed(starMount: 5, sender: attack6s, bulletspeeds: .S6, isSpeed: 1)
        }
    }
    
    @IBAction func bulletSpeed12()
    {
        if speedRecord == 1{
            addAlertBulletSpeed(starMount: 10, sender: attack12s, bulletspeeds: .S12, isSpeed: 2)
        }else if speedRecord == 3{
            setBtn(first: attack12s, second: attack6s, third: attack24s)
            currentAttackSpeed = .S12
        }else if speedRecord == 2{
            setBtn(first: attack12s, second: attack6s, third: attack24s)
            attack24s.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentAttackSpeed = .S12
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func bulletSpeed24()
    {
        if speedRecord == 2{
            addAlertBulletSpeed(starMount: 15, sender: attack24s, bulletspeeds: .S24, isSpeed: 3)
        }else if speedRecord == 3{
            setBtn(first: attack24s, second: attack12s, third: attack6s)
            currentAttackSpeed = .S24
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func  ballTypeOne()
    {
        if typeRecord == 3{
            setBtn(first: simpleShuriken, second: FourthShuriken, third: MasterShuriken)
            currentWeaponType = .BrownLevelOne
        }else if typeRecord == 2{
            setBtn(first: simpleShuriken, second: FourthShuriken, third: MasterShuriken)
            MasterShuriken.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentWeaponType = .BrownLevelOne
        }else{
            addAlertBulletType(starMount: 5, sender: simpleShuriken, bulletspeeds: .BrownLevelOne, isType: 1)
        }
    }
    
    @IBAction func  ballTypeTwo()
    {
        if typeRecord == 1{
            addAlertBulletType(starMount: 10, sender: FourthShuriken, bulletspeeds: .GreenLevelTwo, isType: 2)
        }else if typeRecord == 3{
            setBtn(first: FourthShuriken, second: simpleShuriken, third: MasterShuriken)
            currentWeaponType = .GreenLevelTwo
        }else if typeRecord == 2{
            setBtn(first: FourthShuriken, second: simpleShuriken, third: MasterShuriken)
            MasterShuriken.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentWeaponType = .GreenLevelTwo
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func  ballTypeThree()
    {
        if typeRecord == 2{
            addAlertBulletType(starMount: 15, sender: MasterShuriken, bulletspeeds: .BlueLevelThree, isType: 3)
        }else if typeRecord == 3{
            setBtn(first: MasterShuriken, second: FourthShuriken, third: simpleShuriken)
            currentWeaponType = .BlueLevelThree
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func oldManAtn()
    {
        if characterRecord == 3{
            setBtn(first: genin, second: chunin, third: jonin)
            currentCharacterChoice = .TheOldMan
        }else if characterRecord == 2{
            setBtn(first: genin, second: chunin, third: jonin)
            jonin.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentCharacterChoice = .TheOldMan
        }else{
            addAlertFireStrong(starMount: 5, sender: genin, bulletspeeds: .TheOldMan, isHuman: 1)
        }
    }
    
    @IBAction func manAtn()
    {
        if characterRecord == 1{
            addAlertFireStrong(starMount: 10, sender: chunin, bulletspeeds: .TheHuman, isHuman: 2)
        }else if characterRecord == 3{
            setBtn(first: chunin, second: genin, third: jonin)
            currentCharacterChoice = .TheHuman
        }else if characterRecord == 2{
            setBtn(first: chunin, second: genin, third: jonin)
            jonin.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
            currentCharacterChoice = .TheHuman
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func monsterAtn()
    {
        if characterRecord == 2{
            addAlertFireStrong(starMount: 15, sender: jonin, bulletspeeds: .TheZombie, isHuman: 3)
        }else if characterRecord == 3{
            setBtn(first: jonin, second: genin, third: chunin)
            currentCharacterChoice = .TheZombie
        }else{
            soundManger.playSEwith(sound: .SE5_wrong)
            return
        }
    }
    
    @IBAction func theSunAtn(_ sender: UIButton)
    {
        addAlertSun(starMount: 30)
    }
    
    
    func addAlertBulletSpeed(starMount:Int, sender: UIButton, bulletspeeds: attackSpeed, isSpeed: Int)
    {
        let alertController = UIAlertController(title: "Hello, welcome!!", message: "did you want to use \(starMount) Star to unlock ?", preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "Sure", style: .default) { (alertAction) in
            if starCollect >= starMount{
                starCollect -= starMount
                UserDefaults().set(starCollect, forKey: "Star")
                
                self.soundManger.playSEwith(sound: .SE4_correct)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3)
                {
                    sender.setImage(#imageLiteral(resourceName: "lock off"), for: .normal)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    sender.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                }
                
                currentAttackSpeed = bulletspeeds
                
                UserDefaults().set(isSpeed, forKey: "SPEED")
                self.speedRecord = isSpeed
                
            }else if starCollect < starMount{
                self.soundManger.playSEwith(sound: .SE5_wrong)
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addAlertBulletType(starMount:Int, sender: UIButton, bulletspeeds: weaponType, isType: Int)
    {
        let alertController = UIAlertController(title: "Hello, welcome!!", message: "did you want to use \(starMount) Star to unlock ?", preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "Sure", style: .default) { (alertAction) in
            if starCollect >= starMount{
                starCollect -= starMount
                UserDefaults().set(starCollect, forKey: "Star")
                
                self.soundManger.playSEwith(sound: .SE4_correct)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3)
                {
                    sender.setImage(#imageLiteral(resourceName: "lock off"), for: .normal)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    sender.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                }
                
                currentWeaponType = bulletspeeds
                
                UserDefaults().set(isType, forKey: "TYPE")
                self.typeRecord = isType
                
            }else if starCollect < starMount{
                self.soundManger.playSEwith(sound: .SE5_wrong)
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addAlertFireStrong(starMount:Int, sender: UIButton, bulletspeeds: characterChoice, isHuman: Int)
    {
        let alertController = UIAlertController(title: "Hello, welcome!!", message: "did you want to use \(starMount) Star to unlock ?", preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "Sure", style: .default) { (alertAction) in
            if starCollect >= starMount{
                starCollect -= starMount
                UserDefaults().set(starCollect, forKey: "Star")
                
                self.soundManger.playSEwith(sound: .SE4_correct)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3)
                {
                    sender.setImage(#imageLiteral(resourceName: "lock off"), for: .normal)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    sender.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                }
                
                currentCharacterChoice = bulletspeeds
                
                UserDefaults().set(isHuman, forKey: "CHARACTER")
                self.characterRecord = isHuman
                
            }else if starCollect < starMount{
                self.soundManger.playSEwith(sound: .SE5_wrong)
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addAlertSun(starMount: Int)
    {
        let alertController = UIAlertController(title: "Hello, welcome!!", message: "did you want to use \(starMount) Star to improve ?", preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "Sure", style: .default) { (alertAction) in
            if starCollect >= starMount{
                starCollect -= starMount
                UserDefaults().set(starCollect, forKey: "Star")
                
                self.soundManger.playSEwith(sound: .SE1_metal)
                self.soundManger.playSEwith(sound: .SE4_correct)
                
                if self.theSunRecord == 0{
                    self.theSunRecord += 1
                }
                
                self.theSunRecord += 1
                UserDefaults().set(self.theSunRecord, forKey: "SUN")
                
                if self.theSunRecord == 2{
                    currentSunRise = .LevelTwo
                }else if self.theSunRecord == 3{
                    currentSunRise = .LevelThree
                }else if self.theSunRecord == 4{
                    currentSunRise = .LevelFour
                }else if self.theSunRecord == 5{
                    currentSunRise = .LevelFive
                }
                
                print("555theSunRecord: \(self.theSunRecord)")
                print("555currentSunRise: \(currentSunRise)")
                
            }else if starCollect < starMount{
                self.soundManger.playSEwith(sound: .SE5_wrong)
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    func setFirst()
    {
        if speedRecord > 0
        {
            if speedRecord == 1{
                attack6s.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                attack12s.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                attack24s.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentAttackSpeed = .S6
            }else if speedRecord == 2{
                attack6s.setImage(nil, for: .normal)
                attack12s.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                attack24s.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentAttackSpeed = .S12
            }else if speedRecord == 3{
                attack6s.setImage(nil, for: .normal)
                attack12s.setImage(nil, for: .normal)
                attack24s.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                currentAttackSpeed = .S24
            }
        }
    }
    
    func setSecond()
    {
        if typeRecord > 0
        {
            if typeRecord == 1{
                simpleShuriken.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                FourthShuriken.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                MasterShuriken.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentWeaponType = .BrownLevelOne
            }else if typeRecord == 2{
                simpleShuriken.setImage(nil, for: .normal)
                FourthShuriken.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                MasterShuriken.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentWeaponType = .GreenLevelTwo
            }else if typeRecord == 3{
                simpleShuriken.setImage(nil, for: .normal)
                FourthShuriken.setImage(nil, for: .normal)
                MasterShuriken.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                currentWeaponType = .BlueLevelThree
            }
        }
    }
    
    func setThird()
    {
        if characterRecord > 0
        {
            if characterRecord == 1{
                genin.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                chunin.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                jonin.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentCharacterChoice = .TheOldMan
            }else if characterRecord == 2{
                genin.setImage(nil, for: .normal)
                chunin.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                jonin.setImage(#imageLiteral(resourceName: "lock on"), for: .normal)
                currentCharacterChoice = .TheHuman
            }else if characterRecord == 3{
                genin.setImage(nil, for: .normal)
                chunin.setImage(nil, for: .normal)
                jonin.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
                currentCharacterChoice = .TheZombie
            }
        }
    }
    
    func setBtn(first: UIButton, second: UIButton, third: UIButton)
    {
        first.setImage(#imageLiteral(resourceName: "mark"), for: .normal)
        second.setImage(nil, for: .normal)
        third.setImage(nil, for: .normal)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAtn()
    {
        soundManger.playSEwith(sound: .SE3_back)
        dismiss(animated: true, completion: nil)
    }

}
