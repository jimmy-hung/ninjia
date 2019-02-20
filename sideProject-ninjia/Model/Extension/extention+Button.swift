


import UIKit


extension UIButton {
    
    func pulsate(sender: UIButton, repeatIs:Float) {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = repeatIs // 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        sender.layer.add(pulse, forKey: "transform.scale")
//        layer.add(pulse, forKey: "pulse")
    }
    
    func flash(sender: UIButton, repeatIs: Float) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = repeatIs  // 2
        
        sender.layer.add(flash, forKey: "opacity")
//        layer.add(flash, forKey: nil)
    }
    
    func shake(){
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2  
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
