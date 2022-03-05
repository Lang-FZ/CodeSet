import Foundation

class LeetCode {
    
    class func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        guard nums.count >= 2 && nums.count <= Int(pow(10 as Double, 4 as Double)) else {
            return []
        }
        guard target >= -Int(pow(10 as Double, 9 as Double)) && target <= Int(pow(10 as Double, 9 as Double)) else {
            return []
        }
        
        var dic: [Int : Int] = [:]
        for index in 0..<nums.count {
            
            guard nums[index] >= -Int(pow(10 as Double, 9 as Double)) && nums[index] <= Int(pow(10 as Double, 9 as Double)) else {
                return []
            }
            
            if let target_con = dic[target - nums[index]],
                target_con != index {
                
                return [target_con,index]
            }
            dic[nums[index]] = index
        }
        return []
    }
}

LeetCode.twoSum([3,2,4], 6)
