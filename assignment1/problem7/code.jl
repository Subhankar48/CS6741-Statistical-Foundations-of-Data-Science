### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ fd7fb484-7160-11eb-2d1d-bdf1bd53ebcc
begin
	using Random
	using Distributions
	using Plots
	pyplot()
end

# ╔═╡ 20575514-7161-11eb-0809-b1eee35b8dc4
begin
	start_amount = 10
	n_days = 20
	n_p_vals = 21
	winning_amount = 1
	losing_amount = 1
end

# ╔═╡ 33522650-7161-11eb-073f-4d6d43ee7bd0
p_vals = LinRange(0, 1.0, n_p_vals)

# ╔═╡ 385e9faa-7161-11eb-2a42-cd4bcd3f9426
n_trials = 10^6

# ╔═╡ cebea5ca-7162-11eb-12ac-5b84fc9e4900
probability_to_have_at_least_once_bankrupt = zeros(n_p_vals)

# ╔═╡ 4647b214-7161-11eb-395c-e768974a7325
begin
	for i in 1:n_p_vals
		p_val = p_vals[i]
		sampler = Bernoulli(1-p_val)
		count = 0
		Random.seed!(0)
		n_times_bankrupt = 0
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
			if bankrupt>0
				n_times_bankrupt+=1
			end
		end
		probability_to_have_at_least_once_bankrupt[i] = n_times_bankrupt/n_trials
	end
end

# ╔═╡ 2db1cbd4-7163-11eb-244b-fb0c62f0c772
plot(p_vals, probability_to_have_at_least_once_bankrupt, xlabel="Value of p", ylabel = "Probability of getting bankrupt at least once")

# ╔═╡ Cell order:
# ╠═fd7fb484-7160-11eb-2d1d-bdf1bd53ebcc
# ╠═20575514-7161-11eb-0809-b1eee35b8dc4
# ╠═33522650-7161-11eb-073f-4d6d43ee7bd0
# ╠═385e9faa-7161-11eb-2a42-cd4bcd3f9426
# ╠═cebea5ca-7162-11eb-12ac-5b84fc9e4900
# ╠═4647b214-7161-11eb-395c-e768974a7325
# ╠═2db1cbd4-7163-11eb-244b-fb0c62f0c772
