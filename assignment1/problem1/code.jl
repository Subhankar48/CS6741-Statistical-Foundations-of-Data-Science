### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 783b550e-707f-11eb-324d-07ccd4de1f2e
begin
	using Random
	using Plots
	pyplot()
end

# ╔═╡ d396c3f4-707f-11eb-2bff-05e2ecd1590d
begin
	range = -1000:1000
	n_samples = 10^7
end

# ╔═╡ d9fd91fe-7080-11eb-150a-9dccb13c4da2
begin
	Random.seed!(0)
	exp_ints = rand(range, n_samples)
	means = []
	init = 0
	for i in 1:n_samples
	    sample = exp_ints[i]
		init += sample
		push!(means, init/i)
	end
end

# ╔═╡ df9a9660-708b-11eb-2b80-c338f0ded6bf
plot(1:n_samples, means, xlabel="Number of Samples", ylabel="Mean")

# ╔═╡ Cell order:
# ╠═783b550e-707f-11eb-324d-07ccd4de1f2e
# ╠═d396c3f4-707f-11eb-2bff-05e2ecd1590d
# ╠═d9fd91fe-7080-11eb-150a-9dccb13c4da2
# ╠═df9a9660-708b-11eb-2b80-c338f0ded6bf
