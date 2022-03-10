import Foundation

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */

public class ListNode {
    
    public var val: Int
    public var next: ListNode?
    
    public init() {
        self.val = 0
        self.next = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

class Solution {
    
    class func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        
        let head = ListNode(0)
        var next = head
        
        var temp_list1 = list1
        var temp_list2 = list2
        
        while (temp_list1 != nil) || (temp_list2 != nil) {
            
            if temp_list1 != nil && temp_list2 != nil {
                
                if (temp_list1?.val ?? 0) <= (temp_list2?.val ?? 0) {
                    next.next = ListNode(temp_list1?.val ?? 0)
                    temp_list1 = temp_list1?.next
                } else {
                    next.next = ListNode(temp_list2?.val ?? 0)
                    temp_list2 = temp_list2?.next
                }
            } else if temp_list1 != nil {
                
                next.next = ListNode(temp_list1?.val ?? 0)
                temp_list1 = temp_list1?.next
                
            } else if temp_list2 != nil {
                
                next.next = ListNode(temp_list2?.val ?? 0)
                temp_list2 = temp_list2?.next
                
            }
            
            if next.next != nil {
                next = next.next ?? ListNode(0)
            }
        }
        
        return head.next
    }
}

let list1_3 = ListNode(4)
let list1_2 = ListNode(2, list1_3)
let list1 = ListNode(1, list1_2)

let list2_3 = ListNode(4)
let list2_2 = ListNode(3, list2_3)
let list2 = ListNode(1, list2_2)

Solution.mergeTwoLists(list1, list2)
