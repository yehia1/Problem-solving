#https://codeforces.com/contest/474/problem/A

list1 = ['qwertyuiop','asdfghjkl;','zxcvbnm,./']
s = input()
letter = input()
letter = list(letter)
if (s == 'R'):
  for i in range(len(letter)):
    # print(list1[0].find(letter[i]), end = '')
    if(list1[0].find(letter[i]) != -1):
      letter[i] = list1[0][list1[0].find(letter[i])-1]
    elif(list1[1].find(letter[i]) != -1):
      letter[i] = list1[1][list1[1].find(letter[i])-1]
    elif(list1[2].find(letter[i]) != -1):
      letter[i] = list1[2][list1[2].find(letter[i])-1] 
else :
  for i in range(len(letter)):
    if(list1[0].find(letter[i]) != -1):
      letter[i] = list1[0][list1[0].find(letter[i])+1]
    elif(list1[1].find(letter[i]) != -1):
      letter[i] = list1[1][list1[1].find(letter[i])+1]
    elif(list1[2].find(letter[i]) != -1):
      letter[i] = list1[2][list1[2].find(letter[i])+1]

      

print(''.join(letter))
