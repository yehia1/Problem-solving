bear1,bear2 = map(int,input().split())
years= 0 

while(1):
  years+=1
  if(bear1*3>bear2*2):
    break
  else : 
    bear1 = bear1*3
    bear2 = bear2*2
print(years) 
