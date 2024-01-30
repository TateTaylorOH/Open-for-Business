Scriptname LCO_HYOR_OnInitUpdateScript extends Quest  

GlobalVariable Property LCO_HYOR_IBInstalled  Auto  

EVENT OnInit()
	LCO_HYORUpdater()
ENDEVENT

Function LCO_HYORUpdater()
	if Game.GetFormFromFile(0x0804, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() <= 0
		LCO_HYOR_IBInstalled.SetValue(1)
	elseif !Game.GetFormFromFile(0x0804, "LCO_IliacBay.esp") as bool && LCO_HYOR_IBInstalled.GetValue() >= 1
		LCO_HYOR_IBInstalled.SetValue(0)
    endif
EndFunction