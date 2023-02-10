class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        close_to_open = {')':'(',
                          ']':'[','}':'{'}

        for i in s :
            if i in close_to_open:
                if len(stack) != 0 and stack[-1] == close_to_open[i]:
                    stack.pop()
                else : 
                    return False
            else : 
                stack.append(i)

        if len(stack) == 0:
            return True
        else :
            return False