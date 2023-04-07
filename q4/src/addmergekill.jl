function merge(left, right)
	out = fill((0,0), length(left) + length(right))

    l = 1
    r = 1

	for i in 1:length(out)
        if l > length(left)
			out[i:end] = right[r:end]
            break
		end
        if r > length(right)
			out[i:end] = left[l:end]
            break
		end
        if left[l] < right[r]
            out[i] = left[l]
            l += 1
        else
            out[i] = right[r]
            r += 1
		end
	end
    
	return out
end

addtuple((x,y), (a,b)) = (x+a,y+b)
showrow(row) = join(["<$(w),$(v)>" for (w,v) in row], " ")

function add(row, w, v)
	[addtuple(tp, (w,v)) for tp ∈ row]
end

function kill(row, W)
	(wp, vp) = row[1]
	out = [(wp, vp)]

	for (w, v) in row[2:end]
		if w <= W && v >= vp
			push!(out, (w,v))
			wp, vp = w, v
		end
	end

	return out
end

function addmergekill(W, w, v)
	row = [(0,0)]
	i::Int32 = 0	
	W <= 20 && println("$(i): ", showrow(row))

	for i in 1:length(w)
		next = add(row, w[i], v[i])
		row = merge(row, next)
		row = kill(row, W)
		W <= 20 && println("$(i): ", showrow(row))
	end

	return row
end

function addmergekillPlot(W, w, v)
	row = [(0,0)]
	y = fill(0, length(w))

	for i in 1:length(w)
		next = add(row, w[i], v[i])
		row = merge(row, next)
		row = kill(row, W)
		y[i] = length(row)
	end
	
	return y
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

@time dp = addmergekill(W, w, v)

