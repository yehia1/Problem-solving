# Let code algorithm problems
# https://leetcode.com/problems/squares-of-a-sorted-array/submissions/

class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        output = []
        for i in nums:
            x = i * i
            output.append(x) 

        output.sort()
        return output