# Let code algorithm problems
#https://leetcode.com/problems/first-bad-version/submissions/  

class Solution:
    def firstBadVersion(self, n: int) -> int:
        beg = 1
        end = n 
        while(beg <= end):
            mid = beg + (end-beg)//2
            if(beg == end):
                return beg
            if (isBadVersion(mid)):
                end = mid
            else : 
                beg = mid+1