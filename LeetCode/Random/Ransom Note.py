class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        if len(magazine) < len(ransomNote) : 
            return False
        
        dict1 = {}
        for i in magazine : 
            dict1[i] = 1 + dict1.get(i,0)
        
        for i in ransomNote : 
            if i not in dict1.keys():
                return False
            else : 
                print(dict1)
                dict1[i] -=1
                if dict1[i] == 0 :
                    del dict1[i] 
        
        return True