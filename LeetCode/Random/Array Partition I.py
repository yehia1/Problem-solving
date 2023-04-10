#https://leetcode.com/problems/array-partition/
'''
Given an integer array nums of 2n integers, group these integers into n pairs (a1, b1), (a2, b2), ..., (an, bn)
such that the sum of min(ai, bi) for all i is maximized. Return the maximized sum.


'''
class Solution:
    def arrayPairSum(self, nums: List[int]) -> int:
        sums = 0
        nums.sort()
        for i in range(0,len(nums),2):
            sums += nums[i]
            
        return sums