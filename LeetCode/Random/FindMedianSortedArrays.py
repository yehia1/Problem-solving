class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        nums3 = nums1 + nums2
        nums3 = sorted(nums3)
        length = len(nums3)-1 
        if(length % 2 == 1):
            return (nums3[length//2]+nums3[length//2+1])/2
        else :
            return nums3[length // 2]
        
