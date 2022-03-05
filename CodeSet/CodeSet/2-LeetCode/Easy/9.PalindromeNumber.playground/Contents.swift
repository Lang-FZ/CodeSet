import Foundation

class Solution {
    
    class func isPalindrome(_ x: Int) -> Bool {
        
        guard x >= -Int(pow(2 as Double, 31 as Double)) && x <= (Int(pow(2 as Double, 31 as Double))-1) else {
            return false
        }
        
        
        /* NSString 1
         
        let num = NSString(string: "\(x)")
        
        var left = ""
        var right = ""
        
        if num.length % 2 == 0 {
            
            left = num.substring(to: num.length / 2)
            right = num.substring(from: num.length / 2)
            
        } else {
            
            left = num.substring(to: (num.length+1) / 2)
            right = num.substring(from: (num.length-1) / 2)
        }
        
        if left == String(right.reversed()) {
            return true
        } else {
            return false
        }*/
        
        
        
        /* NSString 2
         
        let num = "\(x)"
        var num_reversed = ""
        
        for char in "\(x)".reversed() {
            num_reversed.append(char)
        }
        
        if num == num_reversed {
            return true
        } else {
            return false
        }*/
        
        
        
        /* Int */
        
        var y = x
        var reverse = 0
        
        while y >= 1 {
            
            let pop = y % 10
            y /= 10
            
            reverse = reverse * 10 + pop
        }
        
        if x == reverse {
            return true
        } else {
            return false
        }
    }
}

Solution.isPalindrome(-1234321)
