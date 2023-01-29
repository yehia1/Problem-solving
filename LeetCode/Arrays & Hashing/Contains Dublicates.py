# https://leetcode.com/problems/contains-duplicate/solutions/
'''
Given an integer array nums, return true if any value appears at least twice in the array, 
and return false if every element is distinct.
'''
class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        set1 = set(nums)
        if(len(nums) > len(set1) ):
            return True
        else :
            return False
    