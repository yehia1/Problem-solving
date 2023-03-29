
'''
You are given an integer array nums where the largest integer is unique.

Determine whether the largest element in the array is at least twice as much as every other number in the array.
If it is, return the index of the largest element, or return -1 otherwise.

'''

class Solution:
    def dominantIndex(self, nums: List[int]) -> int:
        index = nums.index(max(nums))
        mx = nums.pop(index)
        if(mx >= 2 * max(nums)):
            return index
        return -1