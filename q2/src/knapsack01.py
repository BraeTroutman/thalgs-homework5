import sys
import re
import numpy as np

filename = sys.argv[1]

f = open(filename, "r")
lines = f.read().split("\n")[:-1]
f.close()

W = int(re.search(r"\d+", lines[0]).group(0))

wtsvals = [list(map(int,re.findall(r"\d+", line))) for line in lines[2:]]
wt = [x[0] for x in wtsvals]
vl = [x[1] for x in wtsvals]

def spaceEfficientKnapsack(W,w,v):
    n = len(v)
    prev = np.arange(W+1)
    prev.fill(0)
    curr = np.arange(W+1)
    curr.fill(0)

    for i in range(1,n+1):
        for j in range(W+1):
            if j == 0:
                curr[j] = 0
            elif w[i-1] <= j:
                curr[j] = max(prev[j-w[i-1]] + v[i-1], prev[j])
            else:
                curr[j] = prev[j]
        prev = [x for x in curr]
    return curr

def optimal_subsolution(W,w,v):
    n = len(w)
    x1 = spaceEfficientKnapsack(W,w[:n//2], v[:n//2])
    x2 = spaceEfficientKnapsack(W,w[n//2:], v[n//2:])
    
    maxval = -1
    maxcap = -1
    for i in range(W+1):
        sm = x1[i] + x2[W-i]
        if sm > maxval:
            maxval = sm
            maxcap = i

    return maxcap

def knapsack_helper(W,i,w,v):
    n = len(i)
    if len(i) == 1:
        if w[0] <= W:
            return [i[0]]
        else:
            return []
    else:
        k = optimal_subsolution(W,w,v)

        il = i[:n//2]
        ir = i[n//2:]
        wl = w[:n//2]
        wr = w[n//2:]
        vl = v[:n//2]
        vr = v[n//2:]
        left = knapsack_helper(k, il, wl, vl)
        right = knapsack_helper(W-k, ir, wr, vr)
        
        return left + right

def knapsack(W,w,v):
    i = list(range(1,len(v)+1))
    return knapsack_helper(W,i,w,v)

f = open("out/sltn.txt", "w")
items = knapsack(W,wt,vl)
val = sum(map(lambda x: vl[x-1], items))
f.write(f"V {val}\n")
f.write(f"i {len(items)}\n")
for i in items:
    f.write(str(i))
    f.write("\n")
f.close()

