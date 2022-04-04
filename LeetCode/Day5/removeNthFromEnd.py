# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next

class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        pointer = ListNode(-1, head)
        len_list = 0

        while head:
            head = head.next
            len_list += 1
        
        node_n = len_list-n
        head = pointer.next

        if node_n == 0:
            return head.next
        
        while node_n > 0:
            pointer = pointer.next
            node_n -= 1
        
        pointer.next = pointer.next.next

        return head
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        head1 = head
        list1 = [] 
        
        while(head1):
            list1.append(head1.val)
            head1= head1.next
        
        
        
        head1 = head
        
        if (head1 is not None):
            if (head1.val == list1[-n]):
                head2 = head1.next
                head1 = None
                return head2
        
        
        while (head1 is not None):
            if head1.val == list1[-n]:
                break
            head2 = head1
            head1 = head1.next
            
        head2.next = head1.next
        head2 = head
    
        return head2
         
        
        
        
                
                  
        