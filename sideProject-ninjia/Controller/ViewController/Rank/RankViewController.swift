
import UIKit

class RankViewController: UIViewController{
    
    @IBOutlet weak var scoreTableView: UITableView!
    
    let userDefault = UserDefaults.standard
    var listAry = [Int]()
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        scoreTableView.dataSource = self
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        listAry = []
        if userDefault.array(forKey: "scoreList") as? [Int] != nil
        {
            listAry = userDefault.array(forKey: "scoreList") as! [Int]
        }else{
            listAry = [0,0]
        }
        scoreTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAtn(){
        dismiss(animated: true, completion: nil)
    }
}

extension RankViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("listAry: \(listAry)")
        let myCell = scoreTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ScoreTableCell
        
        if indexPath.row == 0 {
            myCell.textLabel?.text = "Top \(indexPath.row + 1)"
        }else {
            myCell.textLabel?.text = "No. \(indexPath.row + 1)"
        }
        myCell.detailTextLabel?.text = "\(listAry[indexPath.row])"
        return myCell
    }
}
