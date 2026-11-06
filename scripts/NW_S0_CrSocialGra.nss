// NW_S0_CrSocialGra
// Social Grace - Prince Caste Power
// Enhanced social interactions

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 60 seconds + 6 seconds per Jewel rank
    int nDuration = 60 + (6 * nJewelScale);
    
    // Bonus: +2, +1 per Jewel rank when displaying Jewels
    int nBonus = 2 + nJewelScale;
    
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    if (GetIsObjectValid(oTarget) && oTarget == OBJECT_SELF)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Skill bonuses handled externally - apply generic buff effect
        effect eBuff = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ENCHANTMENT), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eBuff,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
