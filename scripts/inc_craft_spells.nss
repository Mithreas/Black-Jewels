// inc_craft_spells
// Include file for Craft power spell scripts
// Provides utility functions for Jewel-scaled Craft powers

#include "inc_jewels"

// Get the caster's Jewel strength for scaling
int crGetJewelScale(object oCaster)
{
    int nJewel = jGetJewelStrength(oCaster);
    if (nJewel < 1) nJewel = 1;
    return nJewel;
}

// Check if caster meets Jewel requirement for a power
// Returns TRUE if requirements met, FALSE otherwise
// Also sends failure message if requirements not met
int crCheckJewelRequirement(object oCaster, int nRequiredJewel, string sPowerName)
{
    int nJewel = jGetJewelStrength(oCaster);
    
    if (nJewel < nRequiredJewel)
    {
        SendMessageToPC(oCaster, "You require " + GetStringByStrRef(16777600 + nRequiredJewel) + " Jewel to use " + sPowerName + ".");
        return FALSE;
    }
    return TRUE;
}

// Get Jewel name for display
string crGetJewelName(int nJewel)
{
    switch (nJewel)
    {
        case 1: return "White";
        case 2: return "Yellow";
        case 3: return "Tiger Eye";
        case 4: return "Rose";
        case 5: return "Summer Sky";
        case 6: return "Purple Dusk";
        case 7: return "Opal";
        case 8: return "Green";
        case 9: return "Sapphire";
        case 10: return "Red";
        case 11: return "Gray";
        case 12: return "Ebony Gray";
        case 13: return "Black";
        default: return "Unknown";
    }
}
