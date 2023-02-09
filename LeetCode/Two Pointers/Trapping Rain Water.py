class Solution:
    # dynamic programming solution
    def trap(self, height) :
        max_left = [0]
        max_right = [0] * len(height)
        
        max_temp = 0
        for i in range(len(height) -1):
            max_temp = max(max_temp,height[i])
            max_left.append(max_temp)
        
        max_temp = 0
        for i in range(len(height)- 1, -1, -1):
            max_temp = max(max_temp,height[i])
            max_right[i] = max_temp

        max_temp = 0 
        for i in range(len(height)):
            if(min(max_left[i],max_right[i]) - height[i] > 0):
                max_temp += min(max_left[i],max_right[i]) - height[i]

        return max_temp

    # 2 pointers solution 
    def trap(self, height) :
        max_left = height[0]
        max_right = height[-1]
        left = 0
        right = len(height) - 1 
        result = 0

        while(right > left):
            
            
            if(max_left > max_right):
                right -=1
                max_right = max(max_right,height[right])
                result += max_right - height[right]
            else:
                left +=1
                max_left = max(max_left,height[left])
                result += max_left - height[left]

        return result
