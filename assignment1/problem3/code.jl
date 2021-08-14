### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 42b88096-733d-11eb-1895-7d3f04ad5948
using PlutoUI

# ╔═╡ d014cbc2-71f1-11eb-19b2-3d29fcd8c1d4
begin
	using Random
	using Plots
	using StatsBase
	using Distributions
	pyplot()
end

# ╔═╡ 6bb0c94a-733d-11eb-254b-d721ad6e2a54
@bind run_again_replacement Button("Run again replacement experiment")

# ╔═╡ 7112d5f4-733d-11eb-0092-31a2fb8b5b3c
@bind run_again_non_replacement Button("Run again without replacement experiment")

# ╔═╡ 4bc4d018-733d-11eb-151c-8dd3950a2a36
begin
	run_again_replacement
	run_again_non_replacement
	n_experiments = 10^7
end

# ╔═╡ 79d40262-733d-11eb-0930-dbc437e74a06
begin
	card_indices = 1:52
	jack_indices = [10, 20, 30, 40]
	n_cards_to_draw = 5
end

# ╔═╡ 80871d6a-733d-11eb-0c20-d9fae3380f85
md"**With Replacement**"

# ╔═╡ 86a1a51e-733d-11eb-2840-ed600f399b04
begin
	run_again_replacement
	counts = zeros(n_cards_to_draw+1)
	Random.seed!(0)
	for i in 1:n_experiments
		cards_drawn = sample(card_indices, n_cards_to_draw, replace=true)
		n_jacks_drawn = 0
		for j in 1:n_cards_to_draw
			if cards_drawn[j] in jack_indices
				n_jacks_drawn+=1
			end
		end
		counts[n_jacks_drawn+1]+=1
	end
	counts./=n_experiments
end

# ╔═╡ cd07f7ba-733d-11eb-1c31-25864b755a0a
begin
	sampler = Binomial(n_cards_to_draw, length(jack_indices)/length(card_indices))
	theoretical_probability_vals = zeros(n_cards_to_draw+1)
	for i in 0:n_cards_to_draw
		theoretical_probability_vals[i+1] = pdf(sampler, i)
	end
end

# ╔═╡ 9d5582f0-733e-11eb-2615-cb01ede7b45f
begin
	run_again_replacement
	absolute_difference = abs.(counts .- theoretical_probability_vals)
	relative_difference = absolute_difference./theoretical_probability_vals
end

# ╔═╡ 7a11cfc6-733f-11eb-0131-530518c06b54
md"Let us look at the plots of the absolute and relative differences between the theoretical and estimated probability values when we draw cards with replacement."

# ╔═╡ 3efd7ed2-733f-11eb-0598-014711bbaeec
plot(0:n_cards_to_draw, absolute_difference, xlabel="Number of Jacks Drawn with Replacement", ylabel = "Absolute differences")

# ╔═╡ a7faf18a-733f-11eb-11ff-5db30864797d
plot(0:n_cards_to_draw, relative_difference, xlabel="Number of Jacks Drawn with Replacement", ylabel = "Relative differences")

# ╔═╡ bc31b670-733f-11eb-338e-2d7c857ce202
md"Quite clearly the relative differences increase with the number of jacks to be drawn. This is because the probability of n jacks being drawn decreases with n. For n=5 especially, the probabilities are so small that such an event occurs very rarely. The probability estimate is hence, unreliable. This can be taken care of by increasing the number of trials by few orders of magnitude, but that is computationally limiting."

# ╔═╡ 46812130-7340-11eb-2967-6f821d94ed9d
md"**Without Replacement**"

# ╔═╡ 4edbb994-7340-11eb-00bf-0ba69f01aca2
begin
	run_again_non_replacement
	counts_ = zeros(n_cards_to_draw+1)
	Random.seed!(0)
	for i in 1:n_experiments
		cards_drawn = sample(card_indices, n_cards_to_draw, replace=false)
		n_jacks_drawn = 0
		for j in 1:n_cards_to_draw
			if cards_drawn[j] in jack_indices
				n_jacks_drawn+=1
			end
		end
		counts_[n_jacks_drawn+1]+=1
	end
	counts_./=n_experiments
end

# ╔═╡ 5ac2c68a-7340-11eb-113a-0d13ba156c8a
begin
	sampler_ = Hypergeometric(length(jack_indices), length(card_indices) - length(jack_indices), n_cards_to_draw)
	theoretical_probability_vals_ = zeros(n_cards_to_draw+1)
	for i in 0:n_cards_to_draw
		theoretical_probability_vals_[i+1] = pdf(sampler_, i)
	end
end

# ╔═╡ b4fc0fbe-7340-11eb-320b-dbd7e6ed23cd
begin
	run_again_non_replacement
	absolute_difference_ = abs.(counts_ .- theoretical_probability_vals_)
	relative_difference_ = absolute_difference_[1:n_cards_to_draw]./theoretical_probability_vals_[1:n_cards_to_draw]
end

# ╔═╡ 7c5a559e-7341-11eb-390c-297df4c3a517
md"Let us look at the plots of the absolute and relative differences between the theoretical and estimated probability values when we draw cards without replacement. Please note that the relative difference have been plotted only for the case when we draw between 0 to 4 jacks. The probability of drawing 5 jacks is 0 for both the theoretical and experimental cases and hence the relative differnce there is  NaN."

# ╔═╡ 92153b62-7341-11eb-0aea-b796acdf9e29
plot(0:n_cards_to_draw, absolute_difference_, xlabel="Number of Jacks Drawn without Replacement", ylabel = "Absolute differences")

# ╔═╡ ad0b195a-7341-11eb-1982-07f1e475316e
plot(0:(n_cards_to_draw-1), relative_difference_, xlabel="Number of Jacks Drawn without Replacement", ylabel = "Relative differences")

# ╔═╡ 513ff566-7342-11eb-1300-8743f89dd9b7
md"Quite clearly the relative differences increase with the number of jacks to be drawn. This is most noticeable for n=4. The increase can be explained similar to that of drawing cards with replacement."

# ╔═╡ Cell order:
# ╠═42b88096-733d-11eb-1895-7d3f04ad5948
# ╠═d014cbc2-71f1-11eb-19b2-3d29fcd8c1d4
# ╠═6bb0c94a-733d-11eb-254b-d721ad6e2a54
# ╠═7112d5f4-733d-11eb-0092-31a2fb8b5b3c
# ╠═4bc4d018-733d-11eb-151c-8dd3950a2a36
# ╠═79d40262-733d-11eb-0930-dbc437e74a06
# ╟─80871d6a-733d-11eb-0c20-d9fae3380f85
# ╠═86a1a51e-733d-11eb-2840-ed600f399b04
# ╠═cd07f7ba-733d-11eb-1c31-25864b755a0a
# ╠═9d5582f0-733e-11eb-2615-cb01ede7b45f
# ╟─7a11cfc6-733f-11eb-0131-530518c06b54
# ╠═3efd7ed2-733f-11eb-0598-014711bbaeec
# ╠═a7faf18a-733f-11eb-11ff-5db30864797d
# ╟─bc31b670-733f-11eb-338e-2d7c857ce202
# ╟─46812130-7340-11eb-2967-6f821d94ed9d
# ╠═4edbb994-7340-11eb-00bf-0ba69f01aca2
# ╠═5ac2c68a-7340-11eb-113a-0d13ba156c8a
# ╠═b4fc0fbe-7340-11eb-320b-dbd7e6ed23cd
# ╟─7c5a559e-7341-11eb-390c-297df4c3a517
# ╠═92153b62-7341-11eb-0aea-b796acdf9e29
# ╠═ad0b195a-7341-11eb-1982-07f1e475316e
# ╟─513ff566-7342-11eb-1300-8743f89dd9b7
