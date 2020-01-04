import UIKit

func group<T, H: Hashable>(_ items: [T],_ f: (T) -> H) -> [H : [T]] {
    
    items.reduce([:]) { (ac : [H : [T]], o: T) -> [H : [T]] in
        
        let h = f(o)
        var temp_ac = ac
        
        if var v = ac[h] {
            v.append(o)
            temp_ac.updateValue(v, forKey: h)
        } else {
            temp_ac.updateValue([o], forKey: h)
        }
        return temp_ac
    }
}

print("\(group([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], { $0 % 3 }))")
// [2: [2, 5, 8, 11], 0: [3, 6, 9, 12], 1: [1, 4, 7, 10]]

print("\(group(["Zhangfei", "Liubei", "Guanyu", "Zhangliang", "Liubang", "Zhaoyun"], { $0.first! }))")
// ["Z": ["Zhangfei", "Zhangliang", "Zhaoyun"], "L": ["Liubei", "Liubang"], "G": ["Guanyu"]]

