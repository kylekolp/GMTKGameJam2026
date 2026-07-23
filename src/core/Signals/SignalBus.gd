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
# Important: If you connect a node to a signal make sure to add the "tree_exited" signal and within it call LoadLevel.disconnect(WhateverFunctionYouConnected)
# 			 Otherwise you might accidently connect the signal multiple times
#
# To Emit the signal just call
# SignalBus.testSignal.emit(someArea2D)

#Signals
@warning_ignore_start("unused_signal")

#Main
signal LoadLevel(levelUID : String)
signal LoadMenu(menuUID : String)
signal LoadSystem(systemUID : String)
signal TryQuit()
signal ConfirmQuit()
signal Pause()
signal UnPause()
signal GameOver()

#Level
signal LoadEntity(entityUID : String, position: Vector2, parent : Node2D)
signal LoadEffect(effectUID : String)

signal RopeComplete(rope : Node2D)

@warning_ignore_restore("unused_signal")
