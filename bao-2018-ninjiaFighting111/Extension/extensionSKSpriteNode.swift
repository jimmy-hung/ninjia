

import SpriteKit

let NumberKey = "number"
extension SKSpriteNode  
{
    var addNumber : Int?
    {
        get
        {
            return userData?.value(forKey: NumberKey) as? Int
        }
        set(newValue)
        {
            if userData == nil
            {
                userData = NSMutableDictionary()
            }
            userData?.setValue(newValue, forKey: NumberKey)
        }
    }
    
    func addGlow(radius: Float = 30)
    {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}
