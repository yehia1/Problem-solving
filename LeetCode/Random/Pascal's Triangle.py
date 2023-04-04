# https://leetcode.com/problems/pascals-triangle/
''' 

Given an integer numRows, return the first numRows of Pascal's triangle.

In Pascal's triangle, each number is the sum of the two numbers directly above it as shown:


'''

class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        result = []
        for i in range(1,numRows+1):
            result.append([1]*i)
            
        for i in range(2,numRows):
            for j in range(i):
                if (j - 1 >= 0 and j + 1 < i + 1):
                    result[i][j] = result[i-1][j-1] + result[i-1][j]
               
        return (result)