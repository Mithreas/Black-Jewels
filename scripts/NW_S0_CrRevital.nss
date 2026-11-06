// NW_S0_CrRevital
// Revitalize - Healer Caste Power
// Remove exhaustion/fatigue, grant bonuses

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
    
    // Bonus: +2
    int nBonus = 2;

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Remove exhausted/fatigued conditions
        effect eEff = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eEff))
        {
            if (GetEffectType(eEff) == EFFECT_TYPE_ABILITY_DECREASE)
            {
                if (GetEffectSubType(eEff) == SUBTYPE_EXTRAORDINARY)
                {
                    RemoveEffect(oTarget, eEff);
                }
            }
            eEff = GetNextEffect(oTarget);
        }
        
        // Apply bonus to Con checks and Fort saves
        effect eCon = EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonus);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        effect eLink = EffectLinkEffects(eCon, eVis);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eLink,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
