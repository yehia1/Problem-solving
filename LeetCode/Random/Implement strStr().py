'''
Given two strings needle and haystack, return the index of the first occurrence of needle in haystack,
or -1 if needle is not part of haystack.
'''

class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        return haystack.find(needle)

#another soluton
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        length = len(needle)
        flag = 0
        for i in range(len(haystack)):
            for j in range(length):
                flag = 0
                if(i + j == len(haystack)):
                    flag = 1
                    break
                if(haystack[i+j] != needle[j]):
                    flag = 1
                    break
            if(flag == 0):
                return i
        return -1
        
        