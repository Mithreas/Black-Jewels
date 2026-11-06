// NW_S0_CrCleanse
// Cleanse - Healer Caste Power
// Remove disease and poison

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // DC: 10 + 1 per Jewel rank for magical afflictions
    int nDC = 10 + nJewelScale;

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Remove diseases
        effect eDisease = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eDisease))
        {
            if (GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
            {
                // Magical diseases can be resisted
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
                {
                    RemoveEffect(oTarget, eDisease);
                }
            }
            eDisease = GetNextEffect(oTarget);
        }
        
        // Remove poisons
        effect ePoison = GetFirstEffect(oTarget);
        while (GetIsEffectValid(ePoison))
        {
            if (GetEffectType(ePoison) == EFFECT_TYPE_POISON)
            {
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                {
                    RemoveEffect(oTarget, ePoison);
                }
            }
            ePoison = GetNextEffect(oTarget);
        }
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), oTarget);
    }
}
