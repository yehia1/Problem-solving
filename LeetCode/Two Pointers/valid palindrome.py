#https://leetcode.com/problems/valid-palindrome/description/

'''
A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string s, return true if it is a palindrome, or false otherwise.
'''

class Solution:
    def isPalindrome(self, s: str) -> bool:
        st = ''
        for i in s :
            if i.isalnum():
                st += i.lower()
        left = 0 
        right = len(list(st)) - 1
        while(right > left):
            if(st[left] != st[right]):
                return False
            else : 
                left +=1
                right -=1
        return True