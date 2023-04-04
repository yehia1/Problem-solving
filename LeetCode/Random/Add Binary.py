
'''
Given two binary strings a and b, return their sum as a binary string.
'''
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        c = int(a,2) + int(b,2)
        return bin(c).replace('0b','')

class Solution:
    def addBinary(self, a: str, b: str) -> str:
        c = self.BinarytoDecimal(a) + self.BinarytoDecimal(b)
        return self.DecToBin(c)
    
    
    def BinarytoDecimal(self,n):
        decimal, i = 0,0
        n = int(n)
        while(n !=0):
            dec = n % 10
            decimal = decimal + dec * pow(2,i)
            n = n // 10
            i += 1
        return decimal

    def DecToBin(self,num):
        binary = ""
        while num > 0:
            binary = str(num % 2) + binary
            num //= 2
        return binary