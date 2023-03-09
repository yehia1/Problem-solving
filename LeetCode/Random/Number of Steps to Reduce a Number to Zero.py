# https://leetcode.com/problems/number-of-steps-to-reduce-a-number-to-zero/description/

'''
Given an integer num, return the number of steps to reduce it to zero.

In one step, if the current number is even, you have to divide it by 2,
otherwise, you have to subtract 1 from it.

'''

class Solution:
    def numberOfSteps(self, num: int) -> int:
        counter = 0
        while(num > 0):
            if num % 2 != 0 : 
                num -=1
            else : 
                num = num / 2
            counter +=1
        return counter
