### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 6b0a6628-7cd0-11eb-361f-874aac5e663d
using DataFrames

# ╔═╡ 25d60a56-7d25-11eb-1dc4-c1aac8b99a28
begin
	using HTTP
	using JSON
end

# ╔═╡ 0fc0c5ac-7d8f-11eb-33a5-fb0673a30607
begin
	using Plots
	pyplot()
end

# ╔═╡ b7b8a74a-7d92-11eb-1176-65f6302361d9
md"# Question 1"

# ╔═╡ aae6c9d2-7cd1-11eb-2318-45fee636a988
begin
	df1 = DataFrame(religion = String[], less_10k = Int[], _10_20k = Int[], _20_30k = Int[], _30_40k = Int[], _40_50k = Int[], _50_75k = Int[], _75_100k = Int[], _100_150k = Int[], greater_150k = Int[], refused = Int[])
	push!(df1,["Agnostic",27,34,60,81,76,137,122,109,84,96])
    push!(df1,["Atheist",12,27,37,52,35,70,62,45,20,8])
    push!(df1,["Buddhist",27,21,30,34,33,58,44,23,15,5])
    push!(df1,["Catholic",418,617,732,670,638,1116,770,438,345,100])
    push!(df1,["Don't Know/refused",15,14,15,11,10,35, 21,17,8,2])
    push!(df1,["Evangelical Prot",575,869,1064,982,881,1486,1082,681,454,142])
    push!(df1,["Hindu",1,9,7,9,11,34,19,18,15,2])
    push!(df1,["Historically Black Prot",228,244,236,238,197,223,338,97,43,10])
    push!(df1,["Jehovah's Witness",20,27,24,24,21,30,29,19,12,4])
    push!(df1,["Jewish",19,19,25,25,30,95,88,62,18,7])
	colnames1 = ["religion","<\$10k","\$10k-20k", "\$20k-30k", "\$30k-40k", "\$40k-50k", "\$50k-75k", "\$75k-100k", "\$100k-150k", ">\$150k", "Don't know/Refused"]
	rename!(df1, Symbol.(colnames1))
end


# ╔═╡ 31bc9568-7d04-11eb-261a-f19f269af975
begin
	stacked = DataFrames.stack(df1, 2:11)
	colnames1_ = ["religion", "income", "freq"]
	rename!(stacked, Symbol.(colnames1_))
	grouped = groupby(stacked, :religion)
	vcat(grouped...)
end

# ╔═╡ d1492478-7d06-11eb-3873-4179206d9452
md"# Question 2"

# ╔═╡ ecaf3df6-7d06-11eb-2e25-6d4686e487e4
begin
# 	some of the data might not be exact as mentioned in the Google Doc as it is hard to look at individual elements and make changes
	df2 = DataFrame(
		id = ["MX170004", "MX170004", "NX170004", "NX170004", "OX170004", "OX170004", "PX170004", "PX170004", "QX170004", "QX170004"],
		year = [2010, 2010, 2011, 2011, 2012, 2012, 2013, 2013, 2014, 2014],
		month = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
		element = ["tmax", "tmin", "tmax", "tmin", "tmax", "tmin", "tmax", "tmin", "tmax", "tmin"],
	    d1  = [35.4, 21.7, 27.4, 19.1, 19.7, 10.4, 19.6, 12.6, 39.7, 11.1],
		d2  = [37.9, 23.4, 27.3, 14.4, 31.7, 23.1, 30.9, 21.9, 35.6, 14.3],
		d3  = [34.9, 28.4, 24.1, 14.4, 24.8, 13.7, 21.7, 14.4, 36.5, 15.9],
		d4  = [26.2, 12.6, 18.4, 13.2, 36.8, 11.6, 25.4, 13.3, 10.6, 11.0],
		d5  = [19.9, 12.7, 27.1, 19.1, 32.1, 14.2, 27.1, 14.7, 37.6, 25.0],
		d6  = [18.6, 13.2, 23.7, 16.1, 27.7, 22.1, 31.3, 11.4, 34.5, 16.1],
		d7  = [13.5, 10.8, 19.2, 12.6, 18.8, 13.1, 10.2, 10.9, 36.6, 13.9],
		d8  = [11.5, 10.1, 11.2, 10.5, 33.7, 24.9, 26.1, 18.6, 29.4, 19.5],
		d9  = [13.7, 10.4, 22.8, 13.1, 29.5, 21.1, 26.8, 17.8, 28.2, 11.8],
		d10 = [38.3, 17.5, 16.1, 10.7, 30.0, 20.2, 29.3, 12.8, 36.4, 31.0],
		d11 = [16.6, 10.1, 15.8, 10.2, 10.9, 10.3, 39.2, 10.4, 19.9, 13.5],
		d12 = [14.0, 10.8, 33.6, 15.1, 31.9, 18.8, 25.0, 18.0, 22.6, 10.6],
		d13 = [35.9, 11.5, 22.2, 13.2, 23.0, 12.3, 31.9, 23.4, 32.1, 25.4],
		d14 = [19.5, 12.1, 15.5, 10.6, 30.2, 23.2, 19.5, 10.3, 30.9, 25.5],
		d15 = [11.2, 10.0, 39.6, 30.0, 12.3, 10.6, 19.9, 12.0, 39.9, 20.9],
		d16 = [10.7, 10.5, 25.2, 11.7, 37.9, 15.6, 33.3, 18.5, 37.4, 26.9],
		d17 = [23.1, 17.2, 37.6, 10.3, 17.5, 11.9, 29.4, 15.7, 19.1, 13.6],
		d18 = [31.0, 10.6, 16.4, 10.1, 25.1, 19.9, 15.7, 10.1, 20.6, 12.2],
		d19 = [27.5, 12.5, 38.6, 17.9, 33.6, 18.9, 30.3, 10.1, 31.6, 10.4],
		d20 = [33.0, 14.4, 34.2, 16.6, 38.7, 26.0, 19.1, 10.6, 31.4, 15.6],
		d21 = [23.7, 18.0, 24.6, 13.7, 26.6, 21.1, 28.7, 14.7, 27.1, 13.6],
		d22 = [16.8, 10.1, 35.4, 14.1, 16.7, 10.3, 24.5, 14.4, 10.8, 10.1],
		d23 = [22.4, 12.2, 23.0, 13.1, 30.0, 20.8, 17.8, 10.8, 25.4, 18.6],
		d24 = [19.6, 11.9, 23.4, 18.0, 30.4, 13.5, 12.9, 10.0, 33.6, 27.0],
		d25 = [30.4, 12.4, 38.6, 28.6, 36.0, 15.0, 25.2, 12.2, 17.1, 11.0],
		d26 = [33.1, 12.8, 20.5, 10.8, 18.1, 10.4, 27.0, 14.3, 27.8, 16.0],
		d27 = [35.3, 16.6, 37.8, 29.4, 21.1, 14.3, 15.1, 10.1, 21.8, 16.2],
		d28 = [33.9, 19.0, 11.8, 10.0, 24.5, 12.1, 33.1, 24.5, 35.7, 15.1],
		d29 = [16.4, 10.7, missing, missing, 21.4, 11.9, 33.2, 22.8, 39.7, 31.2],
		d30 = [31.0, 21.8, missing, missing, 17.8, 11.2, 32.2, 18.1, 32.2, 10.4],
		d31 = [24.2, 16.4, missing, missing, missing, missing, missing, missing, 11.4, 10.2]
	)
end

# ╔═╡ a6ca4570-7d0a-11eb-3222-f3026db58f93
begin
	function parser(year, month, date)
		d = parse(Int, date[2:end])
		return string(year)*"-"*string(d, base=10, pad=2)*"-"*string(month, base=10, pad=2)
	end
	grouped2 = groupby(df2, :element);
	tmax_data = sort(DataFrames.stack(grouped2[1], 5:size(df2)[2], variable_name=:d, value_name=:tmax));
tmin_data = sort(DataFrames.stack(grouped2[2], 5:size(df2)[2], variable_name=:d, value_name=:tmin));
	tmax_final = transform(tmax_data, [:year, :month, :d] => ByRow((y,m,d) ->(a=parser(y,m,d))) => :date)[:, [:id, :date, :tmax]];
	tmin_final = transform(tmin_data, [:year, :month, :d] => ByRow((y,m,d) ->(a=parser(y,m,d))) => :date)[:, [:id, :date, :tmin]];
	df2_final = dropmissing(innerjoin(tmax_final, tmin_final, on = :date, makeunique=true)[:, [:id, :date, :tmax, :tmin]], [:tmax, :tmin])
end

# ╔═╡ fadbb466-7d1c-11eb-2371-0112133c6b27
md"# Question 3"

# ╔═╡ 30657918-7d23-11eb-3465-8b7760adc54c
begin
	df3 = DataFrame(
				year = Int[], artist = String[], time = String[], track = String[], date = String[], week = Int[], rank = Int[]
			)
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-02-26", 1, 87))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-03-04", 2, 82))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-03-11", 3, 72))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-03-18", 4, 77))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-03-25", 5, 87))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-04-01", 6, 94))
	push!(df3, (2000, "2 Pac", "4:22", "Baby Don't Cry", "2000-04-08", 7, 99))
	push!(df3, (2000, "2Ge+her", "3:15", "The Hardest Part Of ...", "2000-09-02", 1, 91))
	push!(df3, (2000, "2Ge+her", "3:15", "The Hardest Part Of ...", "2000-09-09", 2, 87))
	push!(df3, (2000, "2Ge+her", "3:15", "The Hardest Part Of ...", "2000-09-16", 3, 92))
	push!(df3, (2000, "3 Doors Down", "3:53", "Kryptonite", "2000-04-08", 1, 81))
	push!(df3, (2000, "3 Doors Down", "3:53", "Kryptonite", "2000-04-15", 2, 70))
	push!(df3, (2000, "3 Doors Down", "3:53", "Kryptonite", "2000-04-22", 3, 68))
	push!(df3, (2000, "3 Doors Down", "3:53", "Kryptonite", "2000-04-29", 4, 67))
	push!(df3, (2000, "3 Doors Down", "3:53", "Kryptonite", "2000-05-06", 5, 66))


# 	rest of the data is randomly cooked up and might not correspond to real data


	push!(df3, (2002, "3 Doors Down", "4:24", "Loser", "2002-04-08", 1, 81))
	push!(df3, (2002, "3 Doors Down", "4:24", "Loser", "2002-04-15", 2, 70))
	push!(df3, (2002, "3 Doors Down", "4:24", "Loser", "2002-04-22", 3, 68))
	push!(df3, (2002, "3 Doors Down", "4:24", "Loser", "2002-04-29", 4, 67))
	push!(df3, (2002, "3 Doors Down", "4:24", "Loser", "2002-05-06", 5, 66))

	push!(df3, (1999, "504 Boys", "3:35", "Wobble Wobble", "1999-04-08", 1, 81))
	push!(df3, (1999, "504 Boys", "3:35", "Wobble Wobble", "1999-04-15", 2, 70))
	push!(df3, (1999, "504 Boys", "3:35", "Wobble Wobble", "1999-04-22", 3, 68))
	push!(df3, (1999, "504 Boys", "3:35", "Wobble Wobble", "1999-04-29", 4, 67))
	push!(df3, (1999, "504 Boys", "3:35", "Wobble Wobble", "1999-05-06", 5, 66))

	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-07-26", 1, 87))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-08-09", 2, 82))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-08-11", 3, 72))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-08-18", 4, 77))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-08-25", 5, 87))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-09-01", 6, 94))
	push!(df3, (2018, "98^0", "3:24", "Baby Don't Cry", "2018-09-08", 7, 99))

	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-07-26", 1, 87))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-08-09", 2, 82))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-08-11", 3, 72))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-08-18", 4, 77))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-08-25", 5, 87))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-09-01", 6, 94))
	push!(df3, (2015, "A*Teens", "3:44", "Dancing Queen", "2015-09-08", 7, 99))

	push!(df3, (2000, "Aaliyah", "4:15", "I Don't Wanna", "2000-09-02", 1, 91))
	push!(df3, (2000, "Aaliyah", "4:15", "I Don't Wanna", "2000-09-09", 2, 87))
	push!(df3, (2000, "Aaliyah", "4:15", "I Don't Wanna", "2000-09-16", 3, 92))

	push!(df3, (1997, "Aaliyah", "4:03", "Try Again", "1997-09-02", 1, 91))
	push!(df3, (1997, "Aaliyah", "4:03", "Try Again", "1997-09-09", 2, 87))
	push!(df3, (1997, "Aaliyah", "4:03", "Try Again", "1997-09-16", 3, 92))

	push!(df3, (2005, "Adams, Yolanda", "5:30", "Open My Heart", "2005-04-08", 1, 81))
	push!(df3, (2005, "Adams, Yolanda", "5:30", "Open My Heart", "2005-04-15", 2, 70))
	push!(df3, (2005, "Adams, Yolanda", "5:30", "Open My Heart", "2005-04-22", 3, 68))
	push!(df3, (2005, "Adams, Yolanda", "5:30", "Open My Heart", "2005-04-29", 4, 67))
	push!(df3, (2005, "Adams, Yolanda", "5:30", "Open My Heart", "2005-05-06", 5, 66))

	push!(df3, (1994, "Adkins, Trace", "3:05", "More", "1994-04-08", 1, 81))
	push!(df3, (1994, "Adkins, Trace", "3:05", "More", "1994-04-15", 2, 70))
	push!(df3, (1994, "Adkins, Trace", "3:05", "More", "1994-04-22", 3, 68))
	push!(df3, (1994, "Adkins, Trace", "3:05", "More", "1994-04-29", 4, 67))
	push!(df3, (1994, "Adkins, Trace", "3:05", "More", "1994-05-06", 5, 66))

	push!(df3, (2011, "Aguilera, Christina", "3:38", "Come On Over Baby", "2011-04-08", 1, 81))
	push!(df3, (2011, "Aguilera, Christina", "3:38", "Come On Over Baby", "2011-04-15", 2, 70))
	push!(df3, (2011, "Aguilera, Christina", "3:38", "Come On Over Baby", "2011-04-22", 3, 68))
	push!(df3, (2011, "Aguilera, Christina", "3:38", "Come On Over Baby", "2011-04-29", 4, 67))
	push!(df3, (2011, "Aguilera, Christina", "3:38", "Come On Over Baby", "2011-05-06", 5, 66))
	
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-07-26", 1, 87))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-08-09", 2, 82))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-08-11", 3, 72))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-08-18", 4, 77))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-08-25", 5, 87))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-09-01", 6, 94))
	push!(df3, (2012, "Aguilera, Christina", "4:00", "I Turn To You", "2012-09-08", 7, 99))

	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-02-26", 1, 87))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-08-09", 2, 82))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-08-11", 3, 72))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-08-18", 4, 77))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-08-25", 5, 87))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-09-01", 6, 94))
	push!(df3, (2010, "Aguilera, Christina", "3:18", "What A Girl Wants", "2010-09-08", 7, 99))


	push!(df3, (2030, "Alice Deejay", "6:50", "Better Off Alone", "2030-09-02", 1, 91))
	push!(df3, (2030, "Alice Deejay", "6:50", "Better Off Alone", "2030-09-09", 2, 87))
	push!(df3, (2030, "Alice Deejay", "6:50", "Better Off Alone", "2030-09-16", 3, 92))	
end

# ╔═╡ 55fa9dec-7dd3-11eb-3eef-bf3a46979b19
begin
	grouped3 = groupby(df3, [:artist, :track]);
	df3.id = grouped3.groups;
	song_details = unique(df3[:, [:id, :artist, :track, :time]]);
	date_rank = df3[:, [:id, :date, :rank]];
	"Just to prevent displaying output here"
end

# ╔═╡ 23391f3c-7dd3-11eb-0c49-0f1577d50b0f
song_details

# ╔═╡ 29daf00e-7dd3-11eb-2305-5d0c5ec23827
date_rank

# ╔═╡ 01630c00-7d25-11eb-0000-bfff3fbcb4fd
md"# Question 4"

# ╔═╡ 7e24bc6c-7d79-11eb-0ac1-8340a52ab9bb
begin
	resp = HTTP.get("https://api.covid19india.org/data.json")
	str = String(resp.body)
	jobj = JSON.Parser.parse(str)
	x = jobj["cases_time_series"]
# 	convert string to integer for easier operation later
	df4 = reduce(vcat, DataFrame.(x))	
	df4[!, :dailyconfirmed] = [parse(Int,x) for x in df4[!, :dailyconfirmed]]
	df4[!, :dailydeceased] = [parse(Int,x) for x in df4[!, :dailydeceased]]
	df4[!, :dailyrecovered] = [parse(Int,x) for x in df4[!, :dailyrecovered]]
end

# ╔═╡ 590d5f2a-7d7b-11eb-30e3-59459e52a709
begin
	df41 = transform(df4, :dateymd => ByRow(dymd -> dymd[1:4]) => :Year)
	df42 = transform(df41, :date => ByRow(d -> d[4:end-1]) => :Month)
	df4final = select(df42, Not([:date, :dateymd, :totalconfirmed, :totaldeceased, :totalrecovered]))
	df4_grouped = groupby(df4final[:, [:Year, :Month, :dailyconfirmed, :dailyrecovered, :dailydeceased]], [:Year, :Month])
	combine(df4_grouped, :dailyconfirmed => sum => :confirmed, :dailyrecovered => sum => :recovered, :dailydeceased => sum => :deceased)
end

# ╔═╡ a4f2afd8-7d7f-11eb-21a7-8d775eef0d43
md"# Question 5"

# ╔═╡ d852f94a-7d8c-11eb-131b-d1bcb98c7fc0
begin
	confirmed = df4[:, :dailyconfirmed]
	deceased = df4[:, :dailydeceased]
	recovered = df4[:,:dailyrecovered]
	moving_average(array,window) = [sum(array[i:(i+window-1)])/window for i in 1:(length(array)-(window-1))]
	n_days = 7
	smooth_confirmed = moving_average(confirmed, n_days)
	smooth_deceased = moving_average(deceased, n_days)
	smooth_recovered = moving_average(recovered, n_days)
end

# ╔═╡ 7346fad4-7da2-11eb-1a1f-d70a496e429f
begin
	p11 = plot(confirmed, ylabel="confirmed cases", xlabel="days", title="daily confirmed", color="red")
	p12 = plot(smooth_confirmed, ylabel="confirmed cases", xlabel="days", title="confirmed $n_days day average", color="red")
	plot(p11, p12, size=(1300, 600), ylim=(0, max(confirmed...)+1000))
end

# ╔═╡ 31161660-7da5-11eb-3480-ebf49a5093ec
begin
	p21 = plot(recovered, ylabel="recovered cases", xlabel="days", title="daily recovered", color="red")
	p22 = plot(smooth_recovered, ylabel="recovered cases", xlabel="days", title="recovered $n_days day average", color="red")
	plot(p21, p22, size=(1300, 600), ylim=(0, max(recovered...)+1000))
end

# ╔═╡ 981a485e-7da5-11eb-2521-f33cf64105fa
begin
	p31 = plot(deceased, ylabel="deceased cases", xlabel="days", title="daily deceased", color="red")
	p32 = plot(smooth_deceased, ylabel="deceased cases", xlabel="days", title="deceased $n_days day average", color="red")
	plot(p31, p32, size=(1300, 600), ylim=(0, max(deceased...)+100))
end

# ╔═╡ Cell order:
# ╟─b7b8a74a-7d92-11eb-1176-65f6302361d9
# ╠═6b0a6628-7cd0-11eb-361f-874aac5e663d
# ╠═aae6c9d2-7cd1-11eb-2318-45fee636a988
# ╠═31bc9568-7d04-11eb-261a-f19f269af975
# ╟─d1492478-7d06-11eb-3873-4179206d9452
# ╠═ecaf3df6-7d06-11eb-2e25-6d4686e487e4
# ╠═a6ca4570-7d0a-11eb-3222-f3026db58f93
# ╟─fadbb466-7d1c-11eb-2371-0112133c6b27
# ╠═30657918-7d23-11eb-3465-8b7760adc54c
# ╠═55fa9dec-7dd3-11eb-3eef-bf3a46979b19
# ╠═23391f3c-7dd3-11eb-0c49-0f1577d50b0f
# ╠═29daf00e-7dd3-11eb-2305-5d0c5ec23827
# ╟─01630c00-7d25-11eb-0000-bfff3fbcb4fd
# ╠═25d60a56-7d25-11eb-1dc4-c1aac8b99a28
# ╠═7e24bc6c-7d79-11eb-0ac1-8340a52ab9bb
# ╠═590d5f2a-7d7b-11eb-30e3-59459e52a709
# ╟─a4f2afd8-7d7f-11eb-21a7-8d775eef0d43
# ╠═0fc0c5ac-7d8f-11eb-33a5-fb0673a30607
# ╠═d852f94a-7d8c-11eb-131b-d1bcb98c7fc0
# ╠═7346fad4-7da2-11eb-1a1f-d70a496e429f
# ╠═31161660-7da5-11eb-3480-ebf49a5093ec
# ╠═981a485e-7da5-11eb-2521-f33cf64105fa
