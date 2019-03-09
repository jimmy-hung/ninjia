
import UIKit

class HowToPlayViewController: UIViewController{
 
    let soundManger = SoundManager.shared
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var talkBlockImg: UIImageView!
    @IBOutlet weak var departLineImg: UIImageView!
    
    @IBOutlet weak var howToPlayLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var playLB: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backAtn(){
        soundManger.playSEwith(sound: .SE3_back)
        
        UIView.animate(withDuration: 0.8) {
            self.bgImg.frame.size.height = 0
            self.talkBlockImg.frame.origin.y = self.view.frame.height
            self.departLineImg.frame.size.width = 0
            self.howToPlayLB.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 0, height: 0)
            self.contentLB.frame = self.howToPlayLB.frame
            self.playLB.frame = self.howToPlayLB.frame
//            self.dismissBtn.frame.origin.x = 0
            self.dismissBtn.frame = CGRect(x: 0, y: self.dismissBtn.frame.origin.y, width: 0, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            self.dismiss(animated: false, completion: nil)

        }
    }
    
}
