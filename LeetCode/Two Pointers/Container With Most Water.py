#https://leetcode.com/problems/container-with-most-water/description/

'''
You are given an integer array height of length n. There are n vertical lines drawn such that the two endpoints of the ith line are (i, 0) and (i, height[i]).

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

Notice that you may not slant the container.
'''
class Solution:
    def maxArea(self, height: List[int]) -> int:
        left = 0 
        right = len(height) - 1
        result = 0
        while(left < right):
            area = min(height[left],height[right])* (right - left) 
            result = max(result,area)
            if(height[left] > height[right]):
                right -= 1
            elif(height[left] < height[right]):
                left += 1
            else :
                left += 1
        return result   