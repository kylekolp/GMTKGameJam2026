class_name UIDCatalog
extends Node
#This class is used to store UIDs for game objects that might want to be instantiated
#It is global so simply calling LevelCatalog.[NameOfConstant] will return the value

#Systems
const System_PauseAction : String = "uid://n3t0af3g7475"
const System_Score : String = "uid://ug60f2r81iy6"

#Menus
const Menu_Main : String = "uid://k68tl4ppllaa"
const Menu_Options : String = "uid://cclbjekru4nbm"
const Menu_Quit : String = "uid://tl3m7s666fu6"
const Menu_Pause : String = "uid://c2b2lxq0i2ysi"
const Menu_GameOver : String = "uid://6kstv1i2rqao"
const Menu_Tutorial : String = "uid://dq0jsvfgoit02"

const Menu_Intro : String = "uid://kfbhtop1n20d"

#Levels
const Level_1 : String = "uid://b6p18mlsjkqut"

#Entities
const Entity_Player : String = "uid://bw4t4ix88htau"
const Entity_Rocket : String = "uid://c86xeg2esb2uo"
const Entity_Fire : String = "uid://tequb32i5gkj"
const Entity_FireBurnRope : String = "uid://wf071cv4c6v6"
const Entity_Rope : String = "uid://dxkiorh8g5kvt"

#UI
const UI_Score : String = "uid://cutlm6om3imjp"
const UI_Lives : String = "uid://dyjipvvvlgxpl"
const ScoreNumberSpawner : String = "uid://c822q8pcdetsc"
const System_Lives : String = "uid://c3cosdww72dkg"

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
		"Menu_Pause":
			return Menu_Pause
		"Entity_Player":
			return Entity_Player
		_:
			return ""
