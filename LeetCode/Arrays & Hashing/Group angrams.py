#https://leetcode.com/problems/group-anagrams/description/

'''
Given an array of strings strs, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase,
 typically using all the original letters exactly once.

'''

class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        dict1 = {}
       
        for word in strs : 
            word_list = list(word)
            word_list.sort()
        
            curr_word = ''.join(word_list)

            if curr_word in dict1:
                dict1[curr_word].append(word)
            else :
                dict1[curr_word] = [word]

        result = []
        for i in dict1:
            result.append(dict1[i])
        
        return result
