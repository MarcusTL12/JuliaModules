# main.jl (v0.1)

using DndDB

function main()

	path::String = "D:\\Onedrive\\_Code workspace\\dnd-util\\db";      # Path to current directory
	lookup::String = "enemynames.txt";    # Path to lookup for quicker db-indexing
	tablepath::String = "enemies.json"; # Path to the table of the database

	cd(path);	
    
    uniqueenemies::Array{String, 1} = readfile(lookup);
	enemytable::Array{Enemy, 1} = readfile(tablepath);
	tmptable = deepcopy(enemytable);

	println(typeof(uniqueenemies));
	println(typeof(enemytable));
	# println(uniqueenemies);
	
	# for e in enemytable
	# 	println(e);
	# end


	e1 = enemytable[2];
	e2 = findenemies!(tmptable, "ac", 16);
	
	println(e1);
	println(e2);

	# end of main
	writefile(lookup, uniqueenemies);
	writefile(tablepath, enemytable);
end

main();