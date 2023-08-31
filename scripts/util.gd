extends Node

func damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return lerp(current, target, K)
	
func log_damp(current, target, factor, delta):
	var K = 1 - pow(factor, delta)
	return exp(lerp(log(current), log(target), factor))
