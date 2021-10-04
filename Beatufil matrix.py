#solution 1 
list1 = []
sum = 0 
for i in range(5):
   list1.append(list(map(int,input().split())))
   for j in range(5):
      if(list1[i][j] == 1):
        sum+=abs(2-i)
        sum+=abs(2-j)
print(sum)  

#solution 2
import numpy as np
 
list1 = []
for i in range(5):
    list1.append(list(map(int,input().split())))
 
array = np.array(list1)
solutions = np.argwhere(array == 1)
sum = 0 
sum+= abs(2 - solutions[0][0])
sum+= abs(2 - solutions[0][1])
print(sum)
