# -*- coding: utf-8 -*-
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        
        length = len(list(s))
        sol = {}
        if length == 1 :
            return 1    
        i = 0
        j = 0
        result = 0
        while(i < length):
            if (s[i] not in sol):
                sol[s[i]] = i
                result = max(result,i-j+1)
            else : 
                del_index = j
                j = sol[s[i]] + 1 
                for k in range(del_index,j):
                    del sol[s[k]]
                i = i - 1
            i+=1 
        
        return result    