# https://leetcode.com/problems/longest-repeating-character-replacement/description/

'''
You are given a string s and an integer k. You can choose any character of the string and change it to any other uppercase English character.
You can perform this operation at most k times.

Return the length of the longest substring containing the same letter you can get after performing the above operations.

'''

class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        dict1 = {}
        a_pointer = 0
        b_pointer = 0
        res = 0
        while(b_pointer < len(s)):
            if s[b_pointer] not in dict1 :
                dict1[s[b_pointer]] = 1
            else :
                dict1[s[b_pointer]] +=1

            if((b_pointer-a_pointer + 1) - max(dict1.values()) > k):
                dict1[s[a_pointer]] -= 1
                a_pointer +=1
                  
            res = max(res,(b_pointer-a_pointer + 1))
            b_pointer +=1
                

        return res