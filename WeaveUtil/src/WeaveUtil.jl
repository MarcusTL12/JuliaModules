

module WeaveUtil

using Weave

function getJMD(to::IOStream, from::IOStream)
	r = r"input\((.+)\)"
	for i in eachline(from)
		if (m = match(r, i)) != nothing
			open(m.captures[1], "r") do subfile
				getJMD(to, subfile)
			end
		else
			write(to, i, '\n')
		end
	end
end


export buildJMD
function buildJMD(inputpath::String;
		doctype="pandoc2pdf", docname=split(inputpath, '.')[end - 1] * ".pdf")
	open(inputpath, "r") do from
		open("_tmp.jmd", "w") do to
			getJMD(to, from)
		end
	end

	weave("_tmp.jmd"; doctype=doctype)
	
	mv("_tmp.pdf", docname; force=true)
	rm("_tmp.jmd")
end

end
