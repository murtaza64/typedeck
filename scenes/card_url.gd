extends "res://scenes/card.gd"

const tlds = [
	"com",
	"net",
	"org",
	"io",
]

func init():
	var hostname = Util.random_choice(en1k)
	var tld = Util.random_choice(tlds)
	var url = ""
	if Util.random_chance(1/3.0):
		url += "https://"
	if Util.random_chance(1/3.0):
		url += "www."
	url += hostname + "." + tld
	match Util.random_branch([0.5, 0.25, 0.25]):
		0:
			pass
		1:
			var path = Util.random_choice(en1k)
			url += "/" + path
		2:
			var path1 = Util.random_choice(en1k)
			var path2 = Util.random_choice(en1k)
			url += "/%s/%s" % [path1, path2]
	set_text_input(url)
	set_instructions("Type the URL")