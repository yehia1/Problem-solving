# Let code algorithm problems
# https://leetcode.com/problems/rotate-array/submissions/

class Solution:
    def rotate(self, nums: List[int], k: int) -> None:
        """
        Do not return anything, modify nums in-place instead.
        """
        testcase = [nums[(i - k) % len(nums)]
               for i, x in enumerate(nums)]
        for i in range(len(nums)):
            nums[i] = testcase[i]

    def rotate(self, nums: List[int], k: int) -> None:
        n = len(nums)
        result = [0] * n
        for i in range(n):
            result[(i+k) % n] = nums[i]
            
        for i in range(n):
            nums[i] = result[i]