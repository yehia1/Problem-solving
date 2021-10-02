Number = int(input())
List = []
number_of_solvable_problems = 0 
for i in range(Number):
  List.append(list(map(int,input().split())))
  if(sum(List[i])>= 2):
    number_of_solvable_problems+=1

print(number_of_solvable_problems)
