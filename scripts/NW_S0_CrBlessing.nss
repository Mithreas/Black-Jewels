// NW_S0_CrBlessing
// Blessing - Priestess Caste Power
// Grant insight bonuses

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 3 minutes + 1 minute per Jewel rank
    int nDuration = 180 + (60 * nJewelScale);
    
    // Bonuses: +1 per Jewel rank
    int nBonus = nJewelScale;

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Saving throw and perception bonuses
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
        effect eSpot = EffectSkillIncrease(SKILL_SPOT, nBonus);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        effect eLink = EffectLinkEffects(eSave, eSpot);
        eLink = EffectLinkEffects(eLink, eVis);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ENCHANTMENT), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eLink,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
