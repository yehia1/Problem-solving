#https://leetcode.com/problems/evaluate-reverse-polish-notation/description/
'''
You are given an array of strings tokens that represents an arithmetic expression in a Reverse Polish Notation.

Evaluate the expression. Return an integer that represents the value of the expression.

Note that:

The valid operators are '+', '-', '*', and '/'.
Each operand may be an integer or another expression.
The division between two integers always truncates toward zero.
There will not be any division by zero.
The input represents a valid arithmetic expression in a reverse polish notation.
The answer and all the intermediate calculations can be represented in a 32-bit integer.
'''

class Solution:
    def evalRPN(self, tokens: List[str]) -> int:
        list1 = []
        ops = {"+": (lambda x,y: x+y), "-": (lambda x,y: x-y),
        "/": (lambda x,y: x/y) , '*': (lambda x,y: x*y)}
        for i in tokens:
            if(i in ops):
                x = list1.pop()
                y = list1.pop()
                list1.append(int(ops[i](y,x)))
            else :
                list1.append(int(i))
        
        return list1[-1]
    