class LeetCode {
    
    class func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        var dic:[Int:Int] = [:]
        for index:Int in 0..<nums.count {
            
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
