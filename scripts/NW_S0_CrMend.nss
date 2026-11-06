// NW_S0_CrMend
// Mend - Healer Caste Power
// Advanced healing with temporary hit points

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
    
    // Healing: 1d8 + 1 per Jewel rank
    int nHealing = d8(1) + nJewelScale;
    
    // Maximize metamagic
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nHealing = 8 + nJewelScale;
    
    // Empower metamagic (50% bonus to healing)
    if (nMetaMagic == METAMAGIC_EMPOWER) nHealing = nHealing + (nHealing / 2);
    
    // Temporary hit points: 5 per Jewel rank for 3 minutes
    int nTempHP = 5 * nJewelScale;
    int nDuration = 180; // 3 minutes in seconds

    // Valid target check
    if (GetIsObjectValid(oTarget))
    {
        // Affect self only for healing
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Apply healing
        effect eHeal = EffectHeal(nHealing);
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            eHeal,
            oTarget);
        
        // Apply temporary hit points
        effect eTempHP = EffectTemporaryHitpoints(nTempHP);
        gsSPApplyEffect(
            oTarget,
            eTempHP,
            nSpell,
            nDuration);
        
        // Visual
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_HEALING_G),
            oTarget);
    }
}
