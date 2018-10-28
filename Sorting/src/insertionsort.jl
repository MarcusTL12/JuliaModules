function insertionsort!(data::Array)
	for i in 2 : length(data)
		current_value = data[i]
		for j in i - 1 : -1 : 1
			if current_value < data[j]
				data[j + 1] = data[j]
				if j == 1
					data[j] = current_value
				end
			else
				data[j + 1] = current_value
				break
			end
		end
	end
end