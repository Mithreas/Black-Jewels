/**
  zdlg_pc_init
  
  This is based on zdlg_subrace and provides options for new players.
  
  Rather than going through one thing at a time, this presents all options side by side. 
  New PCs can pick as many of them as they like, then move on.
  A lever in the new starter area will let them restart the convo if needed.
  
  Subraces can only be picked once (since they modify stats).  Similarly, once gifts
  are applied, they can't be changed.  The convo simply stops showing the option. 

  Implementation notes:
  - The Confirm dialog looks for the ZPI_CONFIRM_DESC String variable and displays that 
    as a summary of the changes to be confirmed.  It then returns to the main page
	(whether confirmed or not).  So the same Confirm dialog can be used for all changes.

*/
#include "inc_achievements"
#include "inc_bonuses"
#include "inc_class"
#include "inc_jewels"
#include "inc_log"
#include "inc_zdlg"

const string MAIN_MENU       = "ZPI_MAIN_MENU";
const string B_JEWELS_OPTS    = "ZPI_B_JEWELS";
const string O_JEWELS_OPTS   = "ZPI_O_JEWELS";
const string CONFIRM         = "ZPI_CONFIRM";
const string CONFIRM_DESC    = "ZPI_CONFIRM_DESC";
const string CONFIRM_PAGE    = "ZPI_CONFIRM_PAGE";
const string CONFIRM_OPT     = "ZPI_CONFIRM_OPT";
const string HEIGHT_OPTS     = "ZPI_HEIGHT_OPTIONS";
const string AWARD_OPTS      = "ZPI_AWARD_OPTIONS";

string INTRO = "Welcome to the world of the Black Jewels!\n\nThis server implements the setting of Anne Bishop's Black Jewels books.  Eventually, you'll be able to "
+ "create any of the types of character she writes about in her books, but at this stage of development, there are still a few limitations.  Still, there are plenty "
+ "of possibilities to explore, and the world is set up to encourage and reward working together to form Courts and wield power together.";

string B_JEWELS_INTRO = "Select the rank of your Birthright Jewel.  At present, only White, Yellow and Tiger Eye are available.  In time, availability will expand.";
string O_JEWELS_INTRO = "Select how many ranks you wish to descend with your Offering, or select No Offering if you want to make the Offering to the Darkness later, in game. "
+ "In future, we will support descending the full three ranks, but for now characters are limited to two.";

void _removeAward(object oPC, string sAwardType)
{
    string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
    int nAwards = GetLocalInt(oPC, "sAwardType") -1;
    miDASetKeyedValue("gs_player_data", sID, "sAwardType", IntToString(nAwards));	
	
    SetLocalInt(oPC, "award1", 0);
    SetLocalInt(oPC, "award2", 0);
    SetLocalInt(oPC, "award3", 0);
}

//--------------------------------------------------------------------------------------------------------
// Jewel-related utility methods.
//--------------------------------------------------------------------------------------------------------
void _SetUpAllowedJewels()
{
  DeleteList(B_JEWELS_OPTS);
  AddStringElement("No Jewel", B_JEWELS_OPTS);
  AddStringElement("White", B_JEWELS_OPTS);
  AddStringElement("Yellow", B_JEWELS_OPTS);
  AddStringElement("Tiger Eye", B_JEWELS_OPTS);
}

void _SetUpAllowedDescents()
{
  object oPC = GetPcDlgSpeaker();  
  int nBirthrightRank = jGetBirthrightJewel(oPC);
  string sDescent0 = "";
  string sDescent1 = "";
  string sDescent2 = "";
  
  if (!nBirthrightRank) O_JEWELS_INTRO += "\n\nWARNING: Select your Birthright Jewel first unless you deliberately intend not to have one!";

  switch (nBirthrightRank)
  {
    case 0:
	  sDescent0 = "No Jewel";
	  sDescent1 = "White";
	  sDescent2 = "Yellow";
	  break;
	case 1:
	  sDescent0 = "White";
	  sDescent1 = "Yellow";
	  sDescent2 = "Tiger Eye";
	  break;
	case 2:
	  sDescent0 = "Yellow";
	  sDescent1 = "Tiger Eye";
	  sDescent2 = "Rose";
	  break;
	case 3:
	  sDescent0 = "Tiger Eye";
	  sDescent1 = "Rose";
	  sDescent2 = "Summer Sky";
	  break;
	  
  }

  DeleteList(O_JEWELS_OPTS);
  AddStringElement("No Offering", O_JEWELS_OPTS);
  AddStringElement("No descent, Offering rank " + sDescent0, O_JEWELS_OPTS);
  AddStringElement("Descend 1 rank, Offering rank " + sDescent1, O_JEWELS_OPTS);
  AddStringElement("Descend 2 ranks, Offering rank " + sDescent2, O_JEWELS_OPTS);
}

void _ApplyBJewel()
{
    object oPC = GetPcDlgSpeaker();  
    object oItem = gsPCGetCreatureHide(oPC, TRUE);

    string sJewel = GetLocalString(OBJECT_SELF, CONFIRM_DESC);
	
    if (sJewel == "No Jewel")
    {
	  // Do nothing.
    }
    else if (sJewel == "White")
    {
		jSetBirthrightJewel(oPC, 1);
    }
    else if (sJewel == "Yellow")
    {
		jSetBirthrightJewel(oPC, 2);
    }
    else if (sJewel == "Tiger Eye")
    {
		jSetBirthrightJewel(oPC, 3);
    }

	jRefreshAlignment(oPC);
	SetDlgPageString(O_JEWELS_OPTS);
}

void _ApplyOJewel()
{
    object oPC = GetPcDlgSpeaker(); 
	int nSelection = GetLocalInt(OBJECT_SELF, CONFIRM_OPT);
	
	// In O_JEWELS_OPTS, the first option is "no offering" - so don't do anything.  
	// The next three options are to descend 0, 1 or 2 ranks.  That locks in the 
	// Offering (and Birthright) Jewels. 
  
	if (nSelection)
	{
		int nOfferingRank = jGetBirthrightJewel(oPC) + nSelection - 1;
		jSetRankJewel(oPC, nOfferingRank);	
		jRefreshAlignment(oPC);
	}
  
	SetDlgPageString(MAIN_MENU);  
}

void _SetUpMainOptions()
{ 
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  
  if (!GetIsObjectValid(oHide))
  {
    oHide = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oPC);

    if (GetIsObjectValid(oHide))
    {
        AssignCommand(oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR));
    }
  }
  
  DeleteList(MAIN_MENU);
  
  if (!jGetBirthrightJewel(oPC) && !jGetRankJewel(oPC)) AddStringElement("Birthright Jewel options", MAIN_MENU);
  if (!jGetRankJewel(oPC)) AddStringElement("Offering Descent options", MAIN_MENU);
  //if (GetLocalInt(oPC, "award1") || GetLocalInt(oPC, "award2") || GetLocalInt(oPC, "award3")) AddStringElement("Award options", MAIN_MENU);
  AddStringElement("PC height options", MAIN_MENU);
  AddStringElement("[Done]", MAIN_MENU);
  
  if (GetElementCount(HEIGHT_OPTS) == 0)
  {
    AddStringElement("Normal height", HEIGHT_OPTS);
    AddStringElement("Shorter than average", HEIGHT_OPTS);
    AddStringElement("Taller than average", HEIGHT_OPTS);
    AddStringElement("Very short", HEIGHT_OPTS);
    AddStringElement("Very tall", HEIGHT_OPTS);
  }
  
}

//------------------------------------------------------------------------------
// end utility methods - everything below here is part of the conversation.
//------------------------------------------------------------------------------
void Init()
{
  // This method is called once, at the start of the conversation.
  Trace(SUBRACE, "Subrace conversation initialising.");
  
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  int nRace        = GetRacialType(oPC);

  // Check if this character has any awards to use.  If they already have an award, skip.
  if (!GetLocalInt(oHide, "HAS_MAJOR_AWARD") && 
      !GetLocalInt(oHide, "HAS_NORMAL_AWARD") && 
	  !GetLocalInt(oHide, "HAS_MINOR_AWARD"))
  {
	string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oPC));
	SetLocalInt(oPC, "award1", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1"))); //major
	SetLocalInt(oPC, "award2", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award2"))); //medium
	SetLocalInt(oPC, "award3", StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award3"))); //minor
  }
  
  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(CONFIRM) == 0)
  {
    AddStringElement("[Select]", CONFIRM);
    AddStringElement("[Back]", CONFIRM);
  }
      
  if (!GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
  {
    CreateItemOnObject("mi_mark_destiny", oPC);
  }
  
  // Initialise ECL and creature hide/ms/dex
  miBAIncreaseECL(oPC, 0.0f);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  int nRP = gsPCGetRolePlay(oPC);

  Trace(SUBRACE, "Setting up dialog page: " + sPage);
  if (sPage == "" || sPage == MAIN_MENU)
  {
    SetDlgPrompt(INTRO);
	_SetUpMainOptions();
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);	
  }
  else if (sPage == CONFIRM)
  {
    SetDlgPrompt("Selected option: " + GetLocalString(OBJECT_SELF, CONFIRM_DESC) + "\n\nAre you sure?");
    SetDlgResponseList(CONFIRM, OBJECT_SELF);
  }
  else if (sPage == HEIGHT_OPTS)
  {
    SetDlgPrompt("You may choose the approximate height of your character compared to your race's normal height.");
    SetDlgResponseList(HEIGHT_OPTS, OBJECT_SELF);	
  }
  else if (sPage == B_JEWELS_OPTS)
  {
    _SetUpAllowedJewels();
    SetDlgPrompt(B_JEWELS_INTRO);
    SetDlgResponseList(B_JEWELS_OPTS, OBJECT_SELF);
  }
   else if (sPage == O_JEWELS_OPTS)
  {
    _SetUpAllowedDescents();
    SetDlgPrompt(O_JEWELS_INTRO);
    SetDlgResponseList(O_JEWELS_OPTS, OBJECT_SELF);
  }
  else if (sPage == AWARD_OPTS)
  {
    int nType = GetLocalInt(oPC, "award_type");
    DeleteList(AWARD_OPTS);

    SetDlgPrompt("Select benefit.  Minor awards give -1 ECL, normal awards give "
     + "-2 and major awards give -3.");
	 
	string sType = "-1";
	if (GetLocalInt(oPC, "award2")) sType = "-2";
	if (GetLocalInt(oPC, "award1")) sType = "-3"; 

    AddStringElement("No award", AWARD_OPTS);
    AddStringElement("Reduced ECL (" + sType + ")", AWARD_OPTS);
    if (nType != 3)
    {
      //AddStringElement(GIFT_OF_SPELL_SHIELDING_DESC, AWARD_OPTS);
    }
    if (nType == 1)
    {
      //AddStringElement("Red Dragon Disciple PRC token", AWARD_OPTS);
      //AddStringElement("Shifter PRC token", AWARD_OPTS);
    }

    SetDlgResponseList(AWARD_OPTS);
  } 
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection    = GetDlgSelection();
  object oPC       = GetPcDlgSpeaker();
  object oHide     = gsPCGetCreatureHide(oPC, TRUE);
  string sPage     = GetDlgPageString();
  int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

  Trace(SUBRACE, "Player has selected an option: " + IntToString(selection));
  Trace(SUBRACE, "Page: " + sPage);
  if (sPage == "" || sPage == MAIN_MENU)
  {
    string sNextPage = GetStringElement(selection, MAIN_MENU);
	
	if (sNextPage == "Birthright Jewel options") SetDlgPageString(B_JEWELS_OPTS);
	else if (sNextPage == "Offering Descent options") SetDlgPageString(O_JEWELS_OPTS);
	else if (sNextPage == "PC height options") SetDlgPageString(HEIGHT_OPTS);
	else if (sNextPage == "Award options") SetDlgPageString(AWARD_OPTS);
	else EndDlg();	
  }
  else if (sPage == CONFIRM)
  {
	SetDlgPageString(MAIN_MENU);  // At the top so it can be overridden, e.g. by some paths. 
	
    if (selection)
	{
	    // Do nothing - just go back. 	
	}
	else
	{
	  sPage = GetLocalString(OBJECT_SELF, CONFIRM_PAGE);
	  
	  if (sPage == B_JEWELS_OPTS)
	  {
	    _ApplyBJewel();
	  }
	  else if (sPage == O_JEWELS_OPTS)
	  {
	    _ApplyOJewel();
	  }
	  else if (sPage == HEIGHT_OPTS)
	  {
	    int nHeight = GetLocalInt(OBJECT_SELF, CONFIRM_OPT);
		float fHeight = 1.0f;
		
		switch (nHeight)
		{
		  case 0: // Normal
		    fHeight = 0.97f + ( Random(6) / 100); // 0.97 - 1.02
		    break;
		  case 1: // Short
		    fHeight = 0.91f + ( Random(6) / 100); // 0.91 - 0.96
		    break;
		  case 2: // Tall
		    fHeight = 1.03f + ( Random(6) / 100); // 1.03 - 1.08
		    break;
		  case 3: // Very short
		    fHeight = 0.85f + ( Random(6) / 100); // 0.85 - 0.90
		    break;
		  case 4: // Very tall
		    fHeight = 1.09f + ( Random(6) / 100); // 1.08 - 1.14
		    break;
		}
		
		SetLocalFloat(oPC, "AR_SCALE", fHeight);
		SetLocalFloat(gsPCGetCreatureHide(oPC), "AR_SCALE", fHeight);

	    // Resize ourselves appropriately.
	    gsPCRefreshCreatureScale(oPC);	
		SetDlgPageString(MAIN_MENU); 		
	  }
	  else if (sPage == AWARD_OPTS)
	  {	
		int nAwardChoice = GetLocalInt(OBJECT_SELF, CONFIRM_OPT);  // Option zero is "go back" so we should never have zero. 

		int nType = 1;
		
		if (!GetLocalInt(oPC, "award1")) 
		{
		  // No Major awards, so check Normal.
		  nType = 2;
		  
		  if (!GetLocalInt(oPC, "award2")) 
		  {
		    // No Normal awards either, so check Minor. 
		    nType = 3;
			
			if (!GetLocalInt(oPC, "award3")) nType = 0; // Should never hit this, but putting in for safety.
		  }
		}
				
        switch (nAwardChoice)
        {
          case 1:
          {
            // ECL
            switch (nType)
            {
              case 1:
                SendMessageToPC(oPC, "Applying -3 ECL");
                miBAIncreaseECL(oPC, -3.0f);
                break;
              case 2:
                miBAIncreaseECL(oPC, -2.0f);
                SendMessageToPC(oPC, "Applying -2 ECL");
                break;
              case 3:
                miBAIncreaseECL(oPC, -1.0f);
                SendMessageToPC(oPC, "Applying -1 ECL");
                break;
            }
			
            break;
          }
        }

        // Remove used award.
        if (nAwardChoice)
        {
          object oCreatureHide = gsPCGetCreatureHide(oPC, TRUE);
          string sAward;
          switch (nType)
          {
            case 1:
              sAward = "award1";
              SetLocalInt(oCreatureHide, "HAS_MAJOR_AWARD", TRUE);
              break;
            case 2:
              sAward = "award2";
              SetLocalInt(oCreatureHide, "HAS_NORMAL_AWARD", TRUE);
              break;
            case 3:
              sAward = "award3";
              SetLocalInt(oCreatureHide, "HAS_MINOR_AWARD", TRUE);
              break;
          }

		  _removeAward(oPC, sAward);
        }
	  }
	}
  }
  else if (sPage == B_JEWELS_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, B_JEWELS_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, B_JEWELS_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);    
  }
  else if (sPage == O_JEWELS_OPTS)
  {
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, O_JEWELS_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, O_JEWELS_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);    
  }
  else if (sPage == AWARD_OPTS)
  {	
    SetLocalString(OBJECT_SELF, CONFIRM_DESC, GetStringElement(selection, AWARD_OPTS));
	SetLocalString(OBJECT_SELF, CONFIRM_PAGE, AWARD_OPTS);
    SetLocalInt(OBJECT_SELF, CONFIRM_OPT, selection);
    SetDlgPageString(CONFIRM);
  }
}

void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
      break;
    case DLG_END:
      ApplyCharacterBonuses(GetPcDlgSpeaker(), FALSE, TRUE, TRUE);
      break;
  }
}
