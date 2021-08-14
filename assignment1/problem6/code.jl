### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ b4c73bf6-7152-11eb-1d08-97725e7edcc2
begin
	using Random
	using Distributions
	using Plots
	pyplot()
end

# ╔═╡ 10bd9dcc-7153-11eb-0cb6-85af34fcf01d
begin
	start_amount = 10
	n_days = 20
	n_p_vals = 21
	winning_amount = 1
	losing_amount = 1
end

# ╔═╡ 2c840304-7153-11eb-2b89-15f8edb18a7f
p_vals = LinRange(0, 1.0, n_p_vals)

# ╔═╡ 157516fc-7154-11eb-00e1-c9d20194d989
md"Let's calculate the minimum number of wins to maintain the amount in the start"

# ╔═╡ 6636a76a-7154-11eb-3173-73187202118a
min_wins = ceil(losing_amount*n_days/(losing_amount+winning_amount))

# ╔═╡ 5c1e6da0-715a-11eb-0947-c340017a5917
n_trials = 10^6

# ╔═╡ 6fa06f20-715a-11eb-0550-79aa288b922b
probability_to_have_at_least_10 = zeros(n_p_vals)

# ╔═╡ 8efac20a-715a-11eb-3d89-9ff403db89fd
begin
	for i in 1:n_p_vals
		p_val = p_vals[i]
		sampler = Bernoulli(1-p_val)
		Random.seed!(0)
		count = 0
		for j in 1:n_trials
			outcomes = rand(sampler, n_days)
			if sum(outcomes)>=min_wins
				count+=1
			end
		end
		probability_to_have_at_least_10[i] = count/n_trials
	end
end

# ╔═╡ 6838ea6c-715b-11eb-1d6c-9b306b4b0dbd
plot(p_vals, probability_to_have_at_least_10, xlabel="Value of p", ylabel = "Probability of ending up with at least 10")

# ╔═╡ Cell order:
# ╠═b4c73bf6-7152-11eb-1d08-97725e7edcc2
# ╠═10bd9dcc-7153-11eb-0cb6-85af34fcf01d
# ╠═2c840304-7153-11eb-2b89-15f8edb18a7f
# ╟─157516fc-7154-11eb-00e1-c9d20194d989
# ╠═6636a76a-7154-11eb-3173-73187202118a
# ╠═5c1e6da0-715a-11eb-0947-c340017a5917
# ╠═6fa06f20-715a-11eb-0550-79aa288b922b
# ╠═8efac20a-715a-11eb-3d89-9ff403db89fd
# ╠═6838ea6c-715b-11eb-1d6c-9b306b4b0dbd
