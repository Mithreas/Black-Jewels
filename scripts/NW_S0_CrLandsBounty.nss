// NW_S0_CrLandsBounty
// Land's Bounty - Queen Caste Power
// Accelerate plant growth

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 1 hour
    int nDuration = 3600;
    
    // Area: 30 feet + 5 feet per Jewel rank
    float fRadius = FeetToMeters(30.0 + (5.0 * IntToFloat(nJewelScale)));

    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Growth effect - represented by nature visual
    effect eNature = EffectVisualEffect(VFX_IMP_PLANT_GROWTH);
    
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, lLoc);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_GROWTH), lLoc, IntToFloat(nDuration));
}
