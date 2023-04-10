-- https://leetcode.com/problems/longest-common-prefix/description/

'''
Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".

'''

class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        temp = ''
        dict = {}
        for i in range(len(min(strs))):
            for j in strs[1:]:
                if strs[0][i] != j[i]:
                    return temp
            temp += strs[0][i]
        return temp
            
            