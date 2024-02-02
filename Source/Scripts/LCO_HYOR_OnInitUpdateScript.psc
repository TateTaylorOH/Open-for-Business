Scriptname LCO_HYOR_OnInitUpdateScript extends Quest  
{Controls patchless integration. This is a unique controller, do NOT reuse this script generically. If you are interested in adding claims for Jehanna it is recommended to simply master LCO_IliacBay.esp to your file.}

EVENT OnInit()
    LCO_HYORUpdater()	
ENDEVENT

Function LCO_HYORUpdater()
	Faction LCO_IB_JehannaFaction = Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction

    JehannaSupport()
    EECArmorSupport()
	IF TG04EastEmpireFaction.GetReaction(LCO_IB_JehannaFaction) == 2
		TG04EastEmpireFaction.SetEnemy(LCO_IB_JehannaFaction, true, true)
	ENDIF
EndFunction

;-- Jehanna Support ---------------------------------------

GlobalVariable Property LCO_HYOR_IBInstalled  Auto
Keyword Property LocationChangeOwnershipEvent auto
LeveledItem Property LCO_HYOR_JehannaArmor auto
LeveledItem Property LCO_HYOR_JehannaArmorNoHelmNoShield auto
LeveledItem Property LCO_HYOR_JehannaWeapons auto
Location Property HYORFortIcemothLocation auto
ObjectReference Property LCO_IcemothControlMarkerJehanna auto
LCO_SimpleController_HYOR Property claimScript Auto

Faction Property LCO_HYOR_JehannaFaction_Dummy auto
LeveledActor Property LCO_HYOR_LCharJehannaGuardFaces_Dummy auto

Faction Property TG04EastEmpireFaction auto

int GuardFormsAdded = 0

Function JehannaSupport()
	Faction LCO_IB_JehannaFaction = Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction
	LeveledActor LCO_IB_LCharJehannaGuardFaces = Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp") as LeveledActor
	
	if LCO_IB_LCharJehannaGuardFaces as bool && LCO_HYOR_IBInstalled.GetValue() <= 0 || GuardFormsAdded > 6 ;checks is LCO_IliacBay.esp is installed
		LCO_HYOR_IBInstalled.SetValue(1) ;allows Jehanna claims
		LCO_HYOR_JehannaFaction_Dummy.SetAlly(LCO_IB_JehannaFaction) ;sets the dummy Jehanna faction to be allies with the "real" one
		LCO_HYOR_LCharJehannaGuardFaces_Dummy.Revert() ;reverts the Jehanna Guard LChar list (just in case)
		while GuardFormsAdded < 6 ;adds 6 entries from the Jehanna Guard LChar list to the local dummy one
			LCO_HYOR_LCharJehannaGuardFaces_Dummy.AddForm(LCO_IB_LCharJehannaGuardFaces, 1)
			GuardFormsAdded += 1
		endwhile
		InjectJehannaItems() ;injects Jehanna armors and weapons to dummy lists
	elseif !LCO_IB_LCharJehannaGuardFaces as bool && LCO_HYOR_IBInstalled.GetValue() >= 1
		LCO_HYOR_IBInstalled.SetValue(0) 
		IF LCO_IcemothControlMarkerJehanna.IsEnabled() ;unclaims Icemoth if it is currently controlled by Jehanna and LCO_IliacBay.esp is no longer detected
			LocationChangeOwnershipEvent.sendStoryEvent(HYORFortIcemothLocation, none, none, LCO.Default())
			claimScript.updateBanners(LCO.Default())
		ENDIF
		LCO_HYOR_LCharJehannaGuardFaces_Dummy.Revert() 
		GuardFormsAdded = 0
		LCO_HYOR_JehannaArmor.Revert()
    	endif
endFunction

Function InjectJehannaItems()
	LCO_HYOR_JehannaArmor.AddForm(Game.GetFormFromFile(0x0805, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmor.AddForm(Game.GetFormFromFile(0x0806, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmor.AddForm(Game.GetFormFromFile(0x0822, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmor.AddForm(Game.GetFormFromFile(0x0824, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmor.AddForm(Game.GetFormFromFile(0x0826, "LCO_IliacBay.esp"), 1, 1)

	LCO_HYOR_JehannaArmorNoHelmNoShield.AddForm(Game.GetFormFromFile(0x0805, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmorNoHelmNoShield.AddForm(Game.GetFormFromFile(0x0824, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaArmorNoHelmNoShield.AddForm(Game.GetFormFromFile(0x0826, "LCO_IliacBay.esp"), 1, 1)

	LCO_HYOR_JehannaWeapons.AddForm(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"), 1, 1)
EndFunction

;-- East Empire Company Armor Support ---------------------------------------

LeveledItem Property LCO_HYOR_EECArmor auto

bool EECInjected = false

Function EECArmorSupport()
	IF Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == false
		LCO_HYOR_EECArmor.AddForm(Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECArmor.AddForm(Game.GetFormFromFile(0x0807, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECArmor.AddForm(Game.GetFormFromFile(0x0809, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECArmor.AddForm(Game.GetFormFromFile(0x080B, "EastEmpireCompanyArmor.esp"), 1, 1)
		EECInjected = True
	ELSEIF !Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == true
		LCO_HYOR_EECArmor.Revert()
		EECInjected = false
	ENDIF
EndFunction