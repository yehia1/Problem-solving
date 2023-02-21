# leet code problems 
# https://leetcode.com/problems/binary-search/
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        result = -1 
        for i in range(len(nums)):
            if(nums[i] == target):
                result = i;
        return result
    
    
#another solution 
class Solution:    
    def search(self, nums: List[int], target: int) -> int:
        left = 0 
        right = len(nums)
        result = -1
        mid = 0
        
        while (left <= right):
            pmid = mid
            mid = (left + right) // 2
            if (mid == len(nums)):
                break
            if(nums[mid] == target):
                result = mid
                break
            elif(pmid == mid):
                break 
                
            elif (target > nums[mid]):
                left = mid+1
            else :
                right = mid
            
            
        return result

# better binary search.
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        left,right = 0 ,len(nums)
        result = -1
        while(left < right):
            mid = (left + right) // 2
            if(target > nums[mid]):
                left = mid + 1
            elif(target < nums[mid]) :
                right = mid
            elif(target == nums[mid]):
                return mid
            if(left == right):
                return result