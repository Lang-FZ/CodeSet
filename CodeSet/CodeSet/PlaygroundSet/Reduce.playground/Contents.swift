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

//print("\(group([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], { $0 % 3 }))")
// [2: [2, 5, 8, 11], 0: [3, 6, 9, 12], 1: [1, 4, 7, 10]]

//首字母排序
print("\(group(["Zhangfei", "Liubei", "Guanyu", "Zhangliang", "Liubang", "Zhaoyun"], { $0.first! }))")
// ["Z": ["Zhangfei", "Zhangliang", "Zhaoyun"], "L": ["Liubei", "Liubang"], "G": ["Guanyu"]]


/*
struct Student {
  let name: String
  let scores: [科目: Int]
}

enum 科目: String, CaseIterable {
  case 语文, 数学, 英语, 物理
}

let s1 = Student(
    name: "Jane",
    scores: [.语文: 86, .数学: 92, .英语: 73, .物理: 88]
)
let s2 = Student(
    name: "Tom",
    scores: [.语文: 99, .数学: 52, .英语: 97, .物理: 36]
)
let s3 = Student(
    name: "Emma",
    scores: [.语文: 91, .数学: 92, .英语: 100, .物理: 99]
)
    
let students = [s1, s2, s3]

//计算所有学生的语文成绩平均分
let num = students.reduce(0) { ($0 + ($1.scores[.语文] ?? 0)) } / students.count
print(num)

//统计各个科目的及格率 (60 分以上及格)，并将及格率结果进行排序
let subject = students.reduce([科目:Double]()) { (accumulator, student) -> [科目:Double] in
    var temp_ac = accumulator
    student.scores.keys.forEach { (subject) in
        if student.scores[subject] ?? 0 > 60 {
            if var temp_sub = accumulator[subject] {
                temp_sub += 1.0
                temp_ac.updateValue(temp_sub, forKey: subject)
            } else {
                temp_ac.updateValue(1.0, forKey: subject)
            }
        }
    }
    return temp_ac
}.map({ ($0, $1 / Double(students.count)) }).sorted(by: { return $0.1 > $1.1 })
print(subject)
*/
