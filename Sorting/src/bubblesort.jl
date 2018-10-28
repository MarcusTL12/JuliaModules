function bubblesort!(data::Array)
	for i in length(data) - 1 : -1 : 1
		for j in i : length(data) - 1
			if data[j] > data[j + 1]
				data[j], data[j + 1] = data[j + 1], data[j]
			end
		end
	end
end