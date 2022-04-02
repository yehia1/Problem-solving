# leet code problems
#https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/

class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        result_list = []
        left = 0 
        right = len(nums) - 1
        while (len(result_list) < 2):
            sum = nums[left] + nums[right]
            if ( sum == target):
                result_list.append(left+1)
                result_list.append(right+1)
            elif (sum < target):
                left += 1 
            else : 
                right -= 1
        return result_list   