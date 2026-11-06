// NW_S0_CrShield
// Weave Shield - Basic Craft
// Creates a protective psychic barrier

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    // Jewel scaling
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Base: +2 deflection, +1 per 2 Jewel ranks (rounded down)
    int nACBonus = 2 + (nJewelScale / 2);
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // Extend metamagic
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // Valid target check
    if (GetIsObjectValid(oTarget))
    {
        // Affect self only
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Create shield effect
        effect eShield = EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectACIncrease(nACBonus, AC_DEFLECTION_BONUS));
        
        // Apply visual
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_AC_BONUS),
            oTarget);
        
        // Apply effect
        gsSPApplyEffect(
            oTarget,
            eShield,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
