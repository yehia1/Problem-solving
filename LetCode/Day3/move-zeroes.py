# leet code problems
#https://leetcode.com/problems/move-zeroes/submissions/

class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        list1 = []
        for i in range(len(nums)-1,-1,-1):
            if(nums[i] == 0):
                nums.append(nums.pop(i))
