### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ e9ae9f40-af72-11eb-3147-af2618a2e8c6
begin
	using Plots
	plotly()
	using StatsBase
	using Distributions
	using StatsPlots
	using Random
	using QuadGK
end

# ╔═╡ acdb785e-0d73-4a9b-80a6-38aa2292ddf1
md"### Import Modules"

# ╔═╡ 8bfd8973-e205-4012-9a45-7827bdecb6a4
md"### Question 1"

# ╔═╡ 57a6a759-1916-4ea4-8279-883ca2a99f86
begin
	Random.seed!(8)
	n_samples_q1 = 1000000
	sampler_q1 = Binomial(50, 0.5)
	p_q1 = sum(rand(sampler_q1, n_samples_q1).>=30)/n_samples_q1
end

# ╔═╡ 19dbe212-b7bb-4006-bc69-a971a2c02f8e
md"### Question 2"

# ╔═╡ f20f02b7-9801-4c86-a6a5-acc2bdf13705
begin
	Random.seed!(8)
	n_samples_q2 = 1000000
	sampler_q2 = Binomial(50, 0.59)
	p_q2 = sum(rand(sampler_q2, n_samples_q2).>=30)/n_samples_q2
end

# ╔═╡ b8205e05-7250-4f06-9dd5-8132b298f41a
1-cdf(Binomial(50, 0.59), 29)

# ╔═╡ 8243344d-2be6-4e3b-8cb7-f13bbf912b88
md"### Question 3"

# ╔═╡ d9da30f6-01b1-4b63-bb95-efb6f9f680eb
begin
	Z_q3 = Normal(0,1)
	n_q3 = 1
	while cdf(Z_q3, (3000-100*n_q3)/(30*sqrt(n_q3))) >= 0.05
		n_q3 += 1
	end
	n_q3, cdf(Z_q3, (3000-100*n_q3)/(30*sqrt(n_q3)))
end

# ╔═╡ 20e04fe1-58f8-4d3a-9ee8-baf5d7f06046
md"### Question 4"

# ╔═╡ 1ba6a35e-306c-4c79-84ec-a3bc98f29e5a
function standard_normal_moments(x_range = 10, precision = 10^-15)
	Z = Normal(0,1)
	m1 = mean(Z)
	m2 = std(Z)
	m3 = quadgk((x -> x^3*pdf(Z, x)), -x_range, x_range)[1]
	if m3 < precision
		m3  = 0
	end
	m4 = quadgk((x -> x^4*pdf(Z, x)), -x_range, x_range)[1]
	return m1, m2, m3, m4
end;

# ╔═╡ 4c47ae7d-66ed-41ac-b2d5-0e17627055d0
function dist_moments(dist_type, dist_params, x_range=60)
	if dist_type == "Bernoulli"
		m1, m2, m3, m4 = dist_params, dist_params, dist_params, dist_params
	elseif dist_type == "Uniform"
		a, b = dist_params[1], dist_params[2]
		m1, m2, m3, m4 = [(b^(n+1)-a^(n+1))/((n+1)*(b-a)) for n in 1:4]
	elseif dist_type == "Chi Squared"
		n_dof = dist_params
		dist = Chisq(n_dof)
		m1 = mean(dist)
		m2 = var(dist) + m1^2
		m3 = quadgk((x -> x^3*pdf(dist, x)), 0, x_range)[1]
		m4 = quadgk((x -> x^4*pdf(dist, x)), 0, x_range)[1]
	end
	return m1, m2, m3, m4
end;

# ╔═╡ ee829fde-f910-46a7-b15f-9b27a59916c1
function CLT_moments(n, m1, m2, m3, m4)
	sigma_n = sqrt(n*(m2-m1^2))
	tm1 = 0
	tm2 = (m2 - m1^2)/(sigma_n^2)
	tm3 = (m3 + 3*m1^3 - 3*m1*m2 -m1^3)/(sigma_n^3)
	tm4 = (m4 - 4*m1*m3 + 6*m1^2*m2 - 3*m1^4)/(sigma_n^4)
	
	dist_m3 = n*tm3
	dist_m4 = n*tm4 + 3*n*(n-1)*tm2^2
	return dist_m3, dist_m4
end;

# ╔═╡ e71033bd-991c-4cba-b267-16d70012a585
begin
	function CLT_convergence(dist_type, dist_params, prec=0.1)
		dm1, dm2, dm3, dm4 = dist_moments(dist_type, dist_params)
		_, _, norm3, norm4 = standard_normal_moments()
		n=1
		m3_errors = []
		m4_errors = []
		e3 = Inf
		e4 = Inf
		while e3>prec || e4>prec
			new_m3, new_m4 = CLT_moments(n, dm1, dm2, dm3, dm4)
			e3, e4 = abs(new_m3 - norm3), abs(new_m4 - norm4)
			push!(m3_errors, e3)
			push!(m4_errors, e4)
			n+=1
		end
		return length(m3_errors), m3_errors, m4_errors
	end
	n_a, e3_a, e4_a = CLT_convergence("Uniform", [0, 1])
	n_b, e3_b, e4_b = CLT_convergence("Bernoulli", 0.01)
	n_c, e3_c, e4_c = CLT_convergence("Bernoulli", 0.5)
	n_d, e3_d, e4_d = CLT_convergence("Chi Squared", 3)
end;

# ╔═╡ ab5b3df3-a227-46e9-ba77-4eaaa474b7bb
begin
	plot(1:n_a, e3_a, title="CLT: Uniform (0,1)", xlabel="Number of Samples", ylabel="Absolute Errors", label="3rd moment")
	plot!(1:n_a, e4_a, label="4rd moment")
end

# ╔═╡ 9d70b26e-7f3b-4f21-afc2-69aa49829663
begin
	plot(1:n_b, e3_b, title="CLT: Binomial p=0.01", xlabel="Number of Samples", ylabel="Absolute Errors", label="3rd moment")
	plot!(1:n_b, e4_b, label="4rd moment")
end

# ╔═╡ 5e72e82b-1816-40fc-bf14-cefa1fcca0d4
begin
	plot(1:n_c, e3_c, title="CLT: Binomial p=0.5", xlabel="Number of Samples", ylabel="Absolute Errors", label="3rd moment")
	plot!(1:n_c, e4_c, label="4rd moment")
end

# ╔═╡ 7d46d28f-ad82-433c-9ff0-56eaf08a4fc5
begin
	plot(1:n_d, e3_d, title="CLT: Chi Squared 3", xlabel="Number of Samples", ylabel="Absolute Errors", label="3rd moment")
	plot!(1:n_d, e4_d, label="4rd moment")
end

# ╔═╡ f9b8b88b-dd42-4bfd-aa7f-b29d9a3fb60a
n_a, n_b, n_c, n_d

# ╔═╡ Cell order:
# ╟─acdb785e-0d73-4a9b-80a6-38aa2292ddf1
# ╠═e9ae9f40-af72-11eb-3147-af2618a2e8c6
# ╟─8bfd8973-e205-4012-9a45-7827bdecb6a4
# ╠═57a6a759-1916-4ea4-8279-883ca2a99f86
# ╟─19dbe212-b7bb-4006-bc69-a971a2c02f8e
# ╠═f20f02b7-9801-4c86-a6a5-acc2bdf13705
# ╠═b8205e05-7250-4f06-9dd5-8132b298f41a
# ╟─8243344d-2be6-4e3b-8cb7-f13bbf912b88
# ╠═d9da30f6-01b1-4b63-bb95-efb6f9f680eb
# ╟─20e04fe1-58f8-4d3a-9ee8-baf5d7f06046
# ╠═1ba6a35e-306c-4c79-84ec-a3bc98f29e5a
# ╠═4c47ae7d-66ed-41ac-b2d5-0e17627055d0
# ╠═ee829fde-f910-46a7-b15f-9b27a59916c1
# ╠═e71033bd-991c-4cba-b267-16d70012a585
# ╠═ab5b3df3-a227-46e9-ba77-4eaaa474b7bb
# ╠═9d70b26e-7f3b-4f21-afc2-69aa49829663
# ╠═5e72e82b-1816-40fc-bf14-cefa1fcca0d4
# ╠═7d46d28f-ad82-433c-9ff0-56eaf08a4fc5
# ╠═f9b8b88b-dd42-4bfd-aa7f-b29d9a3fb60a
