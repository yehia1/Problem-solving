# https://leetcode.com/problems/diagonal-traverse/
'''
Given an m x n matrix mat, return an array of all the elements of the array in a diagonal order.

'''
class Solution:
    def findDiagonalOrder(self, mat: List[List[int]]) -> List[int]:
        n =len(mat)
        m = len(mat[0])
        result = [mat[0][0]]
        up,column,row = True,0,0
        while(row < n):
            if(row + 1 == n and column + 1 == m ): #if reached end of the matrix
                break
            if (up): # flag to see going up or down
                if(column + 1 == m): # if going right out of index
                    row = row + 1
                    result.append(mat[row][column])
                    up = False
                elif(row - 1 < 0): # if going up out of index
                    column = column + 1
                    result.append(mat[row][column])
                    up = False
                else : 
                    row = row - 1
                    column = column + 1
                    result.append(mat[row][column])
            else :
                if(row + 1 == n): # if going down out of index
                    column = column + 1
                    result.append(mat[row][column])
                    up = True
                elif(column - 1 < 0): # if going left out of index
                    row = row + 1
                    result.append(mat[row][column])
                    up = True
                else : 
                    row = row + 1
                    column = column - 1
                    result.append(mat[row][column])
        return(result)