### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 43383f74-71ea-11eb-3f58-5b673710c9d8
begin
	using Random
	using Distributions
	using Plots
	pyplot()
end

# ╔═╡ a659f1c2-71ea-11eb-1314-db0b6afb51c7
begin
	start_amount = 10
	n_days = 20
	n_p_vals = 19
	winning_amount = 1
	losing_amount = 1
end

# ╔═╡ a8f0c686-71ea-11eb-36ae-b33d484a59df
p_vals = LinRange(0, 0.9, n_p_vals)

# ╔═╡ b2e573c6-71ec-11eb-31b7-ff3a90d37332
md"The above values of probability have been chosen based on approximately the number of times the player did not get bankrupt for a given value of probability. Clearly choosing p=1 does not make any sense as the player will get always bankrupt and the conditional probability is not defined. For a million trials, p=0.95 had approximately 300 times when the player did not get bankrupt and p=0.9 or lower had more than 10000 times when the player did not get bankrupt. Clearly the conditional probability estimates for p=0.95 will be very unreliable compared to the estimates for p=0.9 or lower. Hence we limit p to take a maximum value of 0.9"

# ╔═╡ c315efca-71ea-11eb-1174-db71c03c2687
n_trials = 10^6

# ╔═╡ fcf4de0a-71ee-11eb-12bd-9bd96f41fae2
md"Let's calculate the minimum number of wins to maintain the amount in the start"

# ╔═╡ fa29212c-71ee-11eb-35d7-a3b5bb0489b0
min_wins = ceil(losing_amount*n_days/(losing_amount+winning_amount))

# ╔═╡ addb57bc-71ea-11eb-2096-65730783e9fa
conditional_probabilities = zeros(n_p_vals)

# ╔═╡ 8f755928-71eb-11eb-2849-8799d6a66705
begin
	for i in 1:n_p_vals
		p_val = p_vals[i]
		sampler = Bernoulli(1-p_val)
		count = 0
		Random.seed!(0)
		times_not_bankrupt = 0
		count = 0
		for j in 1:n_trials
			bankrupt = 0
			outcomes = rand(sampler, n_days)
			pres_sum = start_amount
			for j in 1:n_days
				if outcomes[j]
					pres_sum+=winning_amount
				else
					pres_sum-=losing_amount
				end
				if pres_sum<=0
					bankrupt += 1
					continue
				end
			end
			if bankrupt<=0
				times_not_bankrupt+=1
				if sum(outcomes)>=min_wins
					count+=1
				end
			end
		end
		conditional_probabilities[i] = count/times_not_bankrupt
	end
end

# ╔═╡ b37b3a66-71ef-11eb-2222-01ef9fe8401e
plot(p_vals, conditional_probabilities, xlabel="Value of p", ylabel = "Conditional probabilities")

# ╔═╡ Cell order:
# ╠═43383f74-71ea-11eb-3f58-5b673710c9d8
# ╠═a659f1c2-71ea-11eb-1314-db0b6afb51c7
# ╠═a8f0c686-71ea-11eb-36ae-b33d484a59df
# ╟─b2e573c6-71ec-11eb-31b7-ff3a90d37332
# ╠═c315efca-71ea-11eb-1174-db71c03c2687
# ╟─fcf4de0a-71ee-11eb-12bd-9bd96f41fae2
# ╠═fa29212c-71ee-11eb-35d7-a3b5bb0489b0
# ╠═addb57bc-71ea-11eb-2096-65730783e9fa
# ╠═8f755928-71eb-11eb-2849-8799d6a66705
# ╠═b37b3a66-71ef-11eb-2222-01ef9fe8401e
