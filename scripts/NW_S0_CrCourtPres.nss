// NW_S0_CrCourtPres
// Courtly Presence - Queen Caste Power
// Diplomatic aura

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 3 minutes
    int nDuration = 180;
    
    // Bonuses: +2 + 1 per Jewel rank
    int nBonus = 2 + nJewelScale;

    if (GetIsObjectValid(oTarget) && oTarget == OBJECT_SELF)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Diplomacy bonus
        effect eDip = EffectSkillIncrease(SKILL_PERSUADE, nBonus);
        effect eGather = EffectSkillIncrease(SKILL_GATHER_INFORMATION, nBonus);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        effect eLink = EffectLinkEffects(eDip, eGather);
        eLink = EffectLinkEffects(eLink, eVis);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ENCHANTMENT), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eLink,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
