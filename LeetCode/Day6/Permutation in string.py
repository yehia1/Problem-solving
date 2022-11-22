#Leet code problems
# https://leetcode.com/problems/permutation-in-string/submissions/


class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        s1_counter = collections.Counter(s1)
        
        s1_len = len(s1)
        
        for i in range(len(s2) - s1_len + 1):
            if collections.Counter(s2[i:i+s1_len]) == s1_counter:
                return True
            
        return False
    
# another solution solves 79 of 100 case     
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        k = len(s1)
        dict = {s1: None,s1[::-1]: None}
        n = len(s2) 
        test = s2[:k]

        for i in range(n - k):
            if(test not in dict):
                test = test[:0]+test[1:]
                test +=s2[i+k]
            else : 
                break
        if(test in dict):
            return True
        else :
            return False
