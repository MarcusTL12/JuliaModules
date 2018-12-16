# enemydbcrud.jl (v0.2)

export createenemy
export insert!
export update!

export findenemies!
export deleteall!
export deletefirst!
export deletenext!

export printenemy

Enemy = Dict{String, Any};
export Enemy

Enemyarray = Array{Enemy, 1}
export Enemyarray

struct Enemy2

	uq::String
	name::String
	hp::Int32
	ac::Int32
	abl::Vector{Int32}
	att::Vector{String}
	loot::Vector{String}

	Enemy2() = new("null", "no name", 0, 0, [0, 0, 0, 0, 0, 0], "no attacks", "no loot")

end

struct Enemy3

	data::Dict{String, Any}
	Enemy3() = new(Dict())
	Enemy3(data::Dict{String, Any}) = new(data)

end

# create, read, update, destroy
#= 
	createenemy()
		creates and enemy, either from console input or parameterlist
	insert!()
		inserts the enemy such that it appears in both 
		lookup and enemytable
	findenemies!()
		returns a list of all enemies satisfying search criteria
		these are references to occurrences in the inputted array
	findall(), findfirst(), findnext()
		use functions implemented for Array{Dict{String, Any}, 1}
	update!()
		changes value of given enemy's key according to parameter
	deleteall(), deletefirst(), deletenext()
=#

function createenemy()
	d = Enemy();

	d["unique"] = cin(String, 1, "Give unique key: ");
	d["name"] = cin(String, 1, "Give enemy name: ");
	d["ac"] = cin(Int32, 1, "Give AC: ");
	d["hp"] = cin(Int32, 1, "Give HP: ");
	d["abl"] = cin(Int32, 6, "Give abilityscores, newline separates: \n");
	d["attacks"] = cin(String, -1, "Attacks: \n");
	d["loot"] = cin(String, -1, "Loot: \n");

	return d;

end

function createenemy(unique::String, name::String, ac::Int, hp::Int, abl::Array{Int, 1}, attacks::Array{String, 1}, loot::Array{String, 1})::Enemy
	
	d = Enemy();

	d["unique"] = unique;
	d["name"] = name;
	d["ac"] = ac;
	d["hp"] = hp;
	d["abl"] = abl;
	d["attacks"] = attacks;
	d["loot"] = loot;

	return d;

end

function insert!(lookup::Array{String, 1}, table::Enemyarray, e::Enemy)
	
	if haskey(e, "unique")
		push!(lookup, e["unique"]);
		push!(table, e);
	else
		println("Enemy had no unique key.");
	end
	
end

# Marked with ! because it returns a pointer to the array-element
# DEPRECATED
function findenemies!(f::Function, arr::Enemyarray)

	inds = findall(f, arr);

	enem::Enemyarray;

	for i in inds
		push!(enem, arr[i]);
	end

	return enem;

end

function update!(e::Enemy, key::String, value::Any)

	e[key] = value;

end

deletefirst!(f::Function, arr::Enemyarray) = deleteat!(arr, findfirst(f, arr));
deletenext!(f::Function, arr::Enemyarray, i::Int) = deleteat!(arr, findnext(f, arr, i));
deleteall!(f::Function, arr::Enemyarray) = deleteat!(arr, findall(f, arr));

function printenemy(e::Enemy)

	println(e["unique"]);
	println("Name: " * string(e["name"]));
	println("HP: " * string(e["hp"]) * ", AC: " * string(e["ac"]));
	println(Vector{Int}(e["abl"]));
	
	println("Attacks: ");
	for att in e["attacks"]
		println("\t" * att);
	end

	println("Loot: ");
	for loot in e["loot"]
		println("\t" * loot);
	end

end