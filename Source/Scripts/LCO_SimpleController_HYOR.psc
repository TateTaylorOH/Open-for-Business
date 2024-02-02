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
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.LocalHold())
		myDefaultBanner.disableNoWait()
		myHoldBanner.enableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.Player())
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.enableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
		EnableJehannaGuardArmorCrafting()
	elseif(i == LCO.Imperial())
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.enableNoWait()
		myEastEmpireCompanyBanner.disableNoWait()
	elseif(i == LCO.EastEmpireCompany())
		myDefaultBanner.disableNoWait()
		myHoldBanner.disableNoWait()
		myJehannaBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myEastEmpireCompanyBanner.enableNoWait()
	endIf
	DisableIcemothBoss()
endFunction

;-- Fort Icemoth Exclusives ---------------------------------------

Actor Property  FortIcemoth_Silas auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the boss.}
Actor Property  FortIcemoth_SilasMinion auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the boss minion.}
Location Property  FortIcemoth_HYORFortIcemothLocation auto
{Fort Icemoth Exclusive Property: Checks to make sure the current location is Fort Icemoth before running exclusive functions.}
ObjectReference Property FortIcemoth_WatcherMarker auto
{Fort Icemoth Exclusive Property: Controls enabling and disabling the Watcher's body.} 

function DisableIcemothBoss()
	IF thisLocation == FortIcemoth_HYORFortIcemothLocation
		IF myDefaultBanner.IsEnabled()
			FortIcemoth_Silas.enableNoWait()
			FortIcemoth_SilasMinion.enableNoWait()
			FortIcemoth_WatcherMarker.enableNoWait()
		ELSEIF myDefaultBanner.IsDisabled()
			FortIcemoth_Silas.disableNoWait()
			FortIcemoth_SilasMinion.disableNoWait()
			FortIcemoth_WatcherMarker.disableNoWait()
		ENDIF
	ENDIF
endFunction

;-- Jehanna Support ---------------------------------------

function EnableJehannaGuardArmorCrafting()
	GlobalVariable LCO_IB_CraftingEnable = Game.GetFormFromFile(0x0183C, "LCO_IliacBay.esp") as GlobalVariable
	
	IF LCO_IB_CraftingEnable.GetValue() < 1
		LCO_IB_CraftingEnable.SetValue(1)
	ENDIF
endFunction