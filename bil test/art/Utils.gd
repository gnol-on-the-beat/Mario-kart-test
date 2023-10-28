extends Node
class_name Utils


static func mytest(a,b):
	return a+b
	

# This function is called in the test scene, so to run this test run the test scene.
static func test():
	var stuff = [mytest(1,7), 38]
	return stuff

