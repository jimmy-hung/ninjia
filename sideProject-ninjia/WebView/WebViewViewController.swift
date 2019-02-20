
import UIKit
import WebKit
import KKTouchPoints
  
class WebViewViewController: UIViewController
{
//    var webView: WKWebView!
    @IBOutlet weak var webView: WKWebView!
    
    // 加入timer & progress
    public var timer: Timer!
    public var progressView: UIProgressView!
    
    var touchPoints: TouchPointView!
    var currentPosition = CGPoint.zero

    // 簽協定判斷 progress 加入監聽
    public func setup()
    {
//        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//        view.addSubview(webView)
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //http://site-1516666-8891-1551.strikingly.com
        //https://m.jcnqapp.bet365app123456.com?token=jg9no2rcynn
        let url = URL(string: useUsually)
        var request = URLRequest(url: url!)
        request.cachePolicy = .returnCacheDataElseLoad
        webView.load(request)

        self.progressView = UIProgressView()
        progressView.tintColor = .red
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup()
        
        UseswipeGesture()
        addLongPressGesture()
        
        webView.frame = self.view.frame
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
//        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true

        
        self.webView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        progressView.progressTintColor = UIColor(red: 22/255, green: 249/255, blue: 32/255, alpha: 1.0)
        
        if currentPosition == .zero{
            //First entry.
            touchPoints = TouchPointView(frame: CGRect(x: view.frame.width - 150, y: view.frame.height / 3, width: view.frame.width / 8, height: view.frame.width / 8))
        } else {
            touchPoints.frame = CGRect(x: currentPosition.x, y: currentPosition.y, width: view.frame.width / 8 , height: view.frame.width / 8)
        }
        touchPoints.delegate = self
        touchPoints.superViewController = self
        touchPoints.setupPoints(number: 6,
                                pointsTitles: ["后退", "清除\n缓存", "首页", "刷新", "前进", "返回"],
                                pointColor: UIColor.gray.withAlphaComponent(0.7),
                                buttonsColor: .darkGray)
        touchPoints.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: timer for progress
    @objc func timerCallBack() {
        if progressView.progress >= 1 {
            progressView.isHidden = true
            timer.invalidate()
        } else if progressView.progress <= 0.75 {
            progressView.progress += 0.05
        } else if progressView.progress > 0.75 {
            progressView.progress += 0.005
        }
    }

    // 重寫 self 的 kvo 方法
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "estimatedProgress")
        {
            //progress是UIProgressView
            progressView.isHidden = webView.estimatedProgress==1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    // MARK: - Swipe Gesture
    func UseswipeGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(recognizer:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(recognizer:)))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        webView.addGestureRecognizer(swipeLeft)
        webView.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeGesture(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .left{
            webView.goForward()
        } else {
            webView.goBack()
        }
    }
    
    // add func
    func prepareToCleanCache(completion : @escaping () -> Void) {
        let alertController = UIAlertController(title: "确定要清除缓存", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView.center = CGPoint(x: self.webView.center.x, y: self.webView.center.y - 80)
            imageView.image = UIImage(named: "complete", in: Bundle(for: type(of: self)), compatibleWith: nil)
            imageView.alpha = 0.8
            self.webView.addSubview(imageView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    imageView.alpha = 0
                }, completion: { (god) in
                    imageView.removeFromSuperview()
                    completion()
                })
            })
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - download Image
    func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gestureRecognizer:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.webView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPress(gestureRecognizer : UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        // get image point
        let touchPoint = gestureRecognizer.location(in: self.webView)
        
        // image url
        let js = String(format: "document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y)
        //        guard let urlString = webView.stringByEvaluatingJavaScript(from: js) else { return }
        
        var urlString:String!
        
        webView.evaluateJavaScript(js) { (anyThing, error) in
            urlString = anyThing as! String
            self.qrCodeCheck(urlString: urlString) { (qrCode) in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "储存影像", style: .default) { (action) in
                    self.saveImage(image: qrCode)
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alertController.addAction(alertAction)
                alertController.addAction(cancelAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    private func qrCodeCheck(urlString : String, completion : @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let downloadTask = urlSession.downloadTask(with: request) { (url, response, error) in
            if error != nil {
                // show error
                self.showResultAlert(error: error)
                return
            }
            
            guard let url = url else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: imageData) else { return }
            guard let ciImage = CIImage(image:image) else { return }
            let context = CIContext(options: nil)
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context,
                                      options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            guard let features = detector?.features(in: ciImage) else { return }
            if features.count > 0 {
                completion(image)
            }
        }
        downloadTask.resume()
    }
    
    private func saveImage(image : UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func showResultAlert(error : Error?) {
        let title = (error == nil) ? "储存成功" : "储存失败"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : UnsafeRawPointer) {
        showResultAlert(error: error)
    }
    
}

// UIWebViewDelegate
extension WebViewViewController: WKUIDelegate, WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        webView.isHidden = false
        progressView.progress = 1.0
        progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        progressView.progress = 0.0
        progressView.isHidden = false
    }

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        progressView.progress = 0.0
        progressView.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
        guard let url = request.url else {
            return false
        }
        if url.scheme != "http" && url.scheme != "https" {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return true
    }
    
    
    func isJumpToExternalApp(with URL: URL?) -> Bool
    {
        let validSchemes = Set<AnyHashable>(["http", "https"])
        
        return !validSchemes.contains(URL?.scheme ?? "")
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if isJumpToExternalApp(with: navigationAction.request.url)
        {
            if let anURL = navigationAction.request.url
            {
                UIApplication.shared.openURL(anURL)
            }
            decisionHandler(WKNavigationActionPolicy.allow)
            
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
       
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WebViewViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension WebViewViewController: TouchPointViewDelegates{
    
    public func currentLocation(currentPoint: CGPoint) {
        self.currentPosition = currentPoint
    }
    
    public func emptyFunction1() {
        webView.goBack()
    }
    
    public func emptyFunction2() {
        prepareToCleanCache {
            URLCache.shared.removeAllCachedResponses()
            self.webView.reload()
        }
    }
    
    public func emptyFunction3() {
        if let url = URL(string: useUsually) {
            let myRequest = URLRequest(url: url)
            //            webView.load(myRequest)
            webView.load(myRequest)
        }
    }
    
    public func emptyFunction4() {
        webView.reload()
    }
    
    public func emptyFunction5() {
        webView.goForward()
    }
    
    public func emptyFunction6() {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
    }
}
