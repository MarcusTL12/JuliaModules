

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
		doctype = "pandoc2pdf", docname = split(inputpath, '.')[end - 1] * ".pdf")
	open(inputpath, "r") do from
		open("_tmp.jmd", "w") do to
			getJMD(to, from)
		end
	end

	weave("_tmp.jmd"; doctype = doctype)
	
	mv("_tmp.pdf", docname; force = true)
	rm("_tmp.jmd")
end


function getTex(topath::AbstractString, frompath::AbstractString)
	path::String = splitdir(frompath)[1]
	r1::Regex = r"(.*)\\input\{(.+)\}"
	r2::Regex = r"[^\\]%"
	open(topath, "w") do to
		function rec(from::IOStream)
			for i in eachline(from)
				if (m = match(r1, i)) != nothing &&
						!startswith(m.captures[1], "%") &&
						match(r2, m.captures[1]) == nothing
					open(io->rec(io), joinpath(path, m.captures[2]), "r")
				else
					write(to, i, '\n')
				end
			end
		end
		open(io->rec(io), frompath)
	end
end


setflag(doc::AbstractString, flg::AbstractString) =
		open(io->write(io, '\0'), doc * flg, "w")
#

export donetx
donetx(doc) = setflag(doc, "")


export wvtx
function wvtx(doc::AbstractString)
	getTex(doc * "temp.tex", doc * ".tex")
	
	weave(doc * "temp.tex", out_path = doc * ".out.tex")
	rm(doc * "temp.tex")
	donetx(doc)
end


fileext(path::AbstractString) = splitext(path)[2]


export clntx
function clntx(doc::AbstractString)
	path = splitdir(doc)[1]
	blacklist = [
		".out.tex",
		".log",
		".xdv",
		".fls",
		".synctex.gz",
		".fdb_latexmk",
		".aux"
	]
	
	for s in blacklist
		rm(doc * s)
	end
end


end
