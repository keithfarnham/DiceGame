extends Node

func print(text : String):
	#wrapper for prints so that they won't be output in non-debug builds
	if OS.is_debug_build():
		print(text)
