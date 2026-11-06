// NW_S0_CrSummon
// Summoning - Basic Craft (Jewel-gated: Opal 7+)
// Call a creature from the Realms

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Jewel requirement: Opal (7) or higher
    if (!crCheckJewelRequirement(OBJECT_SELF, 7, "Summoning")) return;
    
    // Duration: 3 minutes
    int nDuration = 180;
    
    // CR: 1/4 Jewel rank (min 1)
    int nCR = nJewelScale / 4;
    if (nCR < 1) nCR = 1;

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Create summon - creature type based on CR
    // This is a simplified version - full implementation would select appropriate creature
    effect eSummon = EffectSummonCreature("NW_SUMMON", VFX_IMP_SUMMON_CELESTIAL);
    
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), IntToFloat(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUMMON_CELESTIAL), GetSpellTargetLocation());
}
