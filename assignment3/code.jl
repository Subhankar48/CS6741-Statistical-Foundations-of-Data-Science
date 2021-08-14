### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 853ebf58-8cc3-11eb-1876-53f0b5c7fd31
begin
	using Plots
	gr()
	using StatsBase
	using Distributions
	using DataFrames
	using StatsPlots
	using HTTP
	using CSV
	using Dates
	using Missings
	using Random
end

# ╔═╡ 7d3f7fa6-8cc6-11eb-2122-e5ce7d7472c2
md"### Question 1"

# ╔═╡ aab08b16-8cc5-11eb-3bf8-cf0a71d32b37
begin
	function kld(pdf1, pdf2, dx)
		non_zero_vals = pdf1.>0
		return sum(pdf1[non_zero_vals].*log2.(pdf1[non_zero_vals]./pdf2[non_zero_vals]))*dx
	end;
	dx=0.01
	x_range_ = -37:dx:37
	dof_vals = 1:5
	kld_vals = []
	norm_pdf_vals = pdf.(Normal(0,1), x_range_)
	for mu in dof_vals
		push!(kld_vals, kld(pdf.(TDist(mu), x_range_), norm_pdf_vals, dx)) 
	end
	kld_vals
end

# ╔═╡ 247e6484-8d22-11eb-02c5-e7edd6996cc0
md"### Question 2"

# ╔═╡ 519162b4-9231-11eb-1a9a-396b22d9056c
begin
	unif_sampler_0_1 = Uniform(0,1)
	start_val = 0
	last_val = 10
	x_range = start_val:dx:last_val
	pdf_vals = pdf.(unif_sampler_0_1, x_range)
	pdf_vals = pdf_vals/sum(pdf_vals.*dx)
	pdf_vals_flipped = pdf_vals[end:-1:1]
	function conv_with_uniform(x, dx=dx)
		n = length(x)
		y = zeros(n)
		for i in 1:n
			y[i] = sum(x[1:i].*pdf_vals_flipped[end-i+1:end])*dx
		end
		return y
	end;
	function pdf_sum_n_uniforms(n, dx=dx)
		x = pdf_vals
		y_old = x
		if n==1
			y_new = y_old
		else
			for i in 1:n-1
				y_new = conv_with_uniform(y_old, dx)
				y_old = y_new
			end
		end
		return y_new
	end;
	n = 10
	pdfs_sum_n_uniform = []
	for i in 2:n
		push!(pdfs_sum_n_uniform, pdf_sum_n_uniforms(i))
	end
	kld_with_normals = []
	for i in 2:n
		D_n_ = Normal(i/2, sqrt(i/12))
		push!(kld_with_normals, kld(pdfs_sum_n_uniform[i-1], pdf.(D_n_, x_range), dx))
	end
end;

# ╔═╡ 46b8c128-9224-11eb-293b-b92bc1535b84
begin
	plot(x_range, pdfs_sum_n_uniform, label=["n=2" "n=3" "n=4" "n=5" "n=6" "n=7" "n=8" "n=9" "n=10"], xlabel="x", ylabel="PDF : Sum of n Unif(0,1) RVs")
end

# ╔═╡ ee255f4e-922f-11eb-394e-95079b2fdcb0
begin
	plot(2:n, kld_with_normals, ylabel="KL Divergence", xlabel="n", title="KLD Sum of n Uniform RVs and Normal", label="")
end

# ╔═╡ a6eb7198-8d20-11eb-2981-e5bb980c64b0
md"### Question 3"

# ╔═╡ af728de2-8d20-11eb-37fc-975a0fe4e608
begin
	exp_sampler = Exponential(5)
	exp_samples = rand(exp_sampler, 50000)
	unif_sampler = Uniform(-12, 0)
	unif_samples= rand(unif_sampler, 50000)
	Random.seed!(0)
	all_samples = [exp_samples; unif_samples]
	[mean(all_samples), median(all_samples), skewness(all_samples)]	
end

# ╔═╡ 6eeb3916-8d29-11eb-27c0-d75a4dadb181
begin
	histogram(all_samples, title="Right skewed data with mean>median", nbins=100, color="light yellow", normalize=true, label="", xlabel="x", ylabel="Probability")
	h_ = fit(Histogram, Float64.(all_samples), nbins=100)
	val_, ind_ = findmax(h_.weights)
	edges_ = h_.edges[1]
	gap_ = edges_[2] - edges_[1]
	mode_1 = edges_[ind_] + (gap_/2)
	plot!([median(all_samples), median(all_samples)], [0, .06], label="Median", line=(2, :arrow, :black))
	plot!([mean(all_samples), mean(all_samples)], [0, .0415], label="Mean", line=(2, :arrow, :blue))
	plot!([mode_1, mode_1], [0, .091], label="Mode", line=(2, :arrow, :red))
end

# ╔═╡ 91c922a6-8cc6-11eb-1208-091e40e8f210
md"### Question 4"

# ╔═╡ ac65fd14-8cc6-11eb-3e6e-db2a3f4adca9
begin
	u_max = 1
	u_min = 0
	n_attempts = 100000
	n_samples_per_attempt = 30
	uniform_sampler = Uniform(u_min, u_max)
	function range_(array)
		return maximum(array) - minimum(array)
	end;
	Random.seed!(0)
	ranges = []
	for i in 1:n_attempts
		samples = rand(uniform_sampler, n_samples_per_attempt)
		push!(ranges, range_(samples))
	end
end;

# ╔═╡ 3e08f600-8cc8-11eb-2fe0-e93677c8fdcd
begin
	histogram(ranges, normalize=true, legend=:topleft, color="light yellow", title="Range of 30 samples : Uniform Distribution", nbins=100, label="")
	h = fit(Histogram, Float64.(ranges), nbins=100)
	val, ind = findmax(h.weights)
	edges = h.edges[1]
	gap = edges[2] - edges[1]
	mode_ = edges[ind] + (gap/2)
	plot!([median(ranges), median(ranges)], [0, 10], label="Median", line=(2, :arrow, :black))
	plot!([mean(ranges), mean(ranges)], [0, 9.1], label="Mean", line=(2, :arrow, :red))
	plot!([mode_, mode_], [0, 11.2], label="Mode", line=(2, :arrow, :blue))
end

# ╔═╡ 5a008fee-9310-11eb-2ece-17ec9315d5b7
[median(ranges), mean(ranges), mode_]

# ╔═╡ 3074b04e-8cc9-11eb-3245-bf956c875d23
md"### Question 5"

# ╔═╡ 6f9bad30-8cca-11eb-32d1-dbceb8edcb73
begin
	function CDF_comp_range_uniform(theta, n=n_samples_per_attempt)
		return 1 - theta^n - n*(1-theta)*theta^(n-1)
	end;
	precision = 10
	step_size = (u_max-u_min)/precision
	theta_vals = u_min:step_size:u_max
	count = 0
	p_vals = zeros(length(theta_vals))
	Random.seed!(0)
	for j = 1:n_attempts
		samples_ = rand(uniform_sampler, n_samples_per_attempt)
		for i in 1:length(theta_vals)
			if range_(samples_) >= theta_vals[i]
				p_vals[i] = p_vals[i]+1
			end	
		end
	end
	p_vals = p_vals./n_attempts
end;

# ╔═╡ 7f54296e-8cca-11eb-3bec-036411e1844b
begin
	plot(theta_vals, CDF_comp_range_uniform.(theta_vals), line=2, label="Theoretical Value", xlabel="theta", ylabel="P(range>=theta)", legend=:bottomleft)
	plot!(theta_vals, p_vals, line=(5, :orange, :dash), label="Empirical Estimate")
end

# ╔═╡ 718a05bc-9259-11eb-1dc0-131925f42d1c
md"### Question 6"

# ╔═╡ 798640fc-9259-11eb-3679-bfa9c3f46d14
begin
	df_ = CSV.File(HTTP.get("https://api.covid19india.org/csv/latest/states.csv").body) |> DataFrame
	start_date = df_[:, :Date][1]
	function difference_(column)
		return diff([0; column])
	end;
	function week_number(date, start_date = start_date)
		return Int(floor(((date - start_date).value)/7)+1)
	end
	df_1 = transform(df_, :Date => ByRow(dymd -> week_number(dymd)) => :week_number)
	df = select(df_1, Not([:Recovered, :Deceased, :Other, :Tested]))
	states_weeks = (combine(groupby(df, [:State, :week_number]), :Confirmed => maximum => :Confirmed))
	weekly_cases = transform(groupby(states_weeks, [:State]), :week_number, :Confirmed => difference_ => :weekly_cases)
	weekly_cases_ = select(weekly_cases, Not([:Confirmed]))
	final_df = (unstack(weekly_cases_, :State, :weekly_cases))
	for state in names(final_df)
	   final_df[!, state] = Missings.coalesce.(final_df[!, state], 0)
	end
	final_df = select(final_df, Not([Symbol("State Unassigned"), :India]))
end

# ╔═╡ 0cb3da56-92ee-11eb-3601-0fa8603985f6
begin
	col_names = names(final_df)[2:end]
	n_states = length(col_names)
	cov_mat = zeros(n_states, n_states)
	pearson_corr_mat = zeros(n_states, n_states)
	spearman_corr_mat = zeros(n_states, n_states)
	for i in 1:n_states
		for j in 1:n_states
			cov_mat[i,j] = cov(final_df[:, col_names[i]], final_df[:, col_names[j]])
			pearson_corr_mat[i,j] = cor(final_df[:, col_names[i]], final_df[:, col_names[j]])
			spearman_corr_mat[i,j] = corspearman(final_df[:, col_names[i]], final_df[:, col_names[j]])
		end
	end
end

# ╔═╡ 26924c8a-92f0-11eb-0747-35845548833d
heatmap(col_names, col_names, xrotation=45, cov_mat, title="Covariance")

# ╔═╡ 2efea3e6-92f5-11eb-1eb5-25cc9e9e2e16
heatmap(col_names, col_names, xrotation=45, pearson_corr_mat, title="Pearson Correlation")

# ╔═╡ 4488d9fc-92f5-11eb-04e9-a911af348be5
heatmap(col_names, col_names, xrotation=45, spearman_corr_mat, title="Spearman Correlation")

# ╔═╡ 40c7b9ae-8cca-11eb-0ecd-b9003874d46e
md"### Question 7"

# ╔═╡ 5a520812-8cd5-11eb-0f62-1f7a4be7cd63
begin
	OneSidedTail_n(x) = percentile(Normal(0,1), 100-x)
	OneSidedTail_T(x) = percentile(TDist(10), 100-x)
	D = Normal(0,1)
	T = TDist(10)
	x_ = 95
	yn = OneSidedTail_n(x_)
	yt = OneSidedTail_T(x_)
	[yn, yt]
end

# ╔═╡ 70cafd80-9208-11eb-3047-339c4135803b
begin
	plot(x -> x, x -> pdf(D, x), -10, yn, fillalpha=0.3, fill=(0, :orange), label = "Normal 5 percentile ", line=(1, :orange))
	plot!([yn, yn], [0, pdf(D, yn)], line = (:orange), label="")
	plot!(x -> x, x -> pdf(D, x), -10, 10, label = "Normal", line=(4, :orange))
	plot!(x -> x, x -> pdf(T, x), -10, yt, fillalpha=0.3, fill=(0, :black), label = "T dist 5 percentile", line=(1, :black))
	plot!([yt, yt], [0, pdf(T, yt)], line = (:black), label="")
	plot!(x -> x, x -> pdf(T, x), -10, 10, line=(4, :black, :dash), label="T dist")
end

# ╔═╡ Cell order:
# ╠═853ebf58-8cc3-11eb-1876-53f0b5c7fd31
# ╟─7d3f7fa6-8cc6-11eb-2122-e5ce7d7472c2
# ╠═aab08b16-8cc5-11eb-3bf8-cf0a71d32b37
# ╟─247e6484-8d22-11eb-02c5-e7edd6996cc0
# ╠═519162b4-9231-11eb-1a9a-396b22d9056c
# ╠═46b8c128-9224-11eb-293b-b92bc1535b84
# ╠═ee255f4e-922f-11eb-394e-95079b2fdcb0
# ╟─a6eb7198-8d20-11eb-2981-e5bb980c64b0
# ╠═af728de2-8d20-11eb-37fc-975a0fe4e608
# ╠═6eeb3916-8d29-11eb-27c0-d75a4dadb181
# ╟─91c922a6-8cc6-11eb-1208-091e40e8f210
# ╠═ac65fd14-8cc6-11eb-3e6e-db2a3f4adca9
# ╠═3e08f600-8cc8-11eb-2fe0-e93677c8fdcd
# ╠═5a008fee-9310-11eb-2ece-17ec9315d5b7
# ╟─3074b04e-8cc9-11eb-3245-bf956c875d23
# ╠═6f9bad30-8cca-11eb-32d1-dbceb8edcb73
# ╠═7f54296e-8cca-11eb-3bec-036411e1844b
# ╟─718a05bc-9259-11eb-1dc0-131925f42d1c
# ╠═798640fc-9259-11eb-3679-bfa9c3f46d14
# ╠═0cb3da56-92ee-11eb-3601-0fa8603985f6
# ╠═26924c8a-92f0-11eb-0747-35845548833d
# ╠═2efea3e6-92f5-11eb-1eb5-25cc9e9e2e16
# ╠═4488d9fc-92f5-11eb-04e9-a911af348be5
# ╟─40c7b9ae-8cca-11eb-0ecd-b9003874d46e
# ╠═5a520812-8cd5-11eb-0f62-1f7a4be7cd63
# ╠═70cafd80-9208-11eb-3047-339c4135803b
