

function rodcut(totlength::Int, prices::Array{Tuple{Int, Float}, 1})
	price_list::Array{Float, 1} = zeros(Float, totlength)

	for i in 1 : length(prices)
		price_list[prices[i][1]] = prices[i][2]
	end
	rodcut(totlength, price_list)
	return price_list[totlength]
end


function rodcut(totlength::Int, prices::Array{Float, 1})
	for i in 1 : totlength
		for j in 1 : i - 1
			if prices[j] + prices[i - j] > prices[i]
				prices[i] = prices[j] + prices[i - j]
			end
		end
	end
end


function rodcut(totlength::Float, prices::Array{Tuple{Float, Float}})
	
end

