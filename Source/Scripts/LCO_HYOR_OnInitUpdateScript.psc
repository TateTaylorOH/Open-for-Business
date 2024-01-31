Scriptname LCO_HYOR_OnInitUpdateScript extends Quest  
{Controls patchless integration with LCO_IliacBay. This is a unique controller, do NOT reuse this script generically.}

GlobalVariable Property LCO_HYOR_IBInstalled  Auto  
LeveledActor Property LCO_IB_LCharJehannaGuardFacesDummy auto
LeveledActor Property LCO_IB_LCharJehannaGuardCaptainDummy auto
LeveledItem Property LCO_HYOR_JehannaItems auto
LeveledItem Property LCO_HYOR_EECItems auto
ObjectReference Property LCO_IcemothControlMarkerJehanna auto
Keyword Property LocationChangeOwnershipEvent auto
Location Property HYORFortIcemothLocation auto

int GuardFormsAdded = 0
int CaptainFormsAdded = 0
bool EECInjected = false

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

;Jehanna Support
Function EnableJehannaClaims()
	if Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() <= 0 ;checks to see if LCO_IliacyBay.esp is installed
		LCO_HYOR_IBInstalled.SetValue(1) ;sets a global to confirm it is installed, allowing for Jehanna claims
		;Debug.Notification(LCO_HYOR_IBInstalled.GetValue())
		while (GuardFormsAdded < 100) ;you cannot populate an empty LChar list with injected forms, so this adds a large number of Guard Forms from LCO_IliacyBay.esp to ensure the proper NPCs are enabled when claiming for Jehanna
			LCO_IB_LCharJehannaGuardFacesDummy.AddForm(Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp"), 1)
			GuardFormsAdded += 1
		endwhile
		LCO_IB_LCharJehannaGuardFacesDummy.SetNthCount(0, 0) ;removes the LCO_EECGuard dummy record to ensure they do not spawn, there is still around a 1% chance that the record will be selected, if it does, no guard will be added
		while (CaptainFormsAdded < 100) ;does the same thing as above, but specifically for the unique Captain
			LCO_IB_LCharJehannaGuardCaptainDummy.AddForm(Game.GetFormFromFile(0x082C, "LCO_IliacBay.esp"), 1)
			CaptainFormsAdded += 1
		endwhile
		LCO_IB_LCharJehannaGuardCaptainDummy.SetNthCount(0, 0)
		;Debug.Notification("Guards injected.")	
		InjectJehannaItems()		
	elseif !Game.GetFormFromFile(0x082D, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() >= 1 ;checks to see if LCO_IliacyBay.esp is NOT installed
		LCO_HYOR_IBInstalled.SetValue(0) ;forbids Jehanna claims
		IF LCO_IcemothControlMarkerJehanna.IsEnabled()
			LocationChangeOwnershipEvent.sendStoryEvent(HYORFortIcemothLocation, none, none, LCO.Default()) ;if Fort Icemoth is currently under Jehanna control, reset it to default
		ENDIF
		;Debug.Notification(LCO_HYOR_IBInstalled.GetValue())
		LCO_IB_LCharJehannaGuardFacesDummy.Revert() ;revert any script added forms
		LCO_IB_LCharJehannaGuardFacesDummy.SetNthCount(0, 1) ;reset the LCO_EECGuard dummy record to a count of 1
		GuardFormsAdded = 0
		LCO_IB_LCharJehannaGuardCaptainDummy.Revert()	
		LCO_IB_LCharJehannaGuardCaptainDummy.SetNthCount(0, 1)
		CaptainFormsAdded = 0		
		LCO_HYOR_JehannaItems.Revert()
		;Debug.Notification("LChar list reverted.")
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

;East Empire Company Armor Support
Function InjectEECItems()
	IF Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == false
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0807, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x0809, "EastEmpireCompanyArmor.esp"), 1, 1)
		LCO_HYOR_EECItems.AddForm(Game.GetFormFromFile(0x080B, "EastEmpireCompanyArmor.esp"), 1, 1)
		EECInjected = True
	ELSEIF Game.GetFormFromFile(0x0801, "EastEmpireCompanyArmor.esp") as bool && EECInjected == true
		LCO_HYOR_EECItems.Revert()
		EECInjected = false
	ENDIF
EndFunction
