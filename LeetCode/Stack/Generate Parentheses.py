# https://leetcode.com/problems/generate-parentheses/description/
'''
Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.
'''

class Solution:
    def generateParenthesis(self, n: int) -> List[str]:

        s = []
        res = []


        def BackTracking(openN,closeN):
            print(s)
            if openN == n and closeN == n :
                res.append(''.join(s))
                return
        
            if openN < n :
                s.append('(')
                BackTracking(openN + 1,closeN)
                s.pop()

            if closeN < openN :
                s.append(')')
                BackTracking(openN,closeN + 1)
                s.pop()
            
        BackTracking(0,0)
        return res