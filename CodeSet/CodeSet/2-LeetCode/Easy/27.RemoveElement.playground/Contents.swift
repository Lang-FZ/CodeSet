import Foundation

class Solution {
    
    class func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        
        // 0 <= val <= 100
        guard val >= 0 && val <= 100 else {
            return 0
        }
        
        // 0 <= nums.length <= 100
        guard nums.count <= 100 else {
            return 0
        }
        
        var index = 0
        
        for i in 0..<nums.count {
            
            // 0 <= nums[i] <= 50
            guard nums[i] >= 0 && nums[i] <= 50 else {
                return 0
            }
            
            if nums[i] != val {
                nums[index] = nums[i]
                index += 1
            }
        }
        
        return index
    }
}

//var arr = [0,1,2,2,3,0,4,2]
//Solution.removeElement(&arr, 2)

let str = "fasdghjmjehrtea"
let test = "dgh"
let arr = str.enumerated().compactMap({ $0.element })

print(String(arr[5...(5+test.count-1)]))
