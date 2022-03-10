import Foundation

class Solution {
    
    class func removeDuplicates(_ nums: inout [Int]) -> Int {
        
        // 1 <= nums.length <= 3 * 10^4
        guard nums.count >= 1 && nums.count <= 3*Int(pow(10 as Double, 4 as Double)) else {
            return 0
        }
        
        var index = 0
        
        for i in 1..<nums.count {

            // -100 <= nums[i] <= 100
            guard nums[i] >= -100 && nums[i] <= 100 else {
                continue
            }
            
            if nums[index] == nums[i] {
                continue
            } else {
                index += 1
                nums[index] = nums[i]
            }
        }
        
        return index+1
    }
}

var arr = [0,0,1,1,1,2,2,3,3,4]
Solution.removeDuplicates(&arr)
