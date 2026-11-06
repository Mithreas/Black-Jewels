int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    string sResRef  = "";

    while (GetIsObjectValid(oItem))
    {
        sResRef = GetResRef(oItem);

        if (sResRef == "gs_item897" || //meat big
            sResRef == "gs_item898" || //meat medium
            sResRef == "gs_item899")   //meat small
        {
            return TRUE;
        }

        oItem   = GetNextItemInInventory(oSpeaker);
    }

    return FALSE;
}
