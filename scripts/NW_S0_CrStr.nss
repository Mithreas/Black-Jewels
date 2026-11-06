// NW_S0_CrStr
// Strengthen - Basic Craft
// Enhances physical capabilities

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
    
    // Base: +2 to STR and CON, +1 per 2 Jewel ranks (rounded down)
    int nStatBonus = 2 + (nJewelScale / 2);
    
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
        
        // Create strengthen effect
        effect eStrength = EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE),
                EffectEnhancementBonus(nStatBonus)));
        
        effect eCON = EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE),
                EffectEnhancementBonus(nStatBonus)));
        
        // Combine STR and CON bonuses
        eStrength = EffectLinkEffects(eStrength, EffectAbilityIncrease(ABILITY_STRENGTH, nStatBonus));
        eCON = EffectLinkEffects(eCON, EffectAbilityIncrease(ABILITY_CONSTITUTION, nStatBonus));
        
        // Apply visual
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_HEAD_ENCHANTMENT),
            oTarget);
        
        // Apply effects
        gsSPApplyEffect(
            oTarget,
            eStrength,
            nSpell,
            SecondsToSeconds(nDuration));
        gsSPApplyEffect(
            oTarget,
            eCON,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
