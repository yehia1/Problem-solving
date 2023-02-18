#https://leetcode.com/problems/daily-temperatures/description/

'''
Given an array of integers temperatures represents the daily temperatures,
 return an array answer such that answer[i] is the number of days you have to wait after the ith day to get a warmer temperature.
  If there is no future day for which this is possible, keep answer[i] == 0 instead.
 
'''

class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        res = [0] * len(temperatures)
        stack = [] #index, value pair

        for i in range(len(temperatures) - 1, -1, -1):
            while stack and temperatures[i] >= stack[-1][1]:
                stack.pop()

            if stack:
                res[i] = stack[-1][0] - i

            stack.append((i, temperatures[i]))
        
        return res