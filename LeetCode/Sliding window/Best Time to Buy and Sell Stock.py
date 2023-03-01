# https://leetcode.com/problems/best-time-to-buy-and-sell-stock/description/

'''
You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.
'''

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        left,right = 0,1
        max_profit = 0 

        while (right < len(prices)):
            if prices[left] < prices[right]:
                max_profit = max(max_profit,prices[right] - prices[left])
            else :
                left = right
            right+=1
        return max_profit