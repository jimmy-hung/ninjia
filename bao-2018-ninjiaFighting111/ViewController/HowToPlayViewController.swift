
import UIKit

class HowToPlayViewController: UIViewController
{
 
    let soundManger = SoundManager.shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
