# enemydbcrud.jl (v0.2)

import Base.println

export createenemy
export insert!
export update!

export findenemies!
export findall
export findfirst
export findnext

export deleteall!
export deletefirst!
export deletenext!

export println

Enemy = Dict{String, Any};
export Enemy

Enemyarray = Array{Enemy, 1}
export Enemyarray

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
	findall()
		returns a list of indicies of all enemies satisfying 
		search criteria
	findfirst()
		returns index of first enemy satisfying search criteria
	findnext()
		returns index of next occurrence of enemy satisfying 
		search criteria after, but not including, the given index
	update!()
		changes value of given enemy's key according to parameter
	deletefirst!()
		removes the first occurrence of given enemy in the given array
	deleteall!()
		removes all occurrences of given enemy in given array
	deletenext!()
		removes the next occurrence of the given enemy after, but not
		including, the given index
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
function findenemies!(arr::Enemyarray, key::String, value::Any)

	tmp::Enemyarray = [];
	
	for e in arr
		if haskey(e, key)
			if e[key] == value
				push!(tmp, e);
			end
		end
	end

	if length(tmp) == 0
		return nothing;
	elseif length(tmp) == 1
		return tmp[1];
	else
		return tmp;
	end

end

# TODO: Implement find functions

function findall(f::Function, arr)

end

function findfirst()

end

function findnext()

end

# Deprecated
function findin(arr::Enemyarray, e)

	for i in 1:length(arr)
		if e === arr[i]
			return i;
		end
	end

	println("Enemy was not found in array.");
	return nothing;

end

function update!(e::Enemy, key::String, value::Any)

	e[key] = value;

end

function deletefirst!(arr::Enemyarray, e::Enemy)

	pos = getenemyposition(arr, e);

	if pos != nothing
		deleteat!(arr, pos);
	end

	println("Couldn't delete (obliterate/annihilate) enemy");

end

function deleteall!(arr::Enemyarray, e::Enemy)

end

function deletenext!(arr::Enemyarray, e::Enemy, i::Int)

end

function println(e::Enemy)

	println(e["unique"])
	println("Name: " * string(e["name"]))
	println("HP: " * string(e["hp"]) * ", AC: " * string(e["ac"]))
	println(Vector{Int}(e["abl"]))
	
	println("Attacks: ")
	for att in e["attacks"]
		println("\t" * att)
	end

	println("Loot: ")
	for loot in e["loot"]
		println("\t" * loot)
	end

end