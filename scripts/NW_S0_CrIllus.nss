// NW_S0_CrIllus
// Minor Illusion - Basic Craft
// Create a minor visual illusion

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // Create a simple visual effect as illusion
    effect eIllus = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Apply illusion effect - in NWN this is represented by a visual effect
    // Real illusion mechanics would require additional scripting
    gsSPApplyEffect(
        oTarget,
        eIllus,
        nSpell,
        SecondsToSeconds(nDuration));
}
