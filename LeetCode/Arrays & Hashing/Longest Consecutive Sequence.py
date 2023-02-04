# https://leetcode.com/problems/longest-consecutive-sequence/description/

'''
Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence.

You must write an algorithm that runs in O(n) time.
'''
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        numSet = set(nums)
        longest = 0

        for i in numSet :
            if (i - 1 not in numSet):
                length = 1
                while(i+length) in numSet :
                    length+=1
                longest = max(length,longest)
        return longest
        