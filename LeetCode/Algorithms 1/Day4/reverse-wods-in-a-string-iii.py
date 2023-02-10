# leet code problems
#https://leetcode.com/problems/reverse-words-in-a-string-iii/submissions/

class Solution:
    def reverseWords(self, s: str) -> str:
        result = []
        s = s.split()
        for i in range(len(s)):
            s[i] = list(reversed(s[i]))
            result.append(''.join(s[i]))
            
        return (' '.join(result))