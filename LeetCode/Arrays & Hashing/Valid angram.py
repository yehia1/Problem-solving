# https://leetcode.com/problems/valid-anagram/description/

'''
Given two strings s and t, return true if t is an anagram of s, and false otherwise.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase,
typically using all the original letters exactly once.
'''
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if(len(s) != len(t)):
            return False

        dict1 ,dict2 = {},{}

        for i in range(len(s)):
            dict1[s[i]] = 1 + dict1.get(s[i],0)
            dict2[t[i]] = 1 + dict2.get(t[i],0)

        for i in dict1 : 
            if (dict1[i] != dict2.get(i,0)):
                return False
        
        return True