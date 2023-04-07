function OptimalSubsolution(W::Int64, w::Vector{Int64}, v::Vector{Int64})
    Rows = fill(0, (2, W+1))

    for i = 1:length(v)
        for c = 0:W
            if c == 0
                Rows[2,c+1] = 0
            elseif w[i] <= c
                Rows[2,c+1] = max(Rows[1,(c+1) - w[i]] + v[i], Rows[1,c+1])
            else
                Rows[2,c+1] = Rows[1,c+1]
            end
        end
        Rows[1,:] = copy(Rows[2,:])
    end

    return Rows[2,:]
end

function Knapsack(W::Int64, i::Vector{Int64}, w::Vector{Int64}, v::Vector{Int64})
    N = length(i)
    if N == 1
        if w[1] <= W
            return [i[1]]
        else
            return []
        end
    end

	il = i[1:div(end,2)]
	ir = i[div(end,2)+1:end]
	wl = w[1:div(end,2)]
	wr = w[div(end,2)+1:end]
	vl = v[1:div(end,2)]
	vr = v[div(end,2)+1:end]

	x1 = OptimalSubsolution(W, wl, vl) # O(nW)
	x2 = OptimalSubsolution(W, wr, vr) # O(nW)

    k = argmax(map(+, x1, reverse(x2))) - 1

	left  = Knapsack(k, il, wl, vl)
    right = Knapsack(W-k, ir, wr, vr)

    return [left ; right]
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

@time items = Knapsack(W, collect(1:N),  w, v)
weight = sum(map(i -> w[i], items))
value = sum(map(i -> v[i], items))

function writeresults(f)
	write(f, "V $(value)\n")
	write(f, "i $(length(items)) \n")
	for item in items
		write(f, "$(item)\n")
	end
end

open(writeresults, ARGS[2], "w")

