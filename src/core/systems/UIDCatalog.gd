class_name UIDCatalog
extends Node
#This class is used to store UIDs for game objects that might want to be instantiated
#It is global so simply calling LevelCatalog.[NameOfConstant] will return the value

#Menus
const Menu_Main : String = "uid://k68tl4ppllaa"
const Menu_Options : String = "uid://cclbjekru4nbm"
const Menu_Quit : String = "uid://tl3m7s666fu6"

#Levels

#Entities
const Entity_Player : String = "uid://bw4t4ix88htau"

#Other

#Given the name of a scene, return its UID
static func GetUIDFromString(itemName : String) -> String:
	match itemName:
		"Menu_Main":
			return Menu_Main
		"Menu_Options":
			return Menu_Options
		"Menu_Quit":
			return Menu_Quit
		"Entity_Player":
			return Entity_Player
		_:
			return ""
