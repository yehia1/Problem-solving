# https://leetcode.com/problems/largest-rectangle-in-histogram/description/
'''
Given an array of integers heights representing the histogram's bar height where the width of each bar is 1,
return the area of the largest rectangle in the histogram.

'''

class Solution:
    def largestRectangleArea(self, heights: List[int]) -> int:
        stack = []
        result = 0
        n = len(heights)
        

        for i,j in enumerate(heights):
            Flag = '0'
            while(stack and j < stack[-1][1]):
                Flag = '1'
                index, value = stack.pop()
                temp = (i - index) * value
                result = max(result,temp)


            if (Flag != '0'):
                stack.append((index,j))
            else : 
                stack.append((i,j))
                               
        for i,j in stack :
            result = max(result, (n - i) * j)

        return result