extends Node
# Use this class to emit any custom signal that we wish to access globally. It is auto loaded so it can be treated as a singleton (Accessable from anywhere)
# Note: Not all signals have to be global. Only use for signals that are required to be received outside the emitting node 
# 		(For example children can connect to a parents node via the signals tab without being global)
#
# Example
# signal testSignal(source : Area2D)
#
# Then in any class that wishes to receive the signal just call:
# SignalBus.testSignal.connect(testSignalMethod) <--- this binds the signal to a function "testSignalMethod" which will be called whever the signal is emitted.
#
# To Emit the signal just call
# SignalBus.testSignal.emit(someArea2D)

#Signals
signal LoadLevel(levelUID : String)
signal LoadMenu(menuUID : String)
signal QuitGame()
