# https://leetcode.com/problems/koko-eating-bananas/description/

'''
Koko loves to eat bananas. There are n piles of bananas, the ith pile has piles[i] bananas. The guards have gone and will come back in h hours.

Koko can decide her bananas-per-hour eating speed of k. Each hour, she chooses some pile of bananas and eats k bananas from that pile. If the pile has less than k bananas, she eats all of them instead and will not eat any more bananas during this hour.

Koko likes to eat slowly but still wants to finish eating all the bananas before the guards return.

Return the minimum integer k such that she can eat all the bananas within h hours.


'''

class Solution:
    def minEatingSpeed(self, piles: List[int], h: int) -> int:
        left = 1 
        right = max(piles)

        while(right > left):
            mid = (right + left) // 2
            x = 0
            for i in piles :
                x += ceil(i / mid)

            print(left,right,mid)
            if (x <= h):
                right = mid 
            elif(x > h):
                left = mid + 1

            if(left == right and right!= mid):
                return mid + 1
            elif(left == mid == right):
                return mid