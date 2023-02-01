# https://leetcode.com/problems/product-of-array-except-self/description/

'''
Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.

You must write an algorithm that runs in O(n) time and without using the division operation.

'''

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        result = []
        pre = 1
        post = 1 

        for i in nums:
            result.append(pre)
            pre = pre*i

        for i in range(len(nums)-1 ,-1,-1):
            result[i] = result[i] * post
            post = nums[i] * post

        return result
            