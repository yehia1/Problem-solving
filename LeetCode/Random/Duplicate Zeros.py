class Solution:
    def duplicateZeros(self, arr: List[int]) -> None:
        """
        Do not return anything, modify arr in-place instead.
        """
        org = arr[:] # Copy values of `arr` to `org`
        i = j = 0
        n = len(arr)
        while j < n:
            arr[j] = org[i]
            j += 1
            if org[i] == 0: # Copy twice if ord[i] == 0
                if j < n: arr[j] = org[i]
                j += 1
            i += 1