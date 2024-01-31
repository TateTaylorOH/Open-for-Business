Scriptname LCO_SimpleController_HYOR extends LCO_SimpleControllerBase
{A simple controller for use in claims across the Hjorkvild Isles. Includes a few exclusive functions if specifically claiming Fort Icemoth.}

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
		myDefaultBanner.enableNoWait()
		EnableIcemothBoss() ;Exclusive function for Fort Icemoth
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.LocalHold())
		myDefaultBanner.disableNoWait()
		DisableIcemothBoss()
		myHoldBanner.enableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.Player())
		myDefaultBanner.disableNoWait()
		DisableIcemothBoss() ;Exclusive function for Fort Icemoth
		myHoldBanner.disableNoWait()
		myJehannaBanner.enableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
		ImportJehannaQuartermaster() ;Will make Jehanna Guard's Armor craftable after claiming a location. The rest of the function is Fort Icemoth exclusive.
	elseif(i == LCO.Imperial())
		myDefaultBanner.disableNoWait()
		DisableIcemothBoss() ;Exclusive function for Fort Icemoth
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.enableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.EastEmpireCompany())
		myDefaultBanner.disableNoWait()
		DisableIcemothBoss() ;Exclusive function for Fort Icemoth
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.enableNoWait()
	endIf
endFunction

;-- Fort Icemoth Exclusives ---------------------------------------

Actor Property IcemothQuartermasterJehanna auto
{Fort Icemoth Exclusive Property: Used to control patchless compatibility with the Jehanna Quartermaster.}
Actor Property Silas auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the boss.}
Actor Property SilasMinion auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the boss minion.} 
Location Property HYORFortIcemothLocation auto
{Fort Icemoth Exclusive Property: Checks to make sure the current location is Fort Icemoth before running exclusive functions.}
ObjectReference Property WatcherMarker auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the Watcher's body.} 

function DisableIcemothBoss()
	IF thisLocation == HYORFortIcemothLocation 
		Silas.Disable()
		SilasMinion.Disable()
		WatcherMarker.Disable()
	ENDIF
endFunction

function EnableIcemothBoss()
	IF thisLocation == HYORFortIcemothLocation 
		Silas.Enable()
		SilasMinion.Enable()
		WatcherMarker.Enable()
	ENDIF
endFunction

function ImportJehannaQuartermaster()
	IF thisLocation == HYORFortIcemothLocation 
		IF !IcemothQuartermasterJehanna.IsInFaction(Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction)
			IcemothQuartermasterJehanna.AddToFaction(Game.GetFormFromFile(0x080C, "LCO_IliacBay.esp") as Faction)
		ENDIF
		IF IcemothQuartermasterJehanna.GetItemCount(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp")) < 1
			IcemothQuartermasterJehanna.AddItem(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"), 1)
			IcemothQuartermasterJehanna.EquipItem(Game.GetFormFromFile(0x080A, "LCO_IliacBay.esp"))
		ENDIF
	ENDIF
	IF (Game.GetFormFromFile(0x0183C, "LCO_IliacBay.esp") as GlobalVariable).GetValue() < 1
		(Game.GetFormFromFile(0x0183C, "LCO_IliacBay.esp") as GlobalVariable).SetValue(1)
	ENDIF
endFunction
