# https://leetcode.com/problems/3sum/description/

'''
Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

Notice that the solution set must not contain duplicate triplets.

 
'''

class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        result = []
        nums.sort()

        for i,a in enumerate(nums):
            if i > 0 and a == nums[i-1] :
                continue
            left,right = i + 1,len(nums) - 1
            while(right > left):
                if(nums[left] + nums[right] + a > 0):
                    right = right -  1
                elif(nums[left] + nums[right] + a < 0):
                    left = left + 1
                elif(nums[left] + nums[right] + a  == 0) : 
                        result.append([a,nums[left],nums[right]])
                        left = left + 1
                        while nums[left] == nums[left-1] and left < right:
                            left = left + 1
        return result