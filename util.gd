extends Object

class_name Util

static func reverse_string(s):
	var out = s
	for i in len(s):
		out[len(s) - i - 1] = s[i] 
	return out

