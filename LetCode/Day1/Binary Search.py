# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 00:18:39 2022

@author: Yehia Hossam
"""
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        result = -1 
        for i in range(len(nums)):
            if(nums[i] == target):
                result = i;
        return result