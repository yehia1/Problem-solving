# https://leetcode.com/explore/learn/card/array-and-string/204/conclusion/1164/
'''
Given an input string s, reverse the order of the words.

A word is defined as a sequence of non-space characters.
The words in s will be separated by at least one space.

Return a string of the words in reverse order concatenated by a single space.

Note that s may contain leading or trailing spaces or multiple spaces between two words.
The returned string should only have a single space separating the words. Do not include any extra spaces.
'''
class Solution:
    def reverseWords(self, s: str) -> str:
        s = ' '.join(s.split())
        x = []
        j = len(list(s))
        for i in range(len(list(s))-1,-1,-1):
            if s[i] == ' ':
                x.append(s[i+1:j])
                j = i 
        x.append(s[i:j])
        print(x)
        return ' '.join(x)
        