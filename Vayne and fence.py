Input1 = list(map(int,input().split()))
x,y = a[0],a[1]
Input2 =  list(map(int,input().split()))
sum = 0 
 
for i in range(len(Input2)):
    if(Input2[i] > y):
        sum+=2
    else: 
        sum+=1
print(sum) 
