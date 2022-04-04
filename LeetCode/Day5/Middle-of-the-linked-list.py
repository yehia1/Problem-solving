#  leet code problems
# https://leetcode.com/problems/middle-of-the-linked-list/submissions/


class Solution:
    def middleNode(self, head: Optional[ListNode]) -> Optional[ListNode]:
            head1 = head
            head2 = head
            
            while (head1 and head1.next)  : 
                head1 = head1.next.next
                head2 = head2.next
            # print(head2)
            return head2