# main.jl (v0.1)

using DndDB

function main()

	path::String = "D:\\git\\JuliaModules\\DndDB\\data\\db";      # Path to current directory
	lookup::String = "enemynames.json";    # Path to lookup for quicker db-indexing
	tablepath::String = "enemies.json"; # Path to the table of the database

	cd(path);	
    
	uniqueenemies::Array{String, 1} = readfile(lookup);
	enemytable::Enemyarray = readfile(tablepath);
	tmptable = deepcopy(enemytable);
	push!(tmptable, deepcopy(tmptable[1]));

	deleteall!(x -> x["name"] == "Goblin", tmptable)

	# end of main
	writefile(lookup, uniqueenemies);
	writefile(tablepath, enemytable);
end

main();