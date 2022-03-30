number_of_columns = int(input())
columns = list(map(int,input().split()))
columns = sorted(columns)
print(*columns)
