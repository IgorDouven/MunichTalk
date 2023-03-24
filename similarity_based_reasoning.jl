### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ e9ad8158-4831-11eb-3f2a-dd8b77360abe
begin
	using LinearAlgebra
	using Distributions
	using StatsBase
	using DataFrames
	using ImageFiltering
	using Parameters
	using LazySets
	using KernelDensity
	using Gadfly
	using Cairo
	using Compose
	using Colors
	using ColorSchemes
	using PlutoUI
end

# ╔═╡ f0212ad0-7c3c-416e-901b-eab9c5f36f78
html"<button onclick='present()'>present</button>"

# ╔═╡ f9cb81d4-4831-11eb-1d1a-756179fc8ee8
md"# Analogical reasoning: A Carnapian approach"

# ╔═╡ b1d604d1-c928-44d0-aaec-68e98004cc2b
md"Igor Douven (IHPST/CNRS)"

# ╔═╡ 8ceff4fd-1bd4-43c5-9e3e-b32371445049
md"## What is analogical reasoning?"

# ╔═╡ 1afcda13-9b9a-4f4d-8b1d-862337958ccd
md"""
Analogical reasoning is reasoning exploiting similarity relations.

It is ampliative in that the truth of the conclusion we reach through analogical reasoning is not guaranteed by the truth of the premises.

It is related to inductive reasoning (in ways to be seen), but still different from it.

Students of analogical reasoning face two tasks: 
1. making precise the role similarity plays in analogical inferences, in particular clarifying the connection between similarity and strength of inference, and 
1. elucidating the normative status of such inferences.
"""

# ╔═╡ 596aa39b-1647-40e6-93f8-9d9c9fe73433
md"## Analogical reasoning: an example"

# ╔═╡ e0c0ab17-3c85-4712-8c8e-49da9fae264e
md"""
> Alice is into fashion. She particularly likes shoes, a lot. She has over forty pairs and regularly buys new ones. You have seen most of the pairs she owns. Of those, the majority were red or reddish, some were orange or orangish, and a couple of them were pink or pinkish. Also, of the pairs you have seen, most were ballet flats and the remaining ones were stilettos.

What color do you expect Alice's other shoes to have? Probably, you will expect most of them to be some shade of red, perhaps some to be a shade of orange. You may reckon with the possibility that she has one or two further pairs of pink shoes. By contrast, you would be surprised if Alice owned any green, or blue, or gray, pairs. You would be particularly surprised to see her wear gray pumps or white sneakers or black cowboy boots.
"""

# ╔═╡ 95bcb0b1-3121-4ec7-812a-2109032b5f22
md"## Syntactic approaches and their limitations (I)"

# ╔═╡ 05dbf06c-8d3e-43b6-b4f0-09e13851adcc
md"""
The success story of deductive logic: a highly complex notion--logical truth--can be reduced to finite tinkering in a system that freshmen can familiarize themselves with in just a couple of weeks.

So not unreasonable to look for a logic of uncertain reasoning (inductive logic) that defines valid inference in purely syntactic terms as well.

Also reasonable to think that this might work for analogical reasoning if that is conceived as relying on (number of) shared properties between objects:
> [Le] raisonnement par analogie consiste en une augmentation de la conviction que [l'objet] _X_₂ possède une qualité _Cₖ_ commune avec [l'objet] _X_₁, après avoir constaté que _X_₂ possède aussi certaines autres qualités _Cᵢ_ communes avec _X_₁. (Lindenbaum-Hosiasson, 1941)
"""

# ╔═╡ e874eb1c-ba9d-4ba4-8052-e8bb0f83d8ef
md"## Syntactic approaches and their limitations (II)"

# ╔═╡ 3601e822-d730-4973-ac3b-4fed81212f98
md"""
Carnap and others expanded on this idea: inductive (including analogical) reasoning cannot _quite_ be defined in terms of number of shared predicates that apply--more is needed, for instance to arrive at prior probabilities--but in general the approach should work.

But critics came up with plenty of reasons to doubt this:
- Goodman argued that, from a syntactic viewpoint, there is no difference between 'grue' and 'green'; nevertheless we do not think that the finding of a grue emerald (before a certain point in time) should do as much to confirm 'All emeralds are grue' as the finding of a green emerald should do to confirm 'All emeralds are green'.
- More general objection raised by Hájek: choice of language remains entirely arbitrary in Carnap's work on inductive logic.

Specifically with regard to analogical reasoning: Given what we know about Alice's shoes, we do not expect her to buy ochre moccasins any time soon. Nevertheless, we find that a still more likely possibility than her buying brown sneakers, which in turn we find more likely than her buying black cowboy boots. Presumably, that is because ochre moccasins are both in color and in shape similar to shoes Alice already possesses: ochre is not so different from orange, and moccasins are somewhat similar in shape to ballet flats, while black cowboy boots, on the other hand, are very different, in color as well as in shape, from any of the shoes we know Alice to possess. This reasoning is not readily expressed in terms of shared and non-shared properties (see also Goodman on similarity).
"""

# ╔═╡ b17f2ac9-7351-46ed-901b-464ce2fd53aa
md"## Two (or three) models of similarity"

# ╔═╡ c137ed82-6835-4f94-a495-a5a6f38f5abc
md"""
We are going to use a geometric approach to similarity in the following.

The first approaches of this kind were no success: they tried to represent **overall** similarity in one similarity space.

This made it difficult to account for empirically established facts concerning how people judge similarity, in particular, for asymmetries and context dependence in/of such judgments.

This led Tversky to propose his set-theoretic model of similarity, which focuses on _relevant_ proporties and even allows those properties to differ in _salience_. But Tversky's model faces the earlier-mentioned problem that similarity is **not** always a matter of shared and non-shared properties.

Improved geometric approach: abandon idea of **overall** similarity space and replace it with that of having separate spaces per aspect of comparison (color space, taste space, shape space, ...). Asymmetry/context-dependence can be explained in terms of activation of different spaces, selection of subspaces, transformations of axes, ...

NB: No one ever claimed that we will not need more than one account of similarity to explain all phenomena related to similarity.
"""

# ╔═╡ e33bc9b3-7870-4493-978e-4f572de528bd
md" ## Carnap's late work on inductive logic"

# ╔═╡ f8db1ee4-4951-11eb-0b96-693fbd71657f
md"""
In his late inductive logic, published posthumously and not in fully final form, Carnap abandoned his project to define inductive logic in strictly syntactical terms and tried to exploit something like the refined geometric model of similarity.

Specifically, he appealed to *attribute spaces*, which remain somewhat sketchy in his work, but which go in the direction of what we now know as conceptual spaces (Gärdenfors, 2000).

Each attribute space corresponds to what Carnap calls a 'modality' (color, taste, different shapes, ...). The primitive predicates in the language he considers refer to the members of _families of property_, where each such family is associated with a unique attribute space; the members of a family are supposed to be mutually exclusive and jointly exhaustive.

- This solves Goodman's grue problem (Gärdenfors, 1990).
- It also solves Hájek's arbitrariness objection (Douven & Gärdenfors, 2020).

Carnap was _somehow_ aware that his new approach should be able also to solve the second problem, but could not say exactly how. (Carnap, p20: "[W]hich regions are relevant for inductive logic? I cannot give a definite answer ..." [He does suggest that the 'admissible regions' should be scientifically useful.])
"""

# ╔═╡ 39868460-6efa-4564-9f3a-424705d8154d
md"## Determining prior probabilities"

# ╔═╡ ab7ea97e-483c-11eb-24c7-5f62fe7aece9
md"""
Carnap aims to define inductive probabilities on the basis of the geometrical properties of attribute spaces, specifically on the basis of the _width_ of the predicates (the Lebesgue measure of the corresponding regions) and the _distance_ between predicates (i.e., the distance between the regions that represent the predicates).

For simplicity, consider two one-dimensional spaces. To make things not too abstract, suppose there is actually a one-dimensional **color space**, with yellow, ochre, orange, and red being represented on the line, in this order (and with no other colors being represented on the line); for a start, say that all colors have unit length. Furthermore, suppose there is also a one-dimensional **shoe space**, with ballet flat, mocassin, stiletto, and pump being represented on the line (and with no other type of shoe being represented on the line); say again that all shoe concepts have unit length on this line.

Given these spaces, and with no other information available, what is the prior probability of Alice possessing red stilettos? The natural approach to this question considers the product space of the above one-dimensional spaces, which we can picture as follows:
"""

# ╔═╡ a5eb0eae-4836-11eb-33cf-072e8ef306d0
begin
	set_default_graphic_size(10cm, 10cm)
	
	X = repeat(.2:.2:.8, outer=5)
	Y = repeat(.2:.2:.8, inner=5)
	V = fill(.2, 10)
	W = fill(.2, 10)
		
	compose(context(),
		(context(), Compose.rectangle(X, Y, V, W), fill("transparent"), Compose.stroke("black")),
		#(context(), Compose.circle(.4, .3, 0.01)),
		(context(), Compose.text(.245, .15, "Yellow")),
		(context(), Compose.text(.445, .15, "Ochre")),
		(context(), Compose.text(.641, .15, "Orange")),
		(context(), Compose.text(.86, .15, "Red")),
		(context(), Compose.text(.045, .316, "Ballet flat")),
		(context(), Compose.text(.045, .514, "Mocassin")),
		(context(), Compose.text(.045, .715, "Stiletto")),
		(context(), Compose.text(.045, .915, "Pump"))
	)
end

# ╔═╡ 2cbc9cf8-483f-11eb-2162-0505c4408f04
md"""
Assuming the Lebesgue measure on this product space, we can read off the answer to our question: 1/16. (For a two-dimensional space, the Lebesgue measure amounts to area.) Note that the answer is independent of which other hypothesis or hypotheses we contrast Alice's having red stilettos with. In particular, we can reason that either she'll own red stilettos or she doesn't, but it doesn't follow that, for reasons of symmetry, the probability of her owning red stilettos is 1/2. On the current proposal, the symmetry considerations get applied at the level of the product space, by assuming the Lebesgue measure on that (regions with equals areas get assigned the same probability mass). This yields a version of Keynes' **Principle of Indifference** that does not run into the inconsistency problems faced by the original version (Decock, Douven, & Sznajder, 2016).
"""

# ╔═╡ 68789204-4849-11eb-0555-0707040c8785
md"## Updating (I)"

# ╔═╡ 5c566504-4843-11eb-22f3-214654754144
md"""
Carnap is interested in how new evidence affects our current probabilities. To come up with an update rule is not straightforward. Indeed, consider the situation in which we have only recently come to know Alice, and so far the only information we have about her shoes is that she owns three pairs of yellow ballet flats, two pairs of red stilettos, and one pair of orange pumps. There may be no *unique* correct answer to the question of what the probability is of her owning a pair of yellow mocassins, in light of our information.
"""

# ╔═╡ d81d54be-4844-11eb-179c-5da93c5e2ebd
begin
	set_default_graphic_size(10cm, 10cm)
	
	x = repeat(.2:.2:.8, outer=5)
	y = repeat(.2:.2:.8, inner=5)
	v = fill(.2, 10)
	w = fill(.2, 10)
		
	compose(context(),
		(context(), Compose.rectangle(x, y, v, w), fill("transparent"), Compose.stroke("black")),
		#(context(), Compose.circle(.4, .3, 0.01)),
		(context(), Compose.text(.245, .15, "Yellow")),
		(context(), Compose.text(.445, .15, "Ochre")),
		(context(), Compose.text(.641, .15, "Orange")),
		(context(), Compose.text(.86, .15, "Red")),
		(context(), Compose.text(.045, .316, "Ballet flat")),
		(context(), Compose.text(.045, .514, "Mocassin")),
		(context(), Compose.text(.045, .715, "Stiletto")),
		(context(), Compose.text(.045, .915, "Pump")),
		(context(), Compose.circle(.25, .29, 0.015), 
			Compose.stroke("yellow"), fill("yellow")),
		(context(), Compose.circle(.287, .25, 0.015), 
			Compose.stroke("yellow"), fill("yellow")),
		(context(), Compose.circle(.31, .33, 0.015), 
			Compose.stroke("yellow"), fill("yellow")),
		(context(), Compose.circle(.8751, .734, 0.015), 
			Compose.stroke("red"), fill("red")),
		(context(), Compose.circle(.921, .67, 0.015), 
			Compose.stroke("red"), fill("red")),
		(context(), Compose.circle(.725, .89, 0.015), 
			Compose.stroke("orange"), fill("orange")),
	)
end

# ╔═╡ bee042d6-0a57-4857-92e3-add4a41e8767
md"## Updating (II)"

# ╔═╡ c42d8d02-4844-11eb-1cde-f3e969669727
md"""
The question of how to update our probabilities on the new information certainly makes sense: one can reasonably have the intuition that finding that Alice owns three pairs of yellow ballet flats increases also somewhat the chance of finding that she owns a pair of ochre or red ballet flats (given our general knowledge about people's preferences).

Nevertheless, it may be difficult to motivate in an a priori fashion a _specific_ answer to the question of what the _amount_ of the increase should be.

Carnap reckons with the possibility that different individuals are to different degrees sensitive to the similarities that underlie analogical reasoning.

But he thinks at least the following principle should be satisfied:

> Principle C: If _d_(_Qᵢ_, _Qⱼ_) < _d_(_Qᵢ_, _Qₖ_), then 𝒫(_Qᵢ_ | _eₙQⱼ_) > 𝒫(_Qᵢ_ | _eₙQₖ_),

with _d_(_Qᵢ_ , _Qⱼ_) = inf{δ(_pₘ_, _pₙ_) | _pₘ_ ∈ _Qᵢ_, _pₙ_ ∈ _Qⱼ_}.
"""

# ╔═╡ 5fc1eb6e-950b-4d76-9cc7-3864c8175857
md"Illustration (assuming δ is Euclidean):"

# ╔═╡ ad888a4b-9be1-4144-825a-bafd8302807a
PlutoUI.Resource("https://imgur.com/mdJ2sHP.jpg", :width=>450)

# ╔═╡ b59abcf2-079c-4479-af32-b4d7413f3103
md"## Similarity-based updating"

# ╔═╡ fab04fe6-4848-11eb-26ae-3bf01ef8572c
md"""
In our case, updating means redistributing the probability mass that, at the beginning, is spread out evenly across the product space.

To capture the analogy intuition, we should not just give more weight to the cell in which the evidence is located but also give (some) more weight to 'neighboring' cells, where the weight we give to those reflects the distance from the cell in which the evidence falls, in accordance with Principle C.

There are infinitely many such redistribution functions.

Much will have to be determined empirically here, and we should reckon with substantial individual differences. But at least we should have a working model.
"""

# ╔═╡ c01d92a3-e07b-40cb-abfa-f4b1a8aa9a73
md"## Example (I)"

# ╔═╡ b06a893c-4849-11eb-2c34-6fc31e433a2d
md"""
Assume distances in our product space are given by the Manhattan metric, meaning, for instance, that the distance between `Orange pump` and `Yellow mocassin` equals 4 (two steps along either axis).

We compare the following update rules, the first of which does not, and the second of which does, take similarity relations into account:

> **Straight rule (SR)**: Add 1 to the cell into which the new evidence falls and renormalize.

> **Similarity-sensitive rule (SSR)**: Add α₀ to the cell into which the new evidence falls, add α₁/β₁ to the cells one step away from the evidence cell, add α₂/β₂ to the cells two steps away from the evidence cell, and renormalize.

Basically, the first rule just tallies instances while the second also adds a kind of bonus to nearby cells, where the distance determines the magnitude of the bonus.

(Note that we can view SR as a limiting case of SSR, viz., when α = 0. One could consider having still further βᵢ's, but we will not do that now.)
"""

# ╔═╡ 6580e488-4926-11eb-1b03-fb05d62b6a36
count_update(tally, obs) = tally[obs...] += 1; # SR

# ╔═╡ 37cd4c88-4929-11eb-3a0b-13389ce22ee5
function count_update_sim(tally, obs; α=1., β₁=2., β₂=3.) # SSR
	s = size(tally, 1)
	x = first(obs)
	y = last(obs)
	tally[x, y] += 1
	for i in [-1, 1]
		1 ≤ x + i ≤ s ? tally[x + i, y] += α/β₁ : nothing
	end
	for i in [-1, 1]
		1 ≤ y + i ≤ s ? tally[x, y + i] += α/β₁ : nothing
	end
	for i in [-2, 2]
		1 ≤ x + i ≤ s ? tally[x + i, y] += α/β₂ : nothing
	end
	for i in [-2, 2]
		1 ≤ y + i ≤ s ? tally[x, y + i] += α/β₂ : nothing
	end
	for i in [-1, 1], j in [-1, 1]
		(1 ≤ x + i ≤ s) && (1 ≤ y + j ≤ s) ? tally[x + i, y + j] += α/β₂ : nothing
	end
end;

# ╔═╡ 432ce8f5-cf18-4f01-a0e9-f075e24d206e
md"## Example (II)"

# ╔═╡ 8f716e24-494c-11eb-1c60-6503bb04aa0f
md"""
Using SSR, and starting from a flat prior (and certain assumptions about 'inductive inertia'; see below), an update on learning that Alice owns a pair of orange pumps (represented by the cell in the fourth row, third column) results in the following:
"""

# ╔═╡ 15b04926-4949-11eb-33fa-69ea7853f6d7
begin
	probs = ones(4, 4)
	count_update_sim(probs, (4, 3))
	#count_update_sim(probs, (2, 2))
end

# ╔═╡ 719f8aa8-4949-11eb-0215-cd25d2c0fcc8
begin
	#set_default_plot_size(4inch, 4inch)
	Gadfly.spy(normalize(probs, 1),
		Scale.color_continuous(colormap=p->ColorSchemes.viridis[p]),
		Guide.xlabel(nothing),
		Guide.ylabel(nothing),
		Guide.xticks(label=false), 
		Guide.yticks(label=false),
		Guide.colorkey(title="Probability"))
end

# ╔═╡ 4d84b982-488a-11eb-02ea-0138613b023d
md"Setting conditional probabilities equal to 'conditioned-upon' probabilities, we see that, for instance, 𝒫(`Red stiletto` | `Orange pump`) ≈ .067:"

# ╔═╡ f414e6e2-494c-11eb-1913-cd050f810a88
normalize(probs, 1)

# ╔═╡ 73cb8ce7-df23-48f5-a0db-bab73715a615
md"## Repeated updating"

# ╔═╡ a64bcf9c-488a-11eb-18a5-2bfe9a1b4a46
md"We are going to generate the evidence sentences:"

# ╔═╡ 114e8de4-4853-11eb-2bd6-99d6e321e28a
categories = [ a*b for a in ["Yellow ", "Ochre ", "Orange ", "Red "], 
					   b in ["ballet flat", "mocassin", "stiletto", "pump"] ]

# ╔═╡ 05d1cfc0-4854-11eb-149e-610be378644f
begin
	category_names = [ Symbol(a) for a in categories ]
	category_codes = [ (i, j) for i in 1:4, j in 1:4 ]
	codes = (;zip(category_names, category_codes)...)
end;

# ╔═╡ 601d9cae-486b-11eb-2af4-3b9fc0b39e99
md"""
Now we draw randomly ten pieces of evidence:
"""

# ╔═╡ e81df066-4854-11eb-2d47-4bce743cc23b
r = rand(categories, 10)

# ╔═╡ af28ad46-4949-11eb-309c-6d86c7c3fab6
begin
	out = ones(4, 4)
	res_upds = Array{Float64,3}(undef, 4, 4, length(r) + 1)
	res_upds[:, :, 1] = normalize(out, 1)
	for i in 1:length(r)
		count_update_sim(out, codes[Symbol(r[i])])
		res_upds[:, :, i + 1] = normalize(out, 1)
	end
end

# ╔═╡ 70f03744-486b-11eb-0591-cb11ff81b913
md"""
And we consider what the process of consecutively updating on these pieces of evidence looks like:
"""

# ╔═╡ 16006762-494e-11eb-0d44-f3bd75384776
function spy_plot(ar, i)
	mv = round(maximum(ar) + .05, digits=2)
	set_default_plot_size(4inch, 4inch)
	Gadfly.spy(ar[:, :, i],
			Scale.color_continuous(colormap=p->ColorSchemes.viridis[p], maxvalue=mv),
			Guide.title("Update $(i - 1)"),
			Guide.xlabel(nothing),
			Guide.ylabel(nothing),
			Guide.xticks(label=false), 
			Guide.yticks(label=false),
			Guide.colorkey(title="Probability"))
end;

# ╔═╡ 5f7881f8-494a-11eb-02fb-bdf91c4d880f
@bind out_step Slider(1:size(res_upds, 3))

# ╔═╡ 7a61b61a-494a-11eb-35ce-774c0ce8eae1
spy_plot(res_upds, out_step)

# ╔═╡ f55005e4-488b-11eb-2d5a-714b8ee64626
md"Or suppose we receive the evidence from the earlier example, in the order"

# ╔═╡ 087b3862-488c-11eb-26b3-05a646618e50
evidence = String["Yellow ballet flat", "Yellow ballet flat", "Red stiletto", "Orange pump", "Yellow ballet flat", "Red stiletto"]

# ╔═╡ 3a806c8a-488c-11eb-2168-db2b25fddff9
begin
	exa = ones(4, 4)
	c_exa = Array{Float64,3}(undef, 4, 4, length(evidence) + 1)
	c_exa[:, :, 1] = normalize(exa, 1)
	for i in 1:length(evidence)
		count_update_sim(exa, codes[Symbol(evidence[i])])
		c_exa[:, :, i + 1] = normalize(exa, 1)
	end
end

# ╔═╡ a693f9be-488c-11eb-1fae-a137485bd6d7
@bind exa_step Slider(1:size(c_exa, 3))

# ╔═╡ b24d6060-488c-11eb-3031-914fc82963d4
spy_plot(c_exa, exa_step)

# ╔═╡ 54f87eee-488d-11eb-1751-811be872a7b4
md"## Normativity in Carnap"

# ╔═╡ 60e6ac62-488d-11eb-2208-552bcd33dd72
md"""
At various junctures in his late work on analogical reasoning, Carnap makes it clear that he is interested in formulating a **normatively compelling** system of analogical reasoning.

This does not mean that, for every _Qᵢ_, _Qⱼ_, and _eₙ_, there is a unique value _x_ such that 𝒫(_Qᵢ_ | _eₙQⱼ_) = _x_. There are subjective components to inductive probability: we already mentioned that different people may weigh similarity influences differently, and there is also a person's 'inductive inertia', already known from Carnap's earlier work on inductive logic, which is encoded by a parameter λ.

However, keeping the subjective components _fixed_, the geometry of attribute spaces (specifically the width of the relevant regions and the distances among them) _does_ determine the inductive probabilities.

Carnap is ultimately unable to give a justification for his system of anological reasoning, or even for analogical reasoning in general.

That might simply be due to the fact that Carnap died while he was working on his proposal.

But there is reason to believe that the kind of general justification Carnap was hoping for simply cannot be had. Indeed, to this date there is no known set of normative principles governing analogical reasoning generally (Maher, 2001; Bartha, 2010).

Proposal: we should be happy to find that analogical reasoning is **ecologically rational**, as understood in the works of Elqayam, Gigerenzer, and others.

According to these authors, there are no universal, one-size-fits-all norms of rationality for _anything_. Whether an act/belief/update/... is rational is both context- and person-dependent.
"""

# ╔═╡ 6b9dd55b-7205-4568-8077-79db5b9e9ab1
md"## Analogical reasoning in different worlds"

# ╔═╡ 00c4cfdc-4901-11eb-3c0f-697543d48bae
begin
	const n_objects = 1000
	const n_updates = 200
end;

# ╔═╡ 05e571e1-19a7-4773-bb22-bb8e1c412433
md"""
We generalize our earlier example. We again have two spaces, 𝒮₁ and 𝒮₂, but now in each there are ten concepts represented, which are however lined up again in the same fashion as the concepts in the shoe and color spaces. Also, in both spaces the concepts are simply identified by their number in the ordering.

We are going to look at three different worlds, each consisting of $(n_objects) objects. The first of these is orderly, meaning that, in it, the objective probability that an object falls into a given concept in 𝒮₁, respectively 𝒮₂, follows a `Binomial(10, .7)`, respectively `Binomial(10, .2)` distribution, both truncated between 1 and 10 (inclusive). The second world is disorderly, in that it will be purely a matter of chance into which concepts any given object falls. The third world is 'pointed' in that all $(n_objects) objects fall in only 10 cells of the product space.

We are going to compare, in these worlds, SR with SSR by applying both rules subsequently to $(n_updates) randomly drawn pieces of evidence (i.e., information concerning the locations of a given object in 𝒮₁ and 𝒮₂).
"""

# ╔═╡ 351449fa-48fb-11eb-21f1-e1e4d1fd32eb
md"## Orderly world"

# ╔═╡ f42c361e-48aa-11eb-3230-1be90ddefe40
md"""
Now we sample $(n_updates) pieces of evidence from our world and simulate two people updating on those, one person using SR, the other SSR. We calculate, after each update, their quadratic scores (SSE), indicating how far their subjective probabilities are removed from the objective probabilities (i.e., the relative frequencies).
"""

# ╔═╡ ac2bfb10-4896-11eb-0397-c78c440df879
begin
	s₁₁ = Int.(rand(truncated(Binomial(10, .7), 1, 11), n_objects))
	s₂₁ = Int.(rand(truncated(Binomial(10, .2), 1, 11), n_objects));
end;

# ╔═╡ 5a878fe0-48a0-11eb-2dd2-53063de8292a
conc1 = zeros(Int, 10, 10);

# ╔═╡ 3165a4ca-48a1-11eb-3fe2-81e94f0bd3db
for i in 1:n_objects
	conc1[s₁₁[i], s₂₁[i]] += 1
end

# ╔═╡ c7803a16-48a0-11eb-1791-23c07d1f2453
obj_probs1 = normalize(conc1, 1);

# ╔═╡ db715078-48a0-11eb-35db-834cd8eaaf4a
begin
	set_default_plot_size(4inch, 4inch)
	p1 = Gadfly.spy(obj_probs1,
			Scale.color_continuous(colormap=p->ColorSchemes.viridis[p]),
			Guide.xlabel(nothing),
			Guide.ylabel(nothing),
			Guide.title("Alice's world"),
			Guide.xticks(label=false), 
			Guide.yticks(label=false),
			Guide.colorkey(title="Probability"))
end

# ╔═╡ 19b0b19c-48ab-11eb-2492-2ddcff351bcb
objects1 = collect(zip(s₁₁, s₂₁));

# ╔═╡ 30d117d8-48ab-11eb-1f74-c7ecf188a936
evid1 = StatsBase.sample(objects1, n_updates, replace=false);

# ╔═╡ ff1ae3aa-4926-11eb-1eb9-1d9d5b43199e
begin
	c_counts1 = ones(10, 10)
	c_upds1 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	c_upds1[:, :, 1] = normalize(c_counts1, 1)
	for i in 1:n_updates
		count_update(c_counts1, evid1[i])
		c_upds1[:, :, i + 1] = normalize(c_counts1, 1)
	end
end

# ╔═╡ a3deb630-4929-11eb-0637-4f1e80699123
begin
	sc_counts1 = ones(10, 10)
	sc_upds1 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	sc_upds1[:, :, 1] = normalize(sc_counts1, 1)
	for i in 1:n_updates
		count_update_sim(sc_counts1, evid1[i])
		sc_upds1[:, :, i + 1] = normalize(sc_counts1, 1)
	end
end

# ╔═╡ 2cab097a-4928-11eb-3c09-5189dd79f97b
c_upds1_score = 
	[ sum((c_upds1[:, :, i] .- obj_probs1).^2) for i in axes(c_upds1, 3) ];

# ╔═╡ cdf2844c-4929-11eb-2e09-a18ce49f6dc2
sc_upds1_score = 
	[ sum((sc_upds1[:, :, i] .- obj_probs1).^2) for i in axes(sc_upds1, 3) ];

# ╔═╡ 77cd3194-4928-11eb-18ff-ab74e08ea00c
begin
	set_default_plot_size(6.4inch, 4inch)
	p2 = plot(layer(x=0:n_updates, y=sc_upds1_score, Geom.point, Geom.line,
			style(default_color=colorant"MidnightBlue", highlight_width=0pt)),
		 layer(x=0:n_updates, y=c_upds1_score, Geom.point, Geom.line),
			style(default_color=colorant"thistle", highlight_width=0pt), 
		 Coord.cartesian(xmax=n_updates + 1),
		 Guide.xlabel("Update"),
		 Guide.ylabel("SSE"),
		 Guide.title("Alice's world"),
		 Guide.manual_color_key("Update rule", 
			["Analogical", "Straight"], 
			[colorant"MidnightBlue", colorant"thistle"]),
		 Theme(default_color=colorant"thistle", highlight_width=0pt,
			   major_label_font="Alegreya", major_label_font_size=18pt,
               minor_label_font="Alegreya", minor_label_font_size=16pt,
               key_title_font="Alegreya", key_title_font_size=15pt,
               key_label_font="Alegreya", key_label_font_size=13pt))
end

# ╔═╡ 79c34ff0-48fc-11eb-1f37-13f295c355db
md"## Disorderly world"

# ╔═╡ 8b877976-492b-11eb-0d9d-29d0cf61474e
md"Updating on $(n_updates) pieces of evidence from the disorderly world, again using SR and SSR:"

# ╔═╡ 9f4832d8-4951-11eb-3ae7-7f7bf50bc02a
md"""
We see that in the disorderly world SSR does still better than SR.

This is because, unlike SR, SSR does not concentrate the new mass it assigns in an update in one particular cell, but instead spreads it out a bit, with mass also being assigned to the cells surrounding the one in which the evidence falls. And given how this world was constructed, objective probabilities are somewhat evenly spread out across the product space, thus matching better the assignments of SSR than those of SR.

To see this more clearly, we look at a world in which probability is more sharply concentrated.
"""

# ╔═╡ 84a4e884-48fc-11eb-267f-d1dcac6d1ebd
s₁₂ = rand(1:10, n_objects);

# ╔═╡ ef687488-48fc-11eb-3d77-d998ae323837
s₂₂ = rand(1:10, n_objects);

# ╔═╡ ffc85988-48fc-11eb-2c47-89bf50eacc0b
conc2 = zeros(Int, 10, 10);

# ╔═╡ 556c4098-48fd-11eb-2156-d7eda0cb7385
for i in 1:n_objects
	conc2[s₁₂[i], s₂₂[i]] += 1
end

# ╔═╡ b1fab4ac-48fd-11eb-3174-2bb63ddd3400
obj_probs2 = normalize(conc2, 1);

# ╔═╡ c4228b46-48fd-11eb-320c-a5d56a57db6a
begin
	set_default_plot_size(4inch, 4inch)
	p3 = Gadfly.spy(obj_probs2,
			Scale.color_continuous(colormap=p->ColorSchemes.viridis[p]),
			Guide.xlabel(nothing),
			Guide.ylabel(nothing),
			Guide.title("Bob's world"),
			Guide.xticks(label=false), 
			Guide.yticks(label=false),
			Guide.colorkey(title="Probability"))
end

# ╔═╡ a1fa921e-48ff-11eb-2d43-bf55606c644f
objects2 = collect(zip(s₁₂, s₂₂));

# ╔═╡ bbd186de-48ff-11eb-2818-ff864d3e7de0
evid2 = StatsBase.sample(objects2, n_updates, replace=false);

# ╔═╡ 95d2f7fc-492b-11eb-1359-abcd266ad2f5
begin
	c_counts2 = ones(10, 10)
	c_upds2 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	c_upds2[:, :, 1] = normalize(c_counts2, 1)
	for i in 1:n_updates
		count_update(c_counts2, evid2[i])
		c_upds2[:, :, i + 1] = normalize(c_counts2, 1)
	end
end

# ╔═╡ db995fba-492b-11eb-313d-3d6536e0960f
begin
	sc_counts2 = ones(10, 10)
	sc_upds2 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	sc_upds2[:, :, 1] = normalize(sc_counts2, 1)
	for i in 1:n_updates
		count_update_sim(sc_counts2, evid2[i])
		sc_upds2[:, :, i + 1] = normalize(sc_counts2, 1)
	end
end

# ╔═╡ 0a7bafd6-492c-11eb-239f-191adbf19bdc
c_upds2_score = 
	[ sum((c_upds2[:, :, i] .- obj_probs2).^2) for i in axes(c_upds2, 3) ];

# ╔═╡ 220afefe-492c-11eb-2eee-7f177883b6d4
sc_upds2_score = 
	[ sum((sc_upds2[:, :, i] .- obj_probs2).^2) for i in axes(sc_upds2, 3) ];

# ╔═╡ ff18b45e-492b-11eb-1316-833ea868ffcd
begin
	set_default_plot_size(6.4inch, 4inch)
	p4 = plot(layer(x=0:n_updates, y=sc_upds2_score, Geom.point, Geom.line,
			style(default_color=colorant"MidnightBlue", highlight_width=0pt)),
		 layer(x=0:n_updates, y=c_upds2_score, Geom.point, Geom.line),
			style(default_color=colorant"thistle"), 
		 Coord.cartesian(xmax=n_updates + 1),
		 Guide.title("Bob's world"),
		 Guide.xlabel("Update"),
		 Guide.ylabel("SSE"),
		 Guide.manual_color_key("Update rule", 
			["Analogical", "Straight"], 
			[colorant"MidnightBlue", colorant"thistle"]),
		 Theme(default_color=colorant"thistle", highlight_width=0pt,
			   major_label_font="Alegreya", major_label_font_size=18pt,
               minor_label_font="Alegreya", minor_label_font_size=16pt,
               key_title_font="Alegreya", key_title_font_size=15pt,
               key_label_font="Alegreya", key_label_font_size=13pt))
end

# ╔═╡ 2c6b96ee-49f7-11eb-1419-0126c517f321
md"## Pointed world"

# ╔═╡ 788c219c-49f7-11eb-2ab9-d72d669a9278
md"""
To construct this world, we take the locations of the first ten objects created for the previous world and then randomly allocate each of $(n_objects) objects to one of those locations.
"""

# ╔═╡ c8682017-b69c-4947-8616-6ca2c6ccacaf
md"Updating and scoring as before:"

# ╔═╡ 4a141fd2-49fb-11eb-25a9-0de3aa61da87
md"""
We see that it very much depends on which world we inhabit whether it is a good idea to use SSR or rather SR.
"""

# ╔═╡ 9c0d6a24-49f7-11eb-32d5-e70daeca02ed
objects3 = StatsBase.sample(objects2[1:10], n_objects);

# ╔═╡ c9a8fadc-49f7-11eb-0b73-05c0158b4f68
conc3 = zeros(Int, 10, 10);

# ╔═╡ d606bf08-49f7-11eb-01e7-97dffe844c72
for i in 1:n_objects
	conc3[objects3[i]...] += 1
end

# ╔═╡ fc17b9cc-49f7-11eb-29af-835450fa3c35
obj_probs3 = normalize(conc3, 1);

# ╔═╡ 0caaf7ea-49f8-11eb-1790-7fc854e71dc1
begin
	set_default_plot_size(4inch, 4inch)
	p5 = Gadfly.spy(obj_probs3,
			Scale.color_continuous(colormap=p->ColorSchemes.viridis[p]),
			Guide.xlabel(nothing),
			Guide.ylabel(nothing),
			Guide.title("Carol's world"),
			Guide.xticks(label=false), 
			Guide.yticks(label=false),
			Guide.colorkey(title="Probability"))
end

# ╔═╡ 44e4b298-49fa-11eb-2e95-77ff59db53ea
evid3 = StatsBase.sample(objects3, n_updates, replace=false);

# ╔═╡ 56db99c6-49fa-11eb-1a8e-77d98bd4fba9
begin
	c_counts3 = ones(10, 10)
	c_upds3 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	c_upds3[:, :, 1] = normalize(c_counts3, 1)
	for i in 1:n_updates
		count_update(c_counts3, evid3[i])
		c_upds3[:, :, i + 1] = normalize(c_counts3, 1)
	end
end

# ╔═╡ 7261145c-49fa-11eb-2384-77e613566223
begin
	sc_counts3 = ones(10, 10)
	sc_upds3 = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	sc_upds3[:, :, 1] = normalize(sc_counts3, 1)
	for i in 1:n_updates
		count_update_sim(sc_counts3, evid3[i])
		sc_upds3[:, :, i + 1] = normalize(sc_counts3, 1)
	end
end

# ╔═╡ 8dfc2e02-49fa-11eb-21aa-3774a8a2cee7
c_upds3_score = 
	[ sum((c_upds3[:, :, i] .- obj_probs3).^2) for i in axes(c_upds3, 3) ];

# ╔═╡ a335951a-49fa-11eb-0966-5b8a74d45bad
sc_upds3_score = 
	[ sum((sc_upds3[:, :, i] .- obj_probs3).^2) for i in axes(sc_upds3, 3) ];

# ╔═╡ bcb5da40-49fa-11eb-1b12-bd5103c377ad
begin
	set_default_plot_size(6.4inch, 4inch)
	p6 = plot(layer(x=0:n_updates, y=sc_upds3_score, Geom.point, Geom.line,
			style(default_color=colorant"MidnightBlue", highlight_width=0pt)),
		 layer(x=0:n_updates, y=c_upds3_score, Geom.point, Geom.line),
			style(default_color=colorant"thistle"), 
		 Coord.cartesian(xmax=n_updates + 1),
		 Guide.title("Carol's world"),
		 Guide.xlabel("Update"),
		 Guide.ylabel("SSE"),
		 Guide.manual_color_key("Update rule", 
			["Analogical", "Straight"], 
			[colorant"MidnightBlue", colorant"thistle"]),
		 Theme(default_color=colorant"thistle", highlight_width=0pt,
			   major_label_font="Alegreya", major_label_font_size=18pt,
               minor_label_font="Alegreya", minor_label_font_size=16pt,
               key_title_font="Alegreya", key_title_font_size=15pt,
               key_label_font="Alegreya", key_label_font_size=13pt))
end

# ╔═╡ c9697954-4adb-11eb-19d7-b5c06d951668
md"## Evolutionary computing (I)"

# ╔═╡ d4e14316-4adb-11eb-06f7-91106435c8bf
md"""
Whether or not it is rational, people do make analogical inferences--see all the evidence from cognitive psychology on category-based induction.

It is reasonable to think that evolutionary pressures have helped us to get better at analogical reasoning.

We mimic the evolutionary process in computer simulations, using the familiar genetic algorithm NSGA-II.

We consider orderly worlds, similar to the one considered earlier, but _how_ they are ordered (the distributions determining the locations of the objects) is randomly chosen at the start of each simulation.

Question: Which setting of the parameters α, βᵢ is optimal for this kind of environment? 

(Note that, how we defined SSR, it also serves as a definition of SR, provided the right parameters are plugged in.)
"""

# ╔═╡ a685f39c-fce7-490d-9504-50cd0bebd382
md"## Evolutionary computing (II)"

# ╔═╡ 05a2055d-69fa-48a6-b457-835a76124d29
md"""
- We start with a community of 100 agents, each representing a specific parameter setting (the setting determining the similarity influence).
- Each agent is tested 10 times, where each time a new world is created, 100 pieces of evidence are gathered from the world, and the agent's total score is calculated after sequentially updating on those pieces of evidence.
- The 50 agents with the best (i.e., lowest) score are retained and are allowed to produce offspring (pairs are randomly created until 50 new agents are produced).
- Together, the 50 parents and 50 children form a new generation, which is subjected to the same procedure.
- This is repeated till the 50th generation has been reached.
"""

# ╔═╡ 767cedb8-7a8b-11eb-13cd-cf7754fae6d0
md"Compare the rule with the best setting from the evolutionary procedure, which we get from extracting the mean parameters from the final generation and plugging those into SSR, with the original SSR as well as with SR, assuming the first ordered world we looked at:"

# ╔═╡ 13c48604-4ae3-11eb-236f-4b76ce38c93f
function count_update_evo(tally, obs, α₀, α₁, α₂, β₁, β₂)
	s = size(tally, 1)
	x = first(obs)
	y = last(obs)
	tally[x, y] += α₀
	for i in [-1, 1]
		1 ≤ x + i ≤ s ? tally[x + i, y] += α₁/β₁ : nothing
	end
	for i in [-1, 1]
		1 ≤ y + i ≤ s ? tally[x, y + i] += α₁/β₁ : nothing
	end
	for i in [-2, 2]
		1 ≤ x + i ≤ s ? tally[x + i, y] += α₂/β₂ : nothing
	end
	for i in [-2, 2]
		1 ≤ y + i ≤ s ? tally[x, y + i] += α₂/β₂ : nothing
	end
	for i in [-1, 1], j in [-1, 1]
		(1 ≤ x + i ≤ s) && (1 ≤ y + j ≤ s) ? tally[x + i, y + j] += α₂/β₂ : nothing
	end
end;

# ╔═╡ 614a83b0-4ae3-11eb-2299-edc55910105c
struct Params
	a0::Float64
	a1::Float64
	a2::Float64
	b1::Float64
	b2::Float64
end

# ╔═╡ b573f2d2-4ae3-11eb-3433-53e40df8d682
rand_params() = Params(rand(Uniform(0, 10)),
					   rand(Uniform(0, 10)),
					   rand(Uniform(0, 10)), 
					   rand(Uniform(0, 10)), 
					   rand(Uniform(0, 10)));

# ╔═╡ bc593da0-4ae3-11eb-127d-d709c1869c53
function rand_environment(;n_objects=1000)
	r1, r2 = rand(2)
	s1 = Int.(rand(Truncated(Binomial(10, r1), 1, 11), n_objects))
	s2 = Int.(rand(Truncated(Binomial(10, r2), 1, 11), n_objects))
	concepts = zeros(Int, 10, 10)
	@inbounds for i in 1:n_objects
		concepts[s1[i], s2[i]] += 1
	end
	obj_probs = normalize(concepts, 1)
	objects = collect(zip(s1, s2))
	return obj_probs, objects
end;

# ╔═╡ db33ace2-4ae8-11eb-20f9-455355c8fe58
function single_run(p::Params; n_updates::Int=100)
	@unpack a0, a1, a2, b1, b2 = p
	obj_probs, objs = rand_environment()
	@assert n_updates ≤ length(objs)
	evid = StatsBase.sample(objs, n_updates, replace=false)
	counts = ones(size(obj_probs))
	upds = Array{Float64,3}(undef, size(obj_probs)..., n_updates + 1)
	upds[:, :, 1] = normalize(counts, 1)
	@inbounds for i in 1:n_updates
		count_update_evo(counts, evid[i], a0, a1, a2, b1, b2)
		upds[:, :, i + 1] = normalize(counts, 1)
	end
	score = [ sum((upds[:, :, i] .- obj_probs).^2) for i in axes(upds, 3) ]
	return mean(score)
end;

# ╔═╡ 5396b108-4aea-11eb-3f80-af21d6b2c4f9
start_pop = [ rand_params() for _ in 1:100 ]; #= we only need to set the population size here -- in the following sizes are then defined in 
terms of the length of this variable =#

# ╔═╡ e32410ba-4aeb-11eb-2fb1-b7c70865d30c
function med_index(ar::Array{Float64,1})
	m = median(ar)
	return findall(x->x≤m, ar)
end;

# ╔═╡ f96e8ba4-4aee-11eb-2d33-f5cbfb200501
function create_child(pop::Array{Params,1}; mut_prob::Float64=.01)
	p1, p2 = StatsBase.sample(pop, 2, replace=false)
	ps = Params(rand() < mut_prob ? rand(Uniform(0, 10)) :
					rand(Uniform(extrema([p1.a0, p2.a0])...)),
				rand() < mut_prob ? rand(Uniform(0, 10)) :
					rand(Uniform(extrema([p1.a1, p2.a1])...)),
			    rand() < mut_prob ? rand(Uniform(0, 10)) :
					rand(Uniform(extrema([p1.a2, p2.a2])...)),
				rand() < mut_prob ? rand(Uniform(0, 10)) :
					rand(Uniform(extrema([p1.b1, p2.b1])...)), 
				rand() < mut_prob ? rand(Uniform(0, 10)) :
					rand(Uniform(extrema([p1.b2, p2.b2])...)))
	return ps
end;

# ╔═╡ 3de66ad0-4afa-11eb-03a1-437f51817b68
function new_generation(pop::Array{Params,1})
	scores = mean(map(_->single_run.(pop), 1:10), dims=1)[1] # 10 tests
	inds = med_index(scores)
	parents = pop[inds]
	children = [ create_child(parents) for _ in 1:length(inds) ]
	return vcat(parents, children), scores
end;

# ╔═╡ 65adc06e-7a79-11eb-1c3a-918d783a7905
const numb_generations = 50;

# ╔═╡ 7616773e-7a79-11eb-0cf1-37c4d9ca8a70
function evo_run()
	populations = Vector{Vector{Params}}(undef, numb_generations + 1)
	scores = Vector{Vector{Float64}}(undef, numb_generations)
	populations[1] = start_pop
	for i in 1:numb_generations
		pop, sc = new_generation(populations[i])
		populations[i + 1] = pop
		scores[i] = sc
	end
	return populations, scores
end;

# ╔═╡ c9c408e2-7a79-11eb-06a9-69d73134babe
populations, scores = evo_run();

# ╔═╡ d30f82a0-7a79-11eb-3473-63b41e04ebc8
df = DataFrame(X = 1:numb_generations, Y = mean.([scores[i] 
			for i in 1:numb_generations]));

# ╔═╡ eaa9dc30-7a79-11eb-086e-6329a8ffa88c
begin
	set_default_plot_size(7inch, 4.5inch)
	plot(df, x=:X, y=:Y,
		Geom.point,
		Guide.xlabel("Generation"),
		Guide.ylabel("Score"),
		Theme(default_color=colorant"MidnightBlue", point_size=2pt),
		layer(Stat.smooth(method=:lm, levels=[.99]), Geom.line, Geom.ribbon,
			  style(default_color=colorant"MidnightBlue", 
					line_width=2pt,
					alphas=[.4])))
end

# ╔═╡ 07e83da0-7a7a-11eb-398c-89543b8fa4b2
begin
	par0 = [ mean_and_std(populations[j][i].a0 for i in 1:100) 
		for j in 1:numb_generations + 1 ]
	par1 = [ mean_and_std(populations[j][i].a1 for i in 1:100) 
		for j in 1:numb_generations + 1 ]
	par2 = [ mean_and_std(populations[j][i].a2 for i in 1:100) 
		for j in 1:numb_generations + 1 ]
	par3 = [ mean_and_std(populations[j][i].b1 for i in 1:100) 
		for j in 1:numb_generations + 1 ]
	par4 = [ mean_and_std(populations[j][i].b2 for i in 1:100) 
		for j in 1:numb_generations + 1 ]
end;

# ╔═╡ a592a95e-7a8a-11eb-1bcb-090bef1fc611
par1_df = DataFrame(x=0:length(par1) - 1, 
					y=first.(par1), 
					ymax=first.(par1) .+ last.(par1), 
					ymin=first.(par1) .- last.(par1));

# ╔═╡ c1579776-7a8a-11eb-2732-e79b3b815364
plot(par1_df, x=:x, y=:y, ymin=:ymin, ymax=:ymax, 
	 Geom.line, Geom.ribbon,
	 Guide.xlabel("Generation"), Guide.ylabel("α₁"),
	 Theme(default_color="MidnightBlue", alphas=[.6]));

# ╔═╡ d253c3d8-7a8a-11eb-1f92-9b916291f191
par2_df = DataFrame(x=0:length(par2) - 1, 
					y=first.(par2), 
					ymax=first.(par2) .+ last.(par2), 
					ymin=first.(par2) .- last.(par2));

# ╔═╡ f52909ea-7a8a-11eb-1a8d-a5dbbfd07cea
plot(par2_df, x=:x, y=:y, ymin=:ymin, ymax=:ymax, 
	 Geom.line, Geom.ribbon,
	 Guide.xlabel("Generation"), Guide.ylabel("α₂"),
	 Theme(default_color="MidnightBlue", alphas=[.6]));

# ╔═╡ 085f493e-7a8b-11eb-1752-cdf960a371f4
par3_df = DataFrame(x=0:length(par3) - 1, 
					y=first.(par3), 
					ymax=first.(par3) .+ last.(par3), 
					ymin=first.(par3) .- last.(par3));

# ╔═╡ 21495d40-7a8b-11eb-1d26-f337ae221a67
plot(par3_df, x=:x, y=:y, ymin=:ymin, ymax=:ymax, 
	 Geom.line, Geom.ribbon,
	 Guide.xlabel("Generation"), Guide.ylabel("β₁"),
	 Theme(default_color="MidnightBlue", alphas=[.6]));

# ╔═╡ 4cd00680-7a8b-11eb-0e5d-b77e5485092b
par4_df = DataFrame(x=0:length(par4) - 1, 
					y=first.(par4), 
					ymax=first.(par4) .+ last.(par4), 
					ymin=first.(par4) .- last.(par4));

# ╔═╡ 7131fd62-7a8b-11eb-3f8a-7deaf3886138
plot(par4_df, x=:x, y=:y, ymin=:ymin, ymax=:ymax, 
	 Geom.line, Geom.ribbon,
	 Guide.xlabel("Generation"), Guide.ylabel("β₂"),
	 Theme(default_color="MidnightBlue", alphas=[.6]));

# ╔═╡ 8f3d9f78-7a8b-11eb-0d42-ffcc0b856940
extract_params(p::Params) = [p.a0 p.a1 p.a2 p.b1 p.b2];

# ╔═╡ a8c8fa32-7a8b-11eb-2d14-0d9b2f562955
μs = mean(extract_params.(populations[end]), dims=1)

# ╔═╡ c4464c92-7a8b-11eb-0d4d-c566b68a1766
begin
	const numb_objects = 1000
	const numb_updates = 200
end;

# ╔═╡ e9c5f5d0-7a8b-11eb-2ec0-59ac94832cbb
begin
	s₁ = Int.(rand(Truncated(Binomial(10, .7), 1, 11), numb_objects))
	s₂ = Int.(rand(Truncated(Binomial(10, .2), 1, 11), numb_objects))
end;

# ╔═╡ 05d0f41e-7a8c-11eb-2318-c57f39ba0653
begin
	conc = zeros(Int, 10, 10)
	for i in 1:n_objects
		conc[s₁[i], s₂[i]] += 1
	end
end

# ╔═╡ 1a3359a6-7a8c-11eb-0684-338a906b0d84
obj_probs = normalize(conc, 1);

# ╔═╡ 40089510-7a8c-11eb-15d2-a78b77b6268b
objects = collect(zip(s₁, s₂));

# ╔═╡ 51dddb1a-7a8c-11eb-2a2c-51b3281bb8bb
evid = StatsBase.sample(objects, n_updates, replace=false);
#evid = evid2;

# ╔═╡ 62574de6-7a8c-11eb-0fe4-bf9ed5c2cd46
begin
	res1 = ones(10, 10)
	res1_upd = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	res1_upd[:, :, 1] = normalize(res1, 1)
	for i in 1:n_updates
		count_update_evo(res1, evid[i], 1, 0, 0, 1, 1) # straight rule
		res1_upd[:, :, i + 1] = normalize(res1, 1)
	end
end

# ╔═╡ 7eb2ef90-7a8c-11eb-0142-c340979448e3
begin
	res2 = ones(10, 10)
	res2_upd = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	res2_upd[:, :, 1] = normalize(res2, 1)
	for i in 1:n_updates
		count_update_evo(res2, evid[i], 1, 1, 1, 2, 3) # analogical rule
		res2_upd[:, :, i + 1] = normalize(res2, 1)
	end
end

# ╔═╡ 8d6b41b8-7a8c-11eb-02b1-7d8aa94e27cd
begin
	res3 = ones(10, 10)
	res3_upd = Array{Float64,3}(undef, 10, 10, n_updates + 1)
	res3_upd[:, :, 1] = normalize(res3, 1)
	for i in 1:n_updates
		count_update_evo(res3, evid[i], μs[1]...) # optimized rule
		res3_upd[:, :, i + 1] = normalize(res3, 1)
	end
end

# ╔═╡ a2d423b2-7a8c-11eb-34bc-6d3a42d78789
begin
	res1_score = [ sum((res1_upd[:, :, i] .- obj_probs).^2) 
		for i in axes(res1_upd, 3) ]
	res2_score = [ sum((res2_upd[:, :, i] .- obj_probs).^2) 
		for i in axes(res2_upd, 3) ]
	res3_score = [ sum((res3_upd[:, :, i] .- obj_probs).^2) 
		for i in axes(res3_upd, 3) ]
end;

# ╔═╡ 194c82f0-7a8d-11eb-1c69-d33757d6b14e
begin
	set_default_plot_size(6.4inch, 4inch)
	p7 = plot(layer(x=0:n_updates, y=res1_score, Geom.point, Geom.line,
			style(default_color=colorant"thistle", highlight_width=0pt)),
		 layer(x=0:n_updates, y=res2_score, Geom.point, Geom.line,
			style(default_color=colorant"MidnightBlue", highlight_width=0pt)),
		 layer(x=0:n_updates, y=res3_score, Geom.point, Geom.line,
			style(default_color=colorant"CornflowerBlue", highlight_width=0pt)), 
		 Coord.cartesian(xmax=n_updates + 1),
		 Guide.xlabel("Update"),
		 Guide.ylabel("SSE"),
		 Guide.title("Alice's world"),
		 Guide.manual_color_key("Update rule", 
			["Analogical", "Optimized", "Straight"], 
			[colorant"MidnightBlue", colorant"CornflowerBlue", colorant"thistle"]),
		 Theme(default_color=colorant"thistle", highlight_width=0pt,
			   major_label_font="Alegreya", major_label_font_size=16pt,
               minor_label_font="Alegreya", minor_label_font_size=14pt,
               key_title_font="Alegreya", key_title_font_size=13pt,
               key_label_font="Alegreya", key_label_font_size=11pt))
end

# ╔═╡ e31c1d79-9d2f-4097-b8be-1a01a2390d04
draw(PDF("opt_alice_new.pdf"), p7)

# ╔═╡ 2fe0528d-1e72-4193-8e80-1bd3d3cd672b
md"## Material account of analogical reasoning?"

# ╔═╡ eb370cf3-1262-4009-8497-1338b5215f22
md"""
Norton (2010) favors a material account of induction: inductive inferences are justified (if they are) on the basis of some local constellation of facts, which have to be determined per individual inductive inference.

One could consider a similar defense of analogical inference (Bartha, 2019).

But that would go too far. While there can be contextual ('local') components to analogical inference, they also exploit inductive knowledge of broad, cross-context regularities.
"""

# ╔═╡ c89cd29d-b12e-48fa-a487-02e9b344a56b
md"## Analogical reasoning and induction"

# ╔═╡ 5bbab88b-2e7e-49a0-ac40-d4f31f913475
md"""
> [T]he usual strategy has been to reduce [analogical reasoning] to some other generally accepted form of inductive or deductive inference. These efforts are unconvincing, largely because ... most analogical arguments are not properly cast in these simpler molds. (Bartha, 2010, p28)

Right, but even if analogical reasoning cannot be _reduced_ to inductive reasoning, its _justification_ may rely on induction.

Induction appears to be doubly involved in the justification of analogical reasoning:

**First**, in relying on analogical reasoning, we exploit what we have learned inductively about the world, for instance:

- people tend to develop a taste for fashion and therefore make somewhat consistent choices in the things they wear;
- also see work on color diets (e.g., Lindsey & Brown, 2021).

Such inferences are defeasible. For instance, we may learn that someone does not care about fashion at all. They can also be reinforced by additional contextual information, as when we learn that someone cares about fashion a lot.

**Second**, we can look at the track record of analogical reasoning--register in which contexts it is successful and _how_ successful it is (i.e., how often it led us to a conclusion that later turned out to be true)--and, _hopefully_, use those data to justify the use of analogical reasoning, _in particular contexts_, inductively.
"""

# ╔═╡ f2234d7f-04ac-430f-9242-d0a8f2d8edce
md"## Empirical content"

# ╔═╡ f61ec826-7f15-448a-846a-1e1e7683eae2
md"""
On the Carnapian view defended, people have default expectations guiding analogical reasoning, where these expectations can be weakened or strengthened by contextual information.

Here is a possible experiment to test this consequence.

> Your colleague is a collector of pottery. He shows you five items in his collection:
"""

# ╔═╡ 9f3ecc24-fbf7-4301-884c-7f5b58303545
PlutoUI.Resource("https://imgur.com/sP5DXRA.jpg")

# ╔═╡ 4b57a828-2bd8-43a1-b825-72d6440b64fd
md"""
> How likely is it, in your opinion, that the item in the red frame is also in his collection?
"""

# ╔═╡ c9e5bd64-da63-498e-8fd0-267761dcbe70
PlutoUI.Resource("https://imgur.com/y3R4Hp8.jpg")

# ╔═╡ 2f9f71f7-e104-4a7b-9157-353c3d08d398
md"""
> Your colleague shows you some more items in his collection. If this makes a difference, please indicate how confident you are now that the object in the red frame is in his collection.
"""

# ╔═╡ 3e4b8833-635d-48d2-af30-de49096b5ff8
PlutoUI.Resource("https://imgur.com/R4opy5p.jpg")

# ╔═╡ 730059df-9a78-4031-a911-1d25c930f340
md"## Conclusions"

# ╔═╡ 3dd1869a-cb20-42ca-a57c-ddd3c93cfced
md"""
Do not expect a _general_ characterization of valid analogical inferences, certainly not one in terms of _syntax_.

Atrribute space/conceptual spaces help us to make analogical reasoning formally precise.

Using this framework, it was shown that, in some contexts, analogical reasoning is clearly a good idea.

It is not just a matter of luck to find ourselves in the right kind of context: we can have inductive knowledge about which contexts do and which do not support analogical reasoning.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Cairo = "159f3aea-2a34-519c-b102-8c37f9878175"
ColorSchemes = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
Compose = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Gadfly = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
KernelDensity = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
LazySets = "b4f0291d-fe17-52bc-9479-3d1a343d9043"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Cairo = "~1.0.5"
ColorSchemes = "~3.15.0"
Colors = "~0.12.8"
Compose = "~0.9.3"
DataFrames = "~1.3.1"
Distributions = "~0.25.37"
Gadfly = "~1.3.4"
ImageFiltering = "~0.7.1"
KernelDensity = "~0.6.3"
LazySets = "~1.57.0"
Parameters = "~0.12.3"
PlutoUI = "~0.7.27"
StatsBase = "~0.33.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "9e320d62e82cd8a4a5e3dd80096218ad9a22e5be"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CRlibm]]
deps = ["CRlibm_jll"]
git-tree-sha1 = "32abd86e3c2025db5172aa182b982debed519834"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "1.0.1"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "c308f209870fdbd84cb20332b6dfaf14bf3387f8"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "9a2695195199f4f20b94898c8a8ac72609e165a4"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.3"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoupledFields]]
deps = ["LinearAlgebra", "Statistics", "StatsBase"]
git-tree-sha1 = "6c9671364c68c1158ac2524ac881536195b7e7bc"
uuid = "7ad07ef1-bdf2-5661-9d2b-286fd4296dac"
version = "0.2.0"

[[deps.Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "cfdfef912b7f93e4b848e80b9befdf9e331bc05a"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "6a8dc9f82e5ce28279b6e3e2cea9421154f5bd0d"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.37"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FastRounding]]
deps = ["ErrorfreeArithmetic", "LinearAlgebra"]
git-tree-sha1 = "6344aa18f654196be82e62816935225b3b9abe44"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.3.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "2f18915445b248731ec5db4e4a17e451020bf21e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.30"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLPK]]
deps = ["GLPK_jll", "MathOptInterface"]
git-tree-sha1 = "c3cc0a7a4e021620f1c0e67679acdbf1be311eb0"
uuid = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
version = "1.0.1"

[[deps.GLPK_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "fe68622f32828aa92275895fdb324a85894a5b1b"
uuid = "e8aa6df9-e6ca-548a-97ff-1f85fc5b8b98"
version = "5.0.1+0"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"
version = "6.2.1+2"

[[deps.Gadfly]]
deps = ["Base64", "CategoricalArrays", "Colors", "Compose", "Contour", "CoupledFields", "DataAPI", "DataStructures", "Dates", "Distributions", "DocStringExtensions", "Hexagons", "IndirectArrays", "IterTools", "JSON", "Juno", "KernelDensity", "LinearAlgebra", "Loess", "Measures", "Printf", "REPL", "Random", "Requires", "Showoff", "Statistics"]
git-tree-sha1 = "13b402ae74c0558a83c02daa2f3314ddb2d515d3"
uuid = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
version = "1.3.4"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hexagons]]
deps = ["Test"]
git-tree-sha1 = "de4a6f9e7c4710ced6838ca906f81905f7385fd6"
uuid = "a1b4810d-1bce-5fbd-ac56-80944d57a21f"
version = "0.2.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

[[deps.IntervalArithmetic]]
deps = ["CRlibm", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "421f305e970dd1d2c8339c93b7674fd3a698ed06"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.20.6"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions"]
git-tree-sha1 = "534adddf607222b34a0a9bba812248a487ab22b7"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "1.1.1"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "591e8dc09ad18386189610acafb970032c519707"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.3"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazySets]]
deps = ["Distributed", "ExprTools", "GLPK", "InteractiveUtils", "IntervalArithmetic", "JuMP", "LinearAlgebra", "Pkg", "Random", "RecipesBase", "Reexport", "Requires", "SharedArrays", "SparseArrays"]
git-tree-sha1 = "3080f7bac6e093e6883ae31c61745c2b699ead2a"
uuid = "b4f0291d-fe17-52bc-9479-3d1a343d9043"
version = "1.57.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "46efcea75c890e5d820e670516dc156689851722"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.5.4"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions", "Test", "Unicode"]
git-tree-sha1 = "21e4d46307492e77332c777699c90d58a4fa3245"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.5.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4e675d6e9ec02061800d6cfb695812becbd03cdf"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.4"

[[deps.NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "ee26b350276c51697c9c2d88a072b339f9f03d73"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.5"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "646eed6f6a5d8df6708f15ea7e02a7a2c4fe4800"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.10"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a121dfbba67c94a5bec9dde613c3d0cbcf3a12b"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.3+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "fed057115644d04fba7f4d768faeeeff6ad11a60"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.27"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "01d341f502250e81f6fec0afe662aa861392a3aa"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.2"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e08890d19787ec25029113e88c34ec20cac1c91e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.0.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "bedb3e17cc1d94ce0e6e66d3afa47157978ba404"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.14"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─f0212ad0-7c3c-416e-901b-eab9c5f36f78
# ╟─f9cb81d4-4831-11eb-1d1a-756179fc8ee8
# ╟─b1d604d1-c928-44d0-aaec-68e98004cc2b
# ╟─e9ad8158-4831-11eb-3f2a-dd8b77360abe
# ╟─8ceff4fd-1bd4-43c5-9e3e-b32371445049
# ╟─1afcda13-9b9a-4f4d-8b1d-862337958ccd
# ╟─596aa39b-1647-40e6-93f8-9d9c9fe73433
# ╟─e0c0ab17-3c85-4712-8c8e-49da9fae264e
# ╟─95bcb0b1-3121-4ec7-812a-2109032b5f22
# ╟─05dbf06c-8d3e-43b6-b4f0-09e13851adcc
# ╟─e874eb1c-ba9d-4ba4-8052-e8bb0f83d8ef
# ╟─3601e822-d730-4973-ac3b-4fed81212f98
# ╟─b17f2ac9-7351-46ed-901b-464ce2fd53aa
# ╟─c137ed82-6835-4f94-a495-a5a6f38f5abc
# ╟─e33bc9b3-7870-4493-978e-4f572de528bd
# ╟─f8db1ee4-4951-11eb-0b96-693fbd71657f
# ╟─39868460-6efa-4564-9f3a-424705d8154d
# ╟─ab7ea97e-483c-11eb-24c7-5f62fe7aece9
# ╟─a5eb0eae-4836-11eb-33cf-072e8ef306d0
# ╟─2cbc9cf8-483f-11eb-2162-0505c4408f04
# ╟─68789204-4849-11eb-0555-0707040c8785
# ╟─5c566504-4843-11eb-22f3-214654754144
# ╟─d81d54be-4844-11eb-179c-5da93c5e2ebd
# ╟─bee042d6-0a57-4857-92e3-add4a41e8767
# ╟─c42d8d02-4844-11eb-1cde-f3e969669727
# ╟─5fc1eb6e-950b-4d76-9cc7-3864c8175857
# ╟─ad888a4b-9be1-4144-825a-bafd8302807a
# ╟─b59abcf2-079c-4479-af32-b4d7413f3103
# ╟─fab04fe6-4848-11eb-26ae-3bf01ef8572c
# ╟─c01d92a3-e07b-40cb-abfa-f4b1a8aa9a73
# ╟─b06a893c-4849-11eb-2c34-6fc31e433a2d
# ╠═6580e488-4926-11eb-1b03-fb05d62b6a36
# ╠═37cd4c88-4929-11eb-3a0b-13389ce22ee5
# ╟─432ce8f5-cf18-4f01-a0e9-f075e24d206e
# ╟─8f716e24-494c-11eb-1c60-6503bb04aa0f
# ╠═15b04926-4949-11eb-33fa-69ea7853f6d7
# ╟─719f8aa8-4949-11eb-0215-cd25d2c0fcc8
# ╟─4d84b982-488a-11eb-02ea-0138613b023d
# ╠═f414e6e2-494c-11eb-1913-cd050f810a88
# ╟─73cb8ce7-df23-48f5-a0db-bab73715a615
# ╟─a64bcf9c-488a-11eb-18a5-2bfe9a1b4a46
# ╟─114e8de4-4853-11eb-2bd6-99d6e321e28a
# ╟─05d1cfc0-4854-11eb-149e-610be378644f
# ╟─601d9cae-486b-11eb-2af4-3b9fc0b39e99
# ╟─e81df066-4854-11eb-2d47-4bce743cc23b
# ╟─af28ad46-4949-11eb-309c-6d86c7c3fab6
# ╟─70f03744-486b-11eb-0591-cb11ff81b913
# ╟─16006762-494e-11eb-0d44-f3bd75384776
# ╟─5f7881f8-494a-11eb-02fb-bdf91c4d880f
# ╟─7a61b61a-494a-11eb-35ce-774c0ce8eae1
# ╟─f55005e4-488b-11eb-2d5a-714b8ee64626
# ╟─087b3862-488c-11eb-26b3-05a646618e50
# ╟─3a806c8a-488c-11eb-2168-db2b25fddff9
# ╟─a693f9be-488c-11eb-1fae-a137485bd6d7
# ╟─b24d6060-488c-11eb-3031-914fc82963d4
# ╟─54f87eee-488d-11eb-1751-811be872a7b4
# ╟─60e6ac62-488d-11eb-2208-552bcd33dd72
# ╟─6b9dd55b-7205-4568-8077-79db5b9e9ab1
# ╟─05e571e1-19a7-4773-bb22-bb8e1c412433
# ╠═00c4cfdc-4901-11eb-3c0f-697543d48bae
# ╟─351449fa-48fb-11eb-21f1-e1e4d1fd32eb
# ╠═db715078-48a0-11eb-35db-834cd8eaaf4a
# ╠═e31c1d79-9d2f-4097-b8be-1a01a2390d04
# ╟─f42c361e-48aa-11eb-3230-1be90ddefe40
# ╠═77cd3194-4928-11eb-18ff-ab74e08ea00c
# ╠═ac2bfb10-4896-11eb-0397-c78c440df879
# ╠═5a878fe0-48a0-11eb-2dd2-53063de8292a
# ╠═3165a4ca-48a1-11eb-3fe2-81e94f0bd3db
# ╠═c7803a16-48a0-11eb-1791-23c07d1f2453
# ╠═19b0b19c-48ab-11eb-2492-2ddcff351bcb
# ╠═30d117d8-48ab-11eb-1f74-c7ecf188a936
# ╠═ff1ae3aa-4926-11eb-1eb9-1d9d5b43199e
# ╠═a3deb630-4929-11eb-0637-4f1e80699123
# ╠═2cab097a-4928-11eb-3c09-5189dd79f97b
# ╠═cdf2844c-4929-11eb-2e09-a18ce49f6dc2
# ╟─79c34ff0-48fc-11eb-1f37-13f295c355db
# ╠═c4228b46-48fd-11eb-320c-a5d56a57db6a
# ╟─8b877976-492b-11eb-0d9d-29d0cf61474e
# ╠═ff18b45e-492b-11eb-1316-833ea868ffcd
# ╟─9f4832d8-4951-11eb-3ae7-7f7bf50bc02a
# ╠═84a4e884-48fc-11eb-267f-d1dcac6d1ebd
# ╠═ef687488-48fc-11eb-3d77-d998ae323837
# ╠═ffc85988-48fc-11eb-2c47-89bf50eacc0b
# ╠═556c4098-48fd-11eb-2156-d7eda0cb7385
# ╠═b1fab4ac-48fd-11eb-3174-2bb63ddd3400
# ╠═a1fa921e-48ff-11eb-2d43-bf55606c644f
# ╠═bbd186de-48ff-11eb-2818-ff864d3e7de0
# ╠═95d2f7fc-492b-11eb-1359-abcd266ad2f5
# ╠═db995fba-492b-11eb-313d-3d6536e0960f
# ╠═0a7bafd6-492c-11eb-239f-191adbf19bdc
# ╠═220afefe-492c-11eb-2eee-7f177883b6d4
# ╟─2c6b96ee-49f7-11eb-1419-0126c517f321
# ╟─788c219c-49f7-11eb-2ab9-d72d669a9278
# ╠═0caaf7ea-49f8-11eb-1790-7fc854e71dc1
# ╟─c8682017-b69c-4947-8616-6ca2c6ccacaf
# ╠═bcb5da40-49fa-11eb-1b12-bd5103c377ad
# ╠═4a141fd2-49fb-11eb-25a9-0de3aa61da87
# ╠═9c0d6a24-49f7-11eb-32d5-e70daeca02ed
# ╠═c9a8fadc-49f7-11eb-0b73-05c0158b4f68
# ╠═d606bf08-49f7-11eb-01e7-97dffe844c72
# ╠═fc17b9cc-49f7-11eb-29af-835450fa3c35
# ╠═44e4b298-49fa-11eb-2e95-77ff59db53ea
# ╠═56db99c6-49fa-11eb-1a8e-77d98bd4fba9
# ╠═7261145c-49fa-11eb-2384-77e613566223
# ╠═8dfc2e02-49fa-11eb-21aa-3774a8a2cee7
# ╠═a335951a-49fa-11eb-0966-5b8a74d45bad
# ╟─c9697954-4adb-11eb-19d7-b5c06d951668
# ╟─d4e14316-4adb-11eb-06f7-91106435c8bf
# ╟─a685f39c-fce7-490d-9504-50cd0bebd382
# ╟─05a2055d-69fa-48a6-b457-835a76124d29
# ╟─eaa9dc30-7a79-11eb-086e-6329a8ffa88c
# ╟─767cedb8-7a8b-11eb-13cd-cf7754fae6d0
# ╠═194c82f0-7a8d-11eb-1c69-d33757d6b14e
# ╠═13c48604-4ae3-11eb-236f-4b76ce38c93f
# ╠═614a83b0-4ae3-11eb-2299-edc55910105c
# ╠═b573f2d2-4ae3-11eb-3433-53e40df8d682
# ╠═bc593da0-4ae3-11eb-127d-d709c1869c53
# ╠═db33ace2-4ae8-11eb-20f9-455355c8fe58
# ╠═5396b108-4aea-11eb-3f80-af21d6b2c4f9
# ╠═e32410ba-4aeb-11eb-2fb1-b7c70865d30c
# ╠═f96e8ba4-4aee-11eb-2d33-f5cbfb200501
# ╠═3de66ad0-4afa-11eb-03a1-437f51817b68
# ╠═65adc06e-7a79-11eb-1c3a-918d783a7905
# ╠═7616773e-7a79-11eb-0cf1-37c4d9ca8a70
# ╠═c9c408e2-7a79-11eb-06a9-69d73134babe
# ╠═d30f82a0-7a79-11eb-3473-63b41e04ebc8
# ╠═07e83da0-7a7a-11eb-398c-89543b8fa4b2
# ╠═a592a95e-7a8a-11eb-1bcb-090bef1fc611
# ╠═c1579776-7a8a-11eb-2732-e79b3b815364
# ╠═d253c3d8-7a8a-11eb-1f92-9b916291f191
# ╠═f52909ea-7a8a-11eb-1a8d-a5dbbfd07cea
# ╠═085f493e-7a8b-11eb-1752-cdf960a371f4
# ╠═21495d40-7a8b-11eb-1d26-f337ae221a67
# ╠═4cd00680-7a8b-11eb-0e5d-b77e5485092b
# ╠═7131fd62-7a8b-11eb-3f8a-7deaf3886138
# ╠═8f3d9f78-7a8b-11eb-0d42-ffcc0b856940
# ╠═a8c8fa32-7a8b-11eb-2d14-0d9b2f562955
# ╠═c4464c92-7a8b-11eb-0d4d-c566b68a1766
# ╠═e9c5f5d0-7a8b-11eb-2ec0-59ac94832cbb
# ╠═05d0f41e-7a8c-11eb-2318-c57f39ba0653
# ╠═1a3359a6-7a8c-11eb-0684-338a906b0d84
# ╠═40089510-7a8c-11eb-15d2-a78b77b6268b
# ╠═51dddb1a-7a8c-11eb-2a2c-51b3281bb8bb
# ╠═62574de6-7a8c-11eb-0fe4-bf9ed5c2cd46
# ╠═7eb2ef90-7a8c-11eb-0142-c340979448e3
# ╠═8d6b41b8-7a8c-11eb-02b1-7d8aa94e27cd
# ╠═a2d423b2-7a8c-11eb-34bc-6d3a42d78789
# ╟─2fe0528d-1e72-4193-8e80-1bd3d3cd672b
# ╟─eb370cf3-1262-4009-8497-1338b5215f22
# ╟─c89cd29d-b12e-48fa-a487-02e9b344a56b
# ╟─5bbab88b-2e7e-49a0-ac40-d4f31f913475
# ╟─f2234d7f-04ac-430f-9242-d0a8f2d8edce
# ╟─f61ec826-7f15-448a-846a-1e1e7683eae2
# ╟─9f3ecc24-fbf7-4301-884c-7f5b58303545
# ╟─4b57a828-2bd8-43a1-b825-72d6440b64fd
# ╟─c9e5bd64-da63-498e-8fd0-267761dcbe70
# ╟─2f9f71f7-e104-4a7b-9157-353c3d08d398
# ╟─3e4b8833-635d-48d2-af30-de49096b5ff8
# ╟─730059df-9a78-4031-a911-1d25c930f340
# ╟─3dd1869a-cb20-42ca-a57c-ddd3c93cfced
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
