//::///////////////////////////////////////////////
//:: FileName ca_givenecklace
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 7/27/2013 2:18:11 PM
//:://////////////////////////////////////////////
void main()
{
    // Give the speaker the items
    CreateItemOnObject("it_mneck031", GetPCSpeaker(), 1);
  object oPC = GetPCSpeaker();

object oTarget;
oTarget = OBJECT_SELF;

DestroyObject(oTarget, 0.0);
}
