#https://codeforces.com/contest/268/problem/A

l = int(input())
List1 = []
sum = 0
for i in range(l):
 List1.append(list(map(int,input().split())))

for i in range(l):
  for j in range(l):
    if(i == j):
      continue
    else:
      if(List1[i][0] == List1[j][1]):
          sum += 1

print(sum)
