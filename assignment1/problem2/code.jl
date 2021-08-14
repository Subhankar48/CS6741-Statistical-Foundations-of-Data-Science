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

# ╔═╡ dcf49dee-7116-11eb-35df-457a13adafaa
using PlutoUI

# ╔═╡ e65052f4-710f-11eb-226f-1752e21e84ba
begin
	using Random
	using Plots
	using StatsBase
	pyplot()
end

# ╔═╡ bd3395d0-7116-11eb-299b-3b8e2f154150
@bind run_again_replacement Button("Run again replacement experiment")

# ╔═╡ 5069b672-7117-11eb-3617-ebe3f1448e03
@bind run_again_non_replacement Button("Run again without replacement experiment")

# ╔═╡ 54b739d8-7110-11eb-30f4-ad1b11dda698
Random.seed!(0)

# ╔═╡ bb37b3cc-7110-11eb-249f-f1f3c541926f
begin
	run_again_replacement
	run_again_non_replacement
	n_experiments = 10^7
end

# ╔═╡ a5572920-7110-11eb-3195-9bb705df926b
begin
	card_indices = 1:52
	jack_indices = [10, 20, 30, 40]
	n_cards_to_draw = 5
end

# ╔═╡ 59f9de96-7110-11eb-29ca-35a73c3c51ab
md"**With Replacement**"

# ╔═╡ 1ca61a34-7113-11eb-22f4-095d19ec748e
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

# ╔═╡ a58c1c0c-7113-11eb-25f7-c30459e39e7c
begin
	run_again_replacement
	plot(0:n_cards_to_draw, counts, xlabel="Number of Jacks Drawn with Replacement", ylabel="Probability")
end

# ╔═╡ ba950b68-7115-11eb-13b6-ffe94099e7ec
md"**Without Replacement**"

# ╔═╡ 36331fec-7118-11eb-0956-e16a37f156ca
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

# ╔═╡ 64fdf1ee-7118-11eb-0434-d9a604eee2f3
begin
	run_again_non_replacement
	plot(0:n_cards_to_draw, counts_, xlabel="Number of Jacks Drawn without Replacement", ylabel="Probability")
end

# ╔═╡ Cell order:
# ╠═dcf49dee-7116-11eb-35df-457a13adafaa
# ╠═e65052f4-710f-11eb-226f-1752e21e84ba
# ╟─bd3395d0-7116-11eb-299b-3b8e2f154150
# ╟─5069b672-7117-11eb-3617-ebe3f1448e03
# ╟─54b739d8-7110-11eb-30f4-ad1b11dda698
# ╠═bb37b3cc-7110-11eb-249f-f1f3c541926f
# ╠═a5572920-7110-11eb-3195-9bb705df926b
# ╟─59f9de96-7110-11eb-29ca-35a73c3c51ab
# ╠═1ca61a34-7113-11eb-22f4-095d19ec748e
# ╠═a58c1c0c-7113-11eb-25f7-c30459e39e7c
# ╟─ba950b68-7115-11eb-13b6-ffe94099e7ec
# ╠═36331fec-7118-11eb-0956-e16a37f156ca
# ╠═64fdf1ee-7118-11eb-0434-d9a604eee2f3
