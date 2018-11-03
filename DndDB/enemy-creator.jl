import JSON

include("consoleutil.jl");

mutable struct Enemy
	unique::String;
	name::String;
	ac::Int32;
	hp::Int32;
	abl::Array{Int32, 1};
	attacks::Array{String, 1};
	loot::Array{String, 1};
end

function displayenemy(e::Enemy)
	println("Name: " * e.name);
	
	println("AC: " * string(e.ac) * "\tHP: " * string(e.hp) * "\n");
	
	println("Abilityscores: ");
	ablscores::String = "";
	for i in e.abl
		ablscores *= (string(i) * "\t");
	end
	println(ablscores * "\n");
	
	println("Attacks: ");
	for i in e.attacks
		println("\t" * i);
	end

	println("Loot: ");
	for i in e.loot
		println("\t" * i);
	end

end

function enemytojson(e::Enemy)

	return JSON.json(e);

end

function enemytodict(e::Enemy)

	return JSON.parse(JSON.json(e));

end

function jsontoenemy(ejson::String)

	in = JSON.parse(ejson);
	return Enemy(in["name"], in["ac"], in["hp"], in["abl"], in["attacks"], in["loot"]);

end

function createenemydict(unique::String, name::String, ac::Int, hp::Int, abl::Array{Int, 1}, attacks::Array{String, 1}, loot::Array{String, 1})::Dict{String, Any}
	
	d = Dict();

	d["unique"] = unique;
	d["name"] = name;
	d["ac"] = ac;
	d["hp"] = hp;
	d["abl"] = abl;
	d["attacks"] = attacks;
	d["loot"] = loot;

	return d;

end

function main()

	goblin = Enemy("goblin", "Goblin", 12, 13, [12, 12, 11, 8, 8, 8], ["Multiattack"], ["Goblin\'s Ear"]);

	goblindict = enemytodict(goblin);

	dkdict = createenemydict("death-knight", "DK", 16, 24, [14, 12, 13, 11, 10, 12], ["Multiattack", "Soul-weapon"], ["50 gp", "Evil helmet"]);

	arr::Array{Dict, 1} = [goblindict, dkdict];

	arrjson::String = JSON.json(arr);

	println(arrjson);

	return 0;
end

main();

