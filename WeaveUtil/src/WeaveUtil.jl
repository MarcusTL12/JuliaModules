

module WeaveUtil

using Weave

function buildJMD(inputpath::String)
	r = r"input\((.+)\)"
	open(inputpath, "r") do from
		open("_tmp.jmd", "w") do to
			for i in eachline(from)
				if (m = match(r, i)) != nothing
					open(m.captures[1], "r") do subfile
						write(to, subfile, '\n')
					end
				else
					write(to, i, '\n')
				end
			end
		end
	end

	weave("_tmp.jmd", doctype="pandoc2pdf")

	rm("_tmp.jmd")
end

end
