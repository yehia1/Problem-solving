# leet code problems
#https://leetcode.com/problems/reverse-string/submissions/


class Solution:
    def reverseString(self, s: List[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """
        list1 = []
        list1 = list(reversed(s))
        for i in range(len(list1)):
            s[i] = list1[i]
        
    def reverseString(self, s: List[str]) -> None:
        l = 0 
        r = len(s) - 1
        while(r > l):
            temp = s[r]
            s[r] = s[l]
            s[l] = temp
            r-=1
            l+=1
