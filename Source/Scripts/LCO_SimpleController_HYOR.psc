Scriptname LCO_SimpleController_HYOR extends LCO_SimpleControllerBase

;/inherited properties
Keyword CurrentOwnership
Keyword DefaultOwnership
Keyword ChangeOwnership
int newOwner
int defaultOwner
GlobalVariable realTimeUpdateDelay
GlobalVariable gameTimeUpdateDelay
Location thisLocation
Message Property Claim Auto
Message property NoClaim Auto
Message property QuestLocked Auto
ObjectReference Property ClaimingEnableParent Auto
/;

Location property myHold Auto
{The Hold this dungeon is in.}
Location[] property Holds Auto
{used to select the claim message and hold banner based on the myHold property}
Message[] Property ClaimMessages Auto
{overrides the Claim property with a Hold-specific message selected from this array.}
Form[] Property HoldBanners Auto
{base forms for the Hold banner near the controller.}
Form Property DefaultBanner Auto
{base form for the default banner near the controller.}
Form Property JehannaBanner Auto
{base form for the Jehanna banner near the controller.}
Form Property ImperialBanner Auto
{base form for the Imperial banner near the controller.}
Form Property EastEmpireCompanyBanner Auto
{base form for the EastEmpireCompany banner near the controller.}

int EastEmpireCompany

ObjectReference myDefaultBanner
ObjectReference myHoldBanner
ObjectReference myJehannaBanner
ObjectReference myImperialBanner
ObjectReference myEastEmpireCompanyBanner

Actor Property IcemothQuartermasterJehanna auto

Event OnLoad()
	EastEmpireCompany = LCO.EastEmpireCompany()
	parent.OnLoad()
endEvent

function getLocalBanners()
	int i = Holds.find(myHold)
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myHoldBanner = Game.findClosestReferenceOfTypeFromRef(HoldBanners[i], self, 400.0)
	myJehannaBanner = Game.findClosestReferenceOfTypeFromRef(JehannaBanner, self, 400.0)
	myImperialBanner = Game.findClosestReferenceOfTypeFromRef(ImperialBanner, self, 400.0)
	myEastEmpireCompanyBanner = Game.findClosestReferenceOfTypeFromRef(EastEmpireCompanyBanner, self, 400.0)
endFunction

int function processChoice(int selectedChoice, int currentOwner)
	if(selectedChoice == 0)
		return LCO.Default()
	elseif(selectedChoice == 1)
		return LCO.LocalHold()
	elseif(selectedChoice == 2)
		return LCO.Player()
	elseif(selectedChoice == 3)
		return LCO.Imperial()
	elseif(selectedChoice == 4)
		return LCO.EastEmpireCompany()
	endIf
	return currentOwner
endFunction

function hide()
	parent.hide()
	myDefaultBanner.disableNoWait()
	myHoldBanner.disableNoWait()
	myJehannaBanner.disableNoWait()
	myImperialBanner.disableNoWait()
	myEastEmpireCompanyBanner.disableNoWait()
endFunction

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO.Default())
		IF thisLocation == HYORFortIcemothLocation 
			EnableIcemothBoss()
		ENDIF
		myDefaultBanner.enableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.LocalHold())
		IF thisLocation == HYORFortIcemothLocation 
			DisableIcemothBoss()
		ENDIF
		myDefaultBanner.disableNoWait()
		myHoldBanner.enableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.Player())
		IF thisLocation == HYORFortIcemothLocation 
			DisableIcemothBoss()
		ENDIF
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.enableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
		IF thisLocation == HYORFortIcemothLocation 
			ImportJehannaQuartermaster()
		ENDIF
		IF (Game.GetFormFromFile(0x0183C, "LCO_IliacBay.esp") as GlobalVariable).GetValue() < 1
			(Game.GetFormFromFile(0x0183C, "LCO_IliacBay.esp") as GlobalVariable).SetValue(1)
		ENDIF
	elseif(i == LCO.Imperial())
		IF thisLocation == HYORFortIcemothLocation 
			DisableIcemothBoss()
		ENDIF
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.enableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.EastEmpireCompany())
		IF thisLocation == HYORFortIcemothLocation 
			DisableIcemothBoss()
		ENDIF
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.enableNoWait()
	endIf
endFunction

Actor Property Silas auto
Actor Property SilasMinion auto
ObjectReference Property WatcherMarker auto
Location Property HYORFortIcemothLocation auto

function DisableIcemothBoss()
	Silas.Disable()
	SilasMinion.Disable()
	WatcherMarker.Disable()
endFunction

function EnableIcemothBoss()
	Silas.Enable()
	SilasMinion.Enable()
	WatcherMarker.Enable()
endFunction

function ImportJehannaQuartermaster()
IF IcemothQuartermasterJehanna.GetItemCount(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp")) < 1
	IcemothQuartermasterJehanna.AddItem(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"), 1)
	IcemothQuartermasterJehanna.EquipItem(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"))
ENDIF
IF !IcemothQuartermasterJehanna.IsInFaction(Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction)
	IcemothQuartermasterJehanna.AddToFaction(Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction)
ENDIF
endFunction