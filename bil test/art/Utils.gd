extends Node
class_name Utils


static func mytest(a,b):
	return a+b


static func updateFuel(delta, fuel, turboIsOn, maxTurboDurationSeconds = 4, fullRegenerationTimeSeconds = 10, canRegenerate = true):
	var FPS = 1 / delta
	var turboCostPerFrame = 1 / (maxTurboDurationSeconds * FPS)
	var regenerationPerFrame = 1 / (fullRegenerationTimeSeconds * FPS)
	var newFuel

	if turboIsOn:
		newFuel = fuel - turboCostPerFrame
	elif canRegenerate:
		newFuel = fuel + regenerationPerFrame
	else:
		newFuel = fuel

	if newFuel > 1:
		return 1
	elif newFuel < 0:
		return 0
	else:
		return newFuel
	

# This function is called in the test scene, so to run this test run the test scene.
static func test():
	#var stuff = [mytest(1,7), 38]
	var fueltest = [
		[updateFuel((1.000 / 60) * 60 * 5 , 0, false), "should be", 0.5],
		[updateFuel((1.000 / 60) * 60 * 5 , 0.2, false), "should be", 0.7],
		[updateFuel((1.000 / 60) * 60 * 10 , 0.2, false), "should be", 1],
		[updateFuel((1.000 / 60) * 60 * 2 , 1, true), "should be", 0.5],
		[updateFuel((1.000 / 60) * 60 * 1 , 0.6, true), "should be", 0.35],
		[updateFuel((1.000 / 60) * 60 * 3 , 0, true), "should be", 0]
		]
	return fueltest

