# https://leetcode.com/problems/reorder-list/description/

'''
You are given the head of a singly linked-list. The list can be represented as:

L0 → L1 → … → Ln - 1 → Ln
Reorder the list to be on the following form:

L0 → Ln → L1 → Ln - 1 → L2 → Ln - 2 → …
You may not modify the values in the list's nodes. Only nodes themselves may be changed.

'''


# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def reorderList(self, head: Optional[ListNode]) -> None:
        """
        Do not return anything, modify head in-place instead.
        """
        head1 = head.next
        head2 = head
        while(head1 and head1.next):
            head1 = head1.next.next
            head2 = head2.next
        
        curr = head2.next
        prev = head2.next = None
        while(curr):
            _next = curr.next
            curr.next = prev
            prev = curr
            curr = _next

        first, second = head, prev
        while second:
            tmp1, tmp2 = first.next, second.next
            first.next = second
            second.next = tmp1
            first, second = tmp1, tmp2
