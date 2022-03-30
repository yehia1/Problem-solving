#https://codeforces.com/problemset/problem/490/A

list1 = []
list2 = []
list3 = []
l = int(input())
List1 = list(map(int,input().split()))
for i in range(l):
  if(List1[i] == 1):
    list1.append(i+1)
  elif(List1[i] == 2):
    list2.append(i+1)
  else:
    list3.append(i+1)
 
if (min([len(list1),len(list2),len(list3)]) == 0):
  print(0)
else:
  print(min([len(list1),len(list2),len(list3)]))
  for i in range(min([len(list1),len(list2),len(list3)])):
    print(list1[i],end= ' ')
    print(list2[i],end= ' ')
    print(list3[i],)
