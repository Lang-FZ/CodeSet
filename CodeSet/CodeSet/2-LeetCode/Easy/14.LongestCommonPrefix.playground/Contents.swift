import Foundation

class Solution {

    class func longestCommonPrefix(_ strs: [String]) -> String {
    
        // 1 <= strs.length <= 200
        guard strs.count >= 1 && strs.count <= 200 else {
            return ""
        }
        
        var minLength = 0

        for string in strs {

            // 0 < strs[i].length <= 200
            guard string.count > 0 && string.count <= 200 else {
                return ""
            }

            // strs[i]仅由小写英文字母组成。
            var cs:CharacterSet?
            cs = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz").inverted
            let filtered:String = string.components(separatedBy: cs!).joined(separator: "")
            if filtered != string {
                return ""
            }

            if minLength == 0 {

                minLength = string.count

            } else {

                if string.count < minLength {
                    minLength = string.count
                }
            }
        }

        var commonPrefix = ""

        guard minLength >= 1 else {
            return ""
        }
        
        for i in 1...minLength {

            var tempPrefix = ""

            tempPrefix = NSString(string: strs.first ?? "").substring(to: i)

            for item in strs {

                if NSString(string: item).substring(to: i) != tempPrefix {

                    tempPrefix = ""
                    break
                }
            }

            if tempPrefix.count == i {
                commonPrefix = tempPrefix
            } else {
                if i == 1 {
                    return ""
                } else {
                    return commonPrefix
                }
            }
        }
        
        return commonPrefix
    }
}

Solution.longestCommonPrefix(["", "b"])
