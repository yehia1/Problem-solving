##https://leetcode.com/problems/flood-fill/solutions/?envType=study-plan&id=algorithm-i


#This idea is making dfs algorithm for all indexex came out of the 2d array wil position given

class Solution:
    def floodFill(self, image: List[List[int]], sr: int, sc: int, color: int) -> List[List[int]]:
        length1, length2 = len(image), len(image[0])
        oldcolor = image[sr][sc]
        if color == oldcolor:
            return image
        def dfs(sr, sc):
            if image[sr][sc] == oldcolor:
                image[sr][sc] = color
                if sr >= 1: dfs(sr-1, sc)
                if sr+1 < length1: dfs(sr+1, sc)
                if sc >= 1: dfs(sr, sc-1)
                if sc+1 < length2: dfs(sr, sc+1)

        dfs(sr, sc)
        return image

        
