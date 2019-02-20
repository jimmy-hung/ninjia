

import UIKit
import AVFoundation

enum VolumeState{
    case open
    case close
}

//Mark - User Setting
enum BGMType:String{
    case BGM1 = "Darktown"
    case BGM2 = "Bongo_Madness"
    case BGM3 = "Island_Coconuts"
    //case BGM2 = ""
}
enum SEType:String {
    case SE1_metal = "Metallic_Clank"
    case SE2_wood = "Wood_Plank_Flicks"
    case SE3_back = "homeBtn"
    case SE4_correct = "correct"
    case SE5_wrong = "wrong"
    //case SE1 = ""
}

class SoundManager: NSObject {
    //Mark - User Setting
    //聲音預設(全開)
    var BGM_VolumeState:VolumeState = .open;
    var SE_VolumState:VolumeState = .open;
    
    //預設
    var bgmValue = 0;
    var seValue = 2
    
    static let shared:SoundManager = {
        let singleton = SoundManager()
        return singleton
    }()
    
    override init() {
        super.init()
        SoundManagerSetting()
    }
    
    //啟動頁必須啟動
    func SoundManagerSetting(){
        bgmSetting() //內設定播放
        seSetting()
    }
    
    private var audioPlayer_BGM = AVAudioPlayer();
    private var audioPlayer_SE = AVAudioPlayer();
    
    private var bgmAry:[URL] = []
    private var seAry:[URL] = []
    
    //BGM位置取得
     private func bgmSetting() {
        let bgmPath1 = Bundle.main.path(forResource: BGMType.BGM1.rawValue , ofType: "mp3")!
        let bgmUrl1 = URL(fileURLWithPath: bgmPath1)
        bgmAry.append(bgmUrl1)
        
        let bgmPath2 = Bundle.main.path(forResource: BGMType.BGM2.rawValue, ofType: "mp3")!
        let bgmUrl2 = URL(fileURLWithPath: bgmPath2)
        bgmAry.append(bgmUrl2)
        
        let bgmPath3 = Bundle.main.path(forResource: BGMType.BGM3.rawValue, ofType: "mp3")!
        let bgmUrl3 = URL(fileURLWithPath: bgmPath3)
        bgmAry.append(bgmUrl3)
        
        audioPlayer_BGM = try! AVAudioPlayer(contentsOf: bgmAry[bgmValue])
        playerSetting(audioPlayer: audioPlayer_BGM , loop: -1)
        audioPlayer_BGM.play()
    }
    
    //SE位置取得
     private func seSetting() {
        let sePath1 = Bundle.main.path(forResource: SEType.SE1_metal.rawValue, ofType: "mp3")!
        let seUrl1 = URL(fileURLWithPath: sePath1)
        seAry.append(seUrl1)
        
        let sePath2 = Bundle.main.path(forResource: SEType.SE2_wood.rawValue, ofType: "mp3")!
        let seUrl2 = URL(fileURLWithPath: sePath2)
        seAry.append(seUrl2)
        
        let sePath3 = Bundle.main.path(forResource: SEType.SE3_back.rawValue, ofType: "mp3")!
        let seUrl3 = URL(fileURLWithPath: sePath3)
        seAry.append(seUrl3)
        
        let sePath4 = Bundle.main.path(forResource: SEType.SE4_correct.rawValue, ofType: "mp3")!
        let seUrl4 = URL(fileURLWithPath: sePath4)
        seAry.append(seUrl4)
        
        let sePath5 = Bundle.main.path(forResource: SEType.SE5_wrong.rawValue, ofType: "mp3")!
        let seUrl5 = URL(fileURLWithPath: sePath5)
        seAry.append(seUrl5)
        
        
        
        audioPlayer_SE = try! AVAudioPlayer(contentsOf: seAry[seValue])
        playerSetting(audioPlayer: audioPlayer_SE, loop: 0)
    }
    
    //播放器預備
     private func playerSetting(audioPlayer: AVAudioPlayer, loop: Int){
        audioPlayer.prepareToPlay();
        audioPlayer.volume = 0.7
        audioPlayer.numberOfLoops = loop
    }
    
    
    //Mark - 對外設定
    
    func bgmOnOrClose(state: VolumeState){
        let state = state
        if state == .open{
            audioPlayer_BGM.play()
            BGM_VolumeState = state
        }else{
            audioPlayer_BGM.pause()
            BGM_VolumeState = state
        }
    }
    
    func playBGMwith(bgm: BGMType){
        switch bgm {
        case .BGM1:
            bgmValue = 0;
        case .BGM2:
            bgmValue = 1;
        case.BGM3:
            bgmValue = 2;
        }
        audioPlayer_BGM = try! AVAudioPlayer(contentsOf: bgmAry[bgmValue])
        audioPlayer_BGM.numberOfLoops = -1
        if BGM_VolumeState == .open{
            audioPlayer_BGM.play()
        }
    }
    
    func playSEwith(sound: SEType){
        if SE_VolumState == .open{
            switch sound {
            case .SE1_metal:
                seValue = 0
            case .SE2_wood:
                seValue = 1
            case .SE3_back:
                seValue = 2
            case .SE4_correct:
                seValue = 3
            case .SE5_wrong:
                seValue = 4
            }
            audioPlayer_SE = try! AVAudioPlayer(contentsOf: seAry[seValue])
            audioPlayer_SE.play()
        }
    }
}
