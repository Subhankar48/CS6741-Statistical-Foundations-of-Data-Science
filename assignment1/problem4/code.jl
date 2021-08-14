### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ edef2a12-711e-11eb-1577-df0aa8d43759
using Random

# ╔═╡ 61b2cb8e-711f-11eb-002d-a5def16f30ef
chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`']

# ╔═╡ 6eb0163e-711f-11eb-044e-1bdadeb31049
password_length = 8

# ╔═╡ 4788c5da-7122-11eb-1e29-c3a98b36753d
begin
	Random.seed!(0)
	password = rand(chars, password_length)
end

# ╔═╡ 76c808ec-7122-11eb-1bc5-df02e222cc29
function compare_strings(str1, str2, n_similarity)
	count = 0
	for i in 1:min(length(str1), length(str2))
		if str1[i] == str2[i]
			count+=1
		end
	end
	if count>=n_similarity
		return true
	else
		return false
	end
end

# ╔═╡ 131be614-7123-11eb-370d-0f37b540f3b4
similarity_threshold = 2

# ╔═╡ 6d8cd15e-714c-11eb-14e5-9da91578813e
n_experiments = 10^8

# ╔═╡ 658f237a-7123-11eb-3cb8-55270653de7c
begin
	matches = 0
	Random.seed!(0)
	for i in 1:n_experiments
		attempted_password = rand(chars, password_length)
		if compare_strings(attempted_password, password, similarity_threshold)
			matches+=1
		end
	end
	p_match = matches/n_experiments
end

# ╔═╡ 5bf82614-714f-11eb-2bd1-87970bade160
md"The probability of matching at least 2 characters with the correct password is : $p_match"

# ╔═╡ 06ccd6c8-7152-11eb-0d99-e902ab254a85
md"The number of passwords saved after $n_experiments attempts is $matches "

# ╔═╡ Cell order:
# ╠═edef2a12-711e-11eb-1577-df0aa8d43759
# ╠═61b2cb8e-711f-11eb-002d-a5def16f30ef
# ╠═6eb0163e-711f-11eb-044e-1bdadeb31049
# ╠═4788c5da-7122-11eb-1e29-c3a98b36753d
# ╠═76c808ec-7122-11eb-1bc5-df02e222cc29
# ╠═131be614-7123-11eb-370d-0f37b540f3b4
# ╠═6d8cd15e-714c-11eb-14e5-9da91578813e
# ╠═658f237a-7123-11eb-3cb8-55270653de7c
# ╟─5bf82614-714f-11eb-2bd1-87970bade160
# ╟─06ccd6c8-7152-11eb-0d99-e902ab254a85
