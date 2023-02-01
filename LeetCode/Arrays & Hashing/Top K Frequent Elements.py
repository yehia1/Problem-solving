#https://leetcode.com/problems/top-k-frequent-elements/description/

'''
Given an integer array nums and an integer k, return the k most frequent elements.
 You may return the answer in any order. 
'''

class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        dict1 = {}
        result = []
        for i in nums : 
            dict1[i] = 1 + dict1.get(i,0)

        dict1 = sorted(dict1.items(),key=lambda x:x[1], reverse = True)
        
        for i in range(k):
            result.append(dict1[i][0])

        return result