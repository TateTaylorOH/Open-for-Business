Scriptname LCO_HYOR_OnInitUpdateScript extends Quest  
{Controls patchless integration. This is a unique controller, do NOT reuse this script generically. If you are interested in adding claims for Jehanna it is recommended to simply master LCO_IliacBay.esp to your file.}

EVENT OnInit()
    ;Debug.Notification("OnInit() fired.")
    LCO_HYORUpdater()	
ENDEVENT

Function LCO_HYORUpdater()
    ;Debug.Notification("LCO_HYORUpdater() begin.")
    EnableJehannaClaims()
    InjectEECItems()
    ;Debug.Notification("LCO_HYORUpdater() finished.")
EndFunction

;-- Jehanna Support ---------------------------------------

GlobalVariable Property LCO_HYOR_IBInstalled  Auto
Faction Property LCO_HYOR_JehannaDummyFaction auto
Keyword Property LocationChangeOwnershipEvent auto
LeveledActor Property LCO_HYOR_LCharJehannaGuardCaptainDummy auto
LeveledActor Property LCO_HYOR_LCharJehannaGuardFacesDummy auto
LeveledItem Property LCO_HYOR_JehannaItems auto
Location Property HYORFortIcemothLocation auto
ObjectReference Property LCO_IcemothControlMarkerJehanna auto

int CaptainFormsAdded = 0
int GuardFormsAdded = 0

Function EnableJehannaClaims()
	if Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() <= 0 || GuardFormsAdded > 6 && CaptainFormsAdded > 6
		LCO_HYOR_IBInstalled.SetValue(1) ;sets a global to confirm it is installed, allowing for Jehanna claims
		(Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction).SetAlly(LCO_HYOR_JehannaDummyFaction)
		IF GuardFormsAdded > 6
			LCO_HYOR_LCharJehannaGuardFacesDummy.Revert()
		ENDIF
		while (GuardFormsAdded < 6)
			LCO_HYOR_LCharJehannaGuardFacesDummy.AddForm(Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp"), 1)
			GuardFormsAdded += 1
		endwhile
		IF CaptainFormsAdded > 6
			LCO_HYOR_LCharJehannaGuardCaptainDummy.Revert()
		ENDIF
		while (CaptainFormsAdded < 6) ;does the same thing as above, but specifically for the unique Captain
			LCO_HYOR_LCharJehannaGuardCaptainDummy.AddForm(Game.GetFormFromFile(0x082C, "LCO_IliacBay.esp"), 1)
			CaptainFormsAdded += 1
		endwhile
		InjectJehannaItems()		
	elseif !Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() >= 1
		LCO_HYOR_IBInstalled.SetValue(0) ;forbids Jehanna claims
		IF LCO_IcemothControlMarkerJehanna.IsEnabled()
			LocationChangeOwnershipEvent.sendStoryEvent(HYORFortIcemothLocation, none, none, LCO.Default())
		ENDIF
		LCO_HYOR_LCharJehannaGuardFacesDummy.Revert() ;revert any script added forms
		GuardFormsAdded = 0
		LCO_HYOR_LCharJehannaGuardCaptainDummy.Revert()	
		CaptainFormsAdded = 0		
		LCO_HYOR_JehannaItems.Revert()
    	endif
endFunction

Function InjectJehannaItems()
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x0805, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x0806, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x0822, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x0824, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x0826, "LCO_IliacBay.esp"), 1, 1)
	LCO_HYOR_JehannaItems.AddForm(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"), 1, 1)
EndFunction

;-- East Empire Company Armor Support ---------------------------------------

LeveledItem Property LCO_HYOR_EECItems auto

bool EECInjected = false

Function InjectEECItems()
	IF Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == false
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0807, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0809, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x080B, "EastEmpireCompanyArmor.esp"), 1, 1)
		EECInjected = True
	ELSEIF !Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == true
		LCO_HYOR_EECItems.Revert()
		EECInjected = false
	ENDIF
EndFunction
