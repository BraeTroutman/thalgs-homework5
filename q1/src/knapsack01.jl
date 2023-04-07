function knapsack(W, w, v)
    n = length(v)

    dp = fill(0, n+1, W+1)

    for i = 1:length(v)
    	for c = 0:W
            if c == 0
                dp[i+1,c+1] = 0
            elseif w[i] <= c
                dp[i+1,c+1] = max(dp[i,(c+1) - w[i]] + v[i], dp[i,c+1])
            else
                dp[i+1,c+1] = dp[i,c+1]
            end
        end
    end
	
	result = dp[n+1, W+1]
	items  = []
	wt = W

	for i in n:-1:1
		if result <= 0 || wt <= 0
			break
		elseif result == dp[i, wt+1]
			continue
		else
			push!(items, i)
			result = result - v[i]
			wt = wt - w[i]
		end
	end

	return reverse(items)
end

lines = open(readlines, ARGS[1])
W = parse(Int64, match(r"\d+", lines[1]).match)
N = parse(Int64, match(r"\d+", lines[2]).match)

w = fill(0, N)
v = fill(0, N)

for (i,line) in enumerate(lines[3:end])
    matches = collect(eachmatch(r"\d+", line))
    w[i] = parse(Int64, matches[1].match)
    v[i] = parse(Int64, matches[2].match)
 end

@time items = knapsack(W, w, v)
weight = sum(map(i -> w[i], items))
value = sum(map(i -> v[i], items))

function writeresults(f)
	write(f, "V $(value) \n")
	write(f, "i $(length(items))\n")
	for item in items
		write(f, "$(item)\n")
	end
end

open(writeresults, ARGS[2], "w")

