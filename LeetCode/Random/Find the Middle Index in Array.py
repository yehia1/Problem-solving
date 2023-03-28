# https://leetcode.com/problems/find-the-middle-index-in-array/description/

'''
Given a 0-indexed integer array nums, find the leftmost middleIndex (i.e., the smallest amongst all the possible ones).

A middleIndex is an index where nums[0] + nums[1] + ... + nums[middleIndex-1] == nums[middleIndex+1] + nums[middleIndex+2] + ... + nums[nums.length-1].

If middleIndex == 0, the left side sum is considered to be 0. Similarly, if middleIndex == nums.length - 1, the right side sum is considered to be 0.

Return the leftmost middleIndex that satisfies the condition, or -1 if there is no such index.

'''

class Solution:
    def findMiddleIndex(self, nums: List[int]) -> int:
        rSum,lSum,i = [],[],1
        j = len(nums) - 1

        while (i < len(nums) + 1):
            lSum.append(sum(nums[:i]))
            rSum.append(sum(nums[j:]))
            
            j -=1
            i +=1
        rSum.reverse()

        for i in range(len(nums)):
            if lSum[i] == rSum[i] :
                return i
        return -1 