// NW_S0_CrShadowWalk
// Shadow Walking - Prince Caste Power
// Enhanced stealth

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
    
    // Bonus: +2
    int nBonus = 2;
    
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    if (GetIsObjectValid(oTarget) && oTarget == OBJECT_SELF)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Hide and Move Silently bonuses
        effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
        effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        effect eLink = EffectLinkEffects(eHide, eMove);
        eLink = EffectLinkEffects(eLink, eVis);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ETHEREAL), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eLink,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
