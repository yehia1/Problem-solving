# Let code algorithm problems
# https://leetcode.com/problems/search-insert-position/submissions/ 

class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:
        beg = 0
        end = len(nums)
        pmid = None
        while(beg <= end):
            mid = beg + (end-beg) // 2
            if(pmid !=mid):
                pmid = mid
            else : 
                return pmid
            if (beg == end):
                return beg
            if(nums[mid] == target):
                return mid
            elif (nums[mid] > target):
                end = mid
            else :
                 beg = mid + 1         