// NW_S0_CrSanctify
// Sanctify - Priestess Caste Power
// Ward area against hostile Craft

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 3 minutes
    int nDuration = 180;
    
    // Area: 20 feet radius
    float fRadius = FeetToMeters(20.0);
    
    // Bonuses: +1 per Jewel rank to DC
    int nBonus = nJewelScale;

    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Apply sanctuary-like effect to area
    effect eSanct = EffectSanctuary(20);
    
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSanct, lLoc, IntToFloat(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), lLoc);
}
