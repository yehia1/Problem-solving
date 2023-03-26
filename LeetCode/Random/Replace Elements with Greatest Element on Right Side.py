# https://leetcode.com/explore/learn/card/fun-with-arrays/511/in-place-operations/3259/

'''
Given an array arr, replace every element in that array with the greatest element among the elements to its right,
 and replace the last element with -1.

After doing so, return the array.

'''
class Solution:
    def replaceElements(self, arr: List[int]) -> List[int]:
        mx = -1 
        for i in range(len(arr) - 1, -1,-1):
            temp = arr[i]
            arr[i] = mx
            mx = max(mx,temp)        
        
        return arr