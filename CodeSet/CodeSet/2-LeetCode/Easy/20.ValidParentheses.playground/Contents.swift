import Foundation

class Solution {
    
    class func isValid(_ s: String) -> Bool {
    
        // 1 <= s.length <= 104
        guard s.count >= 1 && s.count <= Int(pow(10 as Double, 4 as Double)) else {
            return false
        }
        
        guard s.count % 2 == 0 else {
            return false
        }
        
        enum StringType: String {
            
            case littleLeft     = "("
            case middleLeft     = "["
            case bigLeft        = "{"
            
            case littleRight    = ")"
            case middleRight    = "]"
            case bigRight       = "}"
            
            case none
            
            static func getType(_ str: String) -> StringType {
                
                if str == StringType.littleLeft.rawValue {
                    return .littleLeft
                } else if str == StringType.middleLeft.rawValue {
                    return .middleLeft
                } else if str == StringType.bigLeft.rawValue {
                    return .bigLeft
                } else {
                    return .none
                }
            }
        }
        
        var tempArr: [StringType] = []
        
        for char in s {
            
            let str = String(char)
            
            if str == StringType.littleLeft.rawValue || str == StringType.middleLeft.rawValue || str == StringType.bigLeft.rawValue {
                
                tempArr.append(StringType.getType(str))
                
            } else {
                
                if ((tempArr.last ?? .none) == .littleLeft) && (str == StringType.littleRight.rawValue) {
                    tempArr.removeLast()
                } else if ((tempArr.last ?? .none) == .middleLeft) && (str == StringType.middleRight.rawValue) {
                    tempArr.removeLast()
                } else if ((tempArr.last ?? .none) == .bigLeft) && (str == StringType.bigRight.rawValue) {
                    tempArr.removeLast()
                } else {
                    return false
                }
            }
        }
        
        return (tempArr.count == 0)
    }
}

Solution.isValid("([}}])")
