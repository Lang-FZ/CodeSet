import Foundation

class Solution {
    
    class func romanToInt(_ s: String) -> Int {
        
        // 1 <= s.length <= 15
        guard s.count >= 1 && s.count <= 15 else {
            return 0
        }
        
        // s仅包含字符('I', 'V', 'X', 'L', 'C', 'D', 'M')。
        var cs:CharacterSet?
        cs = CharacterSet(charactersIn: "IVXLCDM").inverted
        let filtered:String = s.components(separatedBy: cs!).joined(separator: "")
        if filtered != s {
            return 0
        }
        
        var currentIndex = 0
        var currentNum = 0
        var currentDecimal = 0
        var tempStr = NSString(string: s)
        
        while currentIndex < s.count {
            
            var top3 = ""
            if tempStr.length >= 3 {
                top3 = tempStr.substring(to: 3)
            }
            var top2 = ""
            if tempStr.length >= 2 {
                top2 = tempStr.substring(to: 2)
            }
            var top1 = ""
            if tempStr.length >= 1 {
                top1 = tempStr.substring(to: 1)
            }
            
            if top2 != "" && (top2 == "IV" || top2 == "IX" || top2 == "XL" || top2 == "XC" || top2 == "CD" || top2 == "CM") {
                
                // 有效
                if top2 == "IV" {
                    if currentDecimal == 0 || currentDecimal >= 10 {
                        currentNum += 4
                        currentDecimal = 1
                    } else {
                        return 0
                    }
                } else if top2 == "IX" {
                    if currentDecimal == 0 || currentDecimal >= 10 {
                        currentNum += 9
                        currentDecimal = 1
                    } else {
                        return 0
                    }
                } else if top2 == "XL" {
                    if currentDecimal == 0 || currentDecimal >= 100 {
                        currentNum += 40
                        currentDecimal = 10
                    } else {
                        return 0
                    }
                } else if top2 == "XC" {
                    if currentDecimal == 0 || currentDecimal >= 100 {
                        currentNum += 90
                        currentDecimal = 10
                    } else {
                        return 0
                    }
                } else if top2 == "CD" {
                    if currentDecimal == 0 || currentDecimal >= 1000 {
                        currentNum += 400
                        currentDecimal = 100
                    } else {
                        return 0
                    }
                } else if top2 == "CM" {
                    if currentDecimal == 0 || currentDecimal >= 1000 {
                        currentNum += 900
                        currentDecimal = 100
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
                
                tempStr = NSString(string: tempStr.substring(from: 2))
                currentIndex += 2
                
            } else if top1 != "" && (top1 == "V" || top1 == "L" || top1 == "D") {
                
                // 有效
                if top1 == "V" {
                    if currentDecimal == 0 || currentDecimal >= 10 {
                        currentNum += 5
                        currentDecimal = 1
                    } else {
                        return 0
                    }
                } else if top1 == "L" {
                    if currentDecimal == 0 || currentDecimal >= 100 {
                        currentNum += 50
                        currentDecimal = 10
                    } else {
                        return 0
                    }
                } else if top1 == "D" {
                    if currentDecimal == 0 || currentDecimal >= 1000 {
                        currentNum += 500
                        currentDecimal = 100
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
                
                tempStr = NSString(string: tempStr.substring(from: 1))
                currentIndex += 1
                
            } else if top1 != "" && (top1 == "I" || top1 == "X" || top1 == "C" || top1 == "M") {
                
                // 有效
                if top1 == "I" {
                    
                    if top3 != "" && top3 == "III" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 10) || (currentDecimal == 1 && currentNum % 5 == 0) {
                            
                            currentDecimal = 1
                            currentNum += 3
                            currentIndex += 3
                            tempStr = NSString(string: tempStr.substring(from: 3))
                            
                        } else {
                            return 0
                        }
                    } else if top2 != "" && top2 == "II" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 10) || (currentDecimal == 1 && currentNum % 5 == 0) {
                            
                            currentDecimal = 1
                            currentNum += 2
                            currentIndex += 2
                            tempStr = NSString(string: tempStr.substring(from: 2))
                            
                        } else {
                            return 0
                        }
                    } else {
                        
                        if (currentDecimal == 0 || currentDecimal >= 10) || (currentDecimal == 1 && currentNum % 5 == 0) {
                            
                            currentDecimal = 1
                            currentNum += 1
                            currentIndex += 1
                            tempStr = NSString(string: tempStr.substring(from: 1))
                            
                        } else {
                            return 0
                        }
                    }
                } else if top1 == "X" {
                    
                    if top3 != "" && top3 == "XXX" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 100) || (currentDecimal == 10 && currentNum % 50 == 0) {
                            
                            currentDecimal = 10
                            currentNum += 30
                            currentIndex += 3
                            tempStr = NSString(string: tempStr.substring(from: 3))
                            
                        } else {
                            return 0
                        }
                    } else if top2 != "" && top2 == "XX" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 100) || (currentDecimal == 10 && currentNum % 50 == 0) {
                            
                            currentDecimal = 10
                            currentNum += 20
                            currentIndex += 2
                            tempStr = NSString(string: tempStr.substring(from: 2))
                            
                        } else {
                            return 0
                        }
                    } else {
                        
                        if (currentDecimal == 0 || currentDecimal >= 100) || (currentDecimal == 10 && currentNum % 50 == 0) {
                            
                            currentDecimal = 10
                            currentNum += 10
                            currentIndex += 1
                            tempStr = NSString(string: tempStr.substring(from: 1))
                            
                        } else {
                            return 0
                        }
                    }
                } else if top1 == "C" {
                    
                    if top3 != "" && top3 == "CCC" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 1000) || (currentDecimal == 100 && currentNum % 500 == 0) {
                            
                            currentDecimal = 100
                            currentNum += 300
                            currentIndex += 3
                            tempStr = NSString(string: tempStr.substring(from: 3))
                            
                        } else {
                            return 0
                        }
                    } else if top2 != "" && top2 == "CC" {
                        
                        if (currentDecimal == 0 || currentDecimal >= 1000) || (currentDecimal == 100 && currentNum % 500 == 0) {
                            
                            currentDecimal = 100
                            currentNum += 200
                            currentIndex += 2
                            tempStr = NSString(string: tempStr.substring(from: 2))
                            
                        } else {
                            return 0
                        }
                    } else {
                        
                        if (currentDecimal == 0 || currentDecimal >= 1000) || (currentDecimal == 100 && currentNum % 500 == 0) {
                            
                            currentDecimal = 100
                            currentNum += 100
                            currentIndex += 1
                            tempStr = NSString(string: tempStr.substring(from: 1))
                            
                        } else {
                            return 0
                        }
                    }
                } else if top1 == "M" {
                    
                    if top3 != "" && top3 == "MMM" {
                        
                        if currentDecimal == 0 {
                            
                            currentDecimal = 1000
                            currentNum += 3000
                            currentIndex += 3
                            tempStr = NSString(string: tempStr.substring(from: 3))
                            
                        } else {
                            return 0
                        }
                    } else if top2 != "" && top2 == "MM" {
                        
                        if currentDecimal == 0 {
                            
                            currentDecimal = 1000
                            currentNum += 2000
                            currentIndex += 2
                            tempStr = NSString(string: tempStr.substring(from: 2))
                            
                        } else {
                            return 0
                        }
                    } else {
                        
                        if currentDecimal == 0 {
                            
                            currentDecimal = 1000
                            currentNum += 1000
                            currentIndex += 1
                            tempStr = NSString(string: tempStr.substring(from: 1))
                            
                        } else {
                            return 0
                        }
                    }
                }
            } else {
                
                return 0
            }
        }
        
        // [1, 3999]
        guard currentNum >= 1 && currentNum <= 3999 else {
            return 0
        }
        
        return currentNum
    }
}

Solution.romanToInt("LVIII")
