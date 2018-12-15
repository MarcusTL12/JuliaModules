# filehandling.jl (v0.1)

import JSON

export readfile
export writefile

function readfile(fname)::Array{Any, 1}
	open(fname, "r") do f
		return JSON.parse(read(f, String));
	end
end

function writefile(fname, content)
	cp(fname, fname * ".backup"; force = true);
	
	try 
		rm(fname);
		open(fname, "w") do f
			write(f, "[\n")
			for c in content
				write(f, JSON.json(c))
				write(f, ",\n")
			end
			write(f, "]")
		end
	catch
		println("Removal and rewriting of " * fname * " was unsuccessful.");
		println("Restoring " * fname * ".backup");
	end

end
