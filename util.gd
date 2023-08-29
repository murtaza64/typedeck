extends Object

class_name Util

static func reverse_string(s):
	var out = s
	for i in len(s):
		out[len(s) - i - 1] = s[i] 
	return out

static var rng = RandomNumberGenerator.new()

static func random_choice(arr: Array):
	return arr[rng.randi_range(0, len(arr) - 1)]

static func random_chance(chance: float):
	return rng.randf() < chance

static func random_branch(chances: PackedFloat32Array):
	var total = 0
	for c in chances:
		total += c
	var x = rng.randf_range(0, total)
	var i = 0
	var accumulator = 0
	while i < len(chances):
		accumulator += chances[i]
		if accumulator > x:
			break
		i += 1
	return i

static func random_choice_weighted(choices, weights):
	assert (len(choices) == len(weights))
	return choices[random_branch(weights)]

static var alphanum = "0123456789abcdefghijklmnopqrstuvvwxyzABCDEFGHIJKLMNOPQRSTUVVWXYZ "
static func remove_punctuation(s, remove_apostrophes = false, remove_hyphens = false):
	var out = ""
	for c in s:
		if c in alphanum or (not remove_apostrophes) and c == "'":
			out += c
		if c == "-" and not remove_hyphens:
			out += " "
	return out 

