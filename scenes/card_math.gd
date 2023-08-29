extends "res://scenes/card.gd"

func init():
	var operator = [
		"plus",
		"plus",
		"plus",
		"minus",
		"minus",
		"times"
	][rng.randi_range(0, 5)]

	var n1
	var n2
	var ans
	if operator == "plus":
		n1 = rng.randi_range(0, 30)
		n2 = rng.randi_range(0, 30)
		ans = n1 + n2
	elif operator == "minus":
		n1 = rng.randi_range(0, 50)
		n2 = rng.randi_range(0, n1)
		ans = n1 - n2
	elif operator == "times":
		n1 = rng.randi_range(0, 12)
		if n1 > 8:
			# n1     9  10 11 12
			# n2 max 11 10 9  8
			n2 = rng.randi_range(0, (20 - n1))
		else:
			n2 = rng.randi_range(0, 12)
		ans = n1 * n2
	var n1_words = num_to_words(n1)
	var n2_words = num_to_words(n2)
	var prompt_text = "%s %s %s equals" % [n1_words[0], operator, n2_words[0]]
	var ans_words = num_to_words(ans)
	var answer_text = ans_words[0]

	var variants = {}
	for i in ans_words[1]:
		variants[i] = " "

	print(prompt_text, answer_text)
	set_text_input(answer_text, false, variants)
	set_prompt(prompt_text)
	set_instructions("Do math")

const num_words = [
	"zero",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
	"eleven",
	"twelve",
	"thirteen",
	"fourteen",
	"fifteen",
	"sixteen",
	"seventeen",
	"eighteen",
	"nineteen",
]
const tens_words = {
	20: "twenty",
	30: "thirty",
	40: "forty",
	50: "fifty",
	60: "sixty",
	70: "seventy",
	80: "eighty",
	90: "ninety",
	100: "one hundred",
}
func num_to_words(n):
	if n < 20:
		return [num_words[n], []]
	else:
		var tens_part = tens_words[(n / 10) * 10] 
		var units_part = ""
		var hyphen_indexes = []
		if n % 10 != 0:
			units_part = "-" + num_words[n % 10] 
			hyphen_indexes.append(len(tens_part))
		return [tens_part + units_part, hyphen_indexes]