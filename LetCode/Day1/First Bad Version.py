# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 00:25:18 2022

@author: Yehia Hossam
"""
class Solution:
    def firstBadVersion(beg: int, n: int) -> int:
        if(beg != n):
            mid = beg+(n-beg)//2
            if (isBadVersion(mid)):
                Solution.firstBadVersion(0,mid-1)
            else : 
                Solution.firstBadVersion(mid+1, n)
        else : 
            return n
        
        
def isBadVersion(i):
    if(i == input2) : 
        return True
    else :
        return False

input1 = int(input())
input2 = int(input())    
    
print(Solution.firstBadVersion(0, input1))   
