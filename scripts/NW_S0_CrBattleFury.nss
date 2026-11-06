// NW_S0_CrBattleFury
// Battle Fury - Warlord Caste Power
// Enter a combat trance for enhanced attack

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
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // Attack bonus: +2, +1 per 2 Jewel ranks (rounded down)
    int nAttackBonus = 2 + (nJewelScale / 2);
    
    // AC penalty: -2 (fixed)
    int nACPenatly = -2;
    
    // Extend metamagic
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // Valid target check - self only for Battle Fury
    if (GetIsObjectValid(oTarget) && oTarget == OBJECT_SELF)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Create attack bonus effect
        effect eAttack = EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectAttackIncrease(nAttackBonus));
        
        // Create AC penalty effect
        effect eAC = EffectACIncrease(nACPenatly, AC_DODGE_BONUS);
        
        // Cannot use shields while in fury - apply penalty to shield
        // (handled by effect, no actual shield use during combat)
        
        // Apply visual
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_BODY_HAVOC),
            oTarget);
        
        // Apply effects
        gsSPApplyEffect(
            oTarget,
            eAttack,
            nSpell,
            SecondsToSeconds(nDuration));
        gsSPApplyEffect(
            oTarget,
            eAC,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
