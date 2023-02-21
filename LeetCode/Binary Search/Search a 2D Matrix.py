# https://leetcode.com/problems/search-a-2d-matrix/description/
'''
You are given an m x n integer matrix matrix with the following two properties:

Each row is sorted in non-decreasing order.
The first integer of each row is greater than the last integer of the previous row.
Given an integer target, return true if target is in matrix or false otherwise.

You must write a solution in O(log(m * n)) time complexity.
'''

class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        left = 0
        right = len(matrix)
        while(left < right):
            mid = (left + right) // 2
            if(matrix[mid][0] > target):
                right = mid
            elif(matrix[mid][-1] < target):
                left = mid + 1
            else :
                break

        left = 0
        right = len(matrix[mid])
        while(left < right):
            smid = (left + right) // 2
            if(target > matrix[mid][smid]):
                left = smid + 1
            elif(target < matrix[mid][smid]) :
                right = smid
            elif(target == matrix[mid][smid]):
                return True
            if(left == right):
                return False 
                
            