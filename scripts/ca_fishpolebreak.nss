void main()
{

object oPC = GetPCSpeaker();

object oItem;
oItem = GetItemPossessedBy(oPC, "AR_IT_FISHINGPOLE");

if (GetIsObjectValid(oItem))
   DestroyObject(oItem);

}

