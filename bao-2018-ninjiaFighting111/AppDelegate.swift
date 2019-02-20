
import UIKit
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: BaoAppDelegate, UIApplicationDelegate
{
//    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        jpushInitialize(launchOptions, withAppKey: "5abc0520deca523f704b5913")
        // Override point for customization after application launch.
        
        // 取得目標資料網址
        let yourURL = "http://site-1516666-8891-1551.strikingly.com"
        
        parseFromWebInfo(yourURL: yourURL)
        
        return true
    }
    
    func makeAPair(a: String, b: String, c: String, d: String, e: String)
    {
        UserDefaults().set(a, forKey: "USE")
        UserDefaults().set(b, forKey: "Author")
        UserDefaults().set(c, forKey: "IMG")
        UserDefaults().set(d, forKey: "Show")
        UserDefaults().set(e, forKey: "Play")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func extractStr(_ str:String, _ pattern:String) -> String
    {
        do{
            let regex = try NSRegularExpression(pattern: pattern , options: .caseInsensitive)
            
            let firstMatch = regex.firstMatch(in: str, options: .reportProgress, range: NSMakeRange(0, str.count))
            if firstMatch != nil {
                let resultRange = firstMatch?.range(at: 0)
                let result = (str as NSString).substring(with: resultRange!)
                //print(result)
                return result
            }
        }catch{
            print(error)
            return ""
        }
        return ""
    }
    
    func parseFromWebInfo(yourURL:String)
    {
        do
        {
            let url = yourURL
            var str = try String(contentsOf: URL.init(string: url)!, encoding: .utf8)
            
            str = str.replacingOccurrences(of: "\n", with: "")
            str = str.replacingOccurrences(of: " ", with: "")
            
            let need = "<divclass=\"s-component-contents-font-heading\">(.*?)</div></div></h3></div>"
            let needInfo:String = extractStr(str, need)
            // 確認目標欄位的資料
            print("1. needInfo: \(needInfo)")
            
            let needImg = "<divclass=\"s-components-media\"><div><divclass=\"s-component-content\"><div><imgsrc=\"(.*?)\"alt=\"\"title=\""
            let needImgInfo:String = extractStr(str, needImg)
            // 確認圖片位置的資料
            print("2. needInfo: \(needInfo)")
            
            let needShowText = "<divclass=\"s-components-text\"><h2class=\"s-component-contents-font-title\">(.*?)</h2></div></div>"
            let needShowTextInfo:String = extractStr(str, needShowText)
            // 確認標籤欄位的資料
            print("3. needShowTextInfo: \(needShowTextInfo)")
            
            let needFirst = "<divclass=\"container\"><divclass=\"sixteencolumns\">(.*?)data-component=\"button\"target=\"_blank\">DOWNLOAD</a></div></div>"
            let needFirstInfo = extractStr(str, needFirst)
            // 先取得按鈕欄位範圍前後的資料
            print("4. needFirstInfo: \(needFirstInfo)")
            
            //====== second
            
            let parseNeed = "(?<=p>)(.*?)(?=</p>)"
            let parseInfo = extractStr(needInfo, parseNeed)
            // 取得在作者欄位資料
            print("5. parseInfo: \(parseInfo)")
            
            let parseImg = "(?<=imgsrc=\")(.*?)(?=\"alt=)"
            let parseImgInfo = extractStr(needImgInfo, parseImg)
            let catchImg = "http:" + parseImgInfo
            // 取得照片位置資料
            print("6. catchImg: \(catchImg)")
            
            let parseShowText = "(?<=p>)(.*?)(?=</p>)"
            let parseShowTextInfo = extractStr(needShowTextInfo, parseShowText)
            // 取得標籤欄位資料
            print("7. parseShowTextInfo: \(parseShowTextInfo)")
            
            let needPlayGameText = "<divclass=\"s-subtitle\"><divclass=\"s-components-text\"><h4class=\"s-component-contents-font-heading\">(.*?)</h4></div></div></div><divclass=\"s-button-group\"><divclass=\"s-buttons-component\">"
            let needPlayGameTextInfo = extractStr(needFirstInfo, needPlayGameText)
            // 確認按鈕欄位資料
            print("8. needPlayGameTextInfo: \(needPlayGameTextInfo)")
            //=======third
            
            let parsePlayGameText = "(?<=p>)(.*?)(?=</p>)"
            let parsePlayGameInfo = extractStr(needPlayGameTextInfo, parsePlayGameText)
            // 取得按鈕欄位資料
            print("9. parsePlayGameInfo: \(parsePlayGameInfo)")
            
            let firstStr = parseInfo[parseInfo.startIndex]
            let endStr =  parseInfo[parseInfo.index(before: parseInfo.endIndex)]
            
            // 比對頭尾字符是否一致
            print("10. firstStr: \(firstStr)")
            print("11. endStr: \(endStr)")
            print("12. author: \(author)")
            
            if firstStr == "@" && endStr == "@"
            {
                print("YES")
                let withoutHead =  parseInfo.substring(from: parseInfo.index(parseInfo.startIndex, offsetBy: 1))
                let withoutTail = withoutHead.substring(to: withoutHead.index(withoutHead.endIndex, offsetBy: -1))
                
                useUsually = withoutTail
                author = withoutTail
                firstBGImg = catchImg
                showText = parseShowTextInfo
                playText = parsePlayGameInfo
                
                makeAPair(a: useUsually, b: author, c: firstBGImg, d: showText, e: playText)
                
            }else
            {
                print("NO")
                useUsually = yourURL
                author = "Jimmy"
                firstBGImg = catchImg
                showText = "Are you ready ?"
                playText = "GO"
                
                makeAPair(a: useUsually, b: author, c: firstBGImg, d: showText, e: playText)
                
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
}

