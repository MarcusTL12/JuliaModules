# enemydbcrud.jl (v0.1)



Enemy = Union{Dict{String, Any}, Dict{String, Int64}};

#create, update, read, destroy

#= 
	create: insert!()
	read: findenemy() && getenemyposition()
	update: updateenemy()
	destroy: destroyenemy()
=#

function setpath(newpath::String)

	if path != newpath
		path = newpath;
	end
	
end

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


function insert!(lookup::Array{String, 1}, table::Array{Enemy, 1}, e::Enemy)
	
	if haskey(e, "unique")
		push!(lookup, e["unique"]);
		push!(table, e);
	else
		println("Enemy had no unique key.");
	end
	
end


# Marked with ! because it returns a pointer to the array-element
function findenemies!(arr::Array{Enemy, 1}, key::String, value::Any)

	tmp::Array{Enemy, 1} = [];
	
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

function getenemyposition(arr::Array{Enemy, 1}, e)

	for i in 1:length(arr)
		if e === arr[i]
			return i;
		end
	end

	println("Enemy was not found in array.");
	return nothing;

end

function updateenemy!(e::Enemy, key::String, value::Any)

	e[key] = value;

end

function destroyenemy!(arr::Array{Enemy, 1}, e::Enemy)

	pos = getenemyposition(arr, e);

	if pos != nothing
		deleteat!(arr, pos);
	end

	println("Couldn't delete (obliterate/annihilate) enemy");

end