//动画合集

import UIKit
import Foundation
import QuartzCore

private let kScreen: CGRect = UIScreen.main.bounds
let kScreenW: CGFloat = kScreen.size.width
let kScreenH: CGFloat = kScreen.size.height

func frameMath(_ frame: CGFloat) -> CGFloat {
    return frame/375.0*UIScreen.main.bounds.width
}

class AnimationSet: NSObject {
    
    /// 按位渐增
    ///
    /// - Parameters:
    ///   - str: 目标数字
    ///   - animations: 变化后回调
    class func numberAddAnimation(str:NSString, animations: @escaping (_ return_num:String) -> Void) {
        
        var beginAnimation = true
        var dic:[String:String] = [:]
        
        var num_str:String = ""
        for i:Int in 0..<str.length {   //str = 15.33   初始化字典 置为 00.00
            
            let i_str = str.substring(with: NSRange.init(location: i, length: 1))
            
            if i_str == "." {
                num_str += i_str
                dic["\(i)"] = i_str
            } else {
                num_str += "0"
                dic["\(i)"] = "0"
            }
        }
        dic["num"] = num_str            //str = 00.00
        
        for i:Int in 0..<str.length {
            
            let i_string = str.substring(with: NSRange.init(location: i, length: 1))
            
            if i_string != "." && i_string != "0" {
                
                let num_index:Int = NSString.init(string: i_string).integerValue
                
                DispatchQueue.global().async {
                    
                    for j:Int in 0...num_index {
                        
                        usleep(useconds_t(1000.0*1000.0/Double.init(num_index+1)))
                        
                        DispatchQueue.main.async {
                            dic["\(i)"] = "\(j)"
                            num_str = ""
                            
                            for k:Int in 0..<str.length {
                                num_str += dic["\(k)"] ?? "0"
                            }
                            dic["num"] = num_str
                            
                            animations(dic["num"] ?? num_str)
                        }
                    }
                    
                    defer {
                        DispatchQueue.main.async {
                            beginAnimation = false
                            animations(str as String)
                        }
                    }
                }
            }
        }
    }
}

//左右抖一抖动画
extension CAKeyframeAnimation {
    
    /// shake 动画
    ///
    /// - Returns: 左右晃动
    class func newShakeAnimation() -> CAKeyframeAnimation {
        
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init()
        animation.keyPath = "position.x"
        animation.values = [0,-frameMath(12),frameMath(12),-frameMath(12),frameMath(12),-frameMath(12),frameMath(12),0]
        animation.calculationMode = CAAnimationCalculationMode.paced
        animation.duration = 0.8
        animation.isAdditive = true
        
        return animation
    }
}

extension UIProgressView {
    
    /// 进度条从左到右动画
    ///
    /// - Parameters:
    ///   - value: 0 - 1
    ///   - timeInterval: 动画间隔时间
    func leftToRight(_ value:Float, timeInterval:TimeInterval) {
        
        self.setProgress(0.00001, animated: false)
        self.setProgress(0.0, animated: true)
        
        UIView.animate(withDuration: timeInterval) {
            
            self.setProgress(value, animated: true)
        }
    }
}

AnimationSet.numberAddAnimation(str: "153.08") { (text) in
    print("\n\(text)")
}
