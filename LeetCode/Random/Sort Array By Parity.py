# https://leetcode.com/explore/learn/card/fun-with-arrays/511/in-place-operations/3260/

'''
Given an integer array nums,
move all the even integers at the beginning of the array followed by all the odd integers.

'''
class Solution:
    def sortArrayByParity(self, nums: List[int]) -> List[int]:
        return [i for i in nums if not i % 2] + [i for i in nums if i % 2]