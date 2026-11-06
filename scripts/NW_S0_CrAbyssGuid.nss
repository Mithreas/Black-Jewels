// NW_S0_CrAbyssGuid
// Abyssal Guidance - Priestess Caste Power
// Enhance target's Craft abilities

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
    
    // DC bonus: 1 per Jewel rank
    int nDCBonus = nJewelScale;
    
    // Spell resistance bonus: 1 per Jewel rank
    int nSRBonus = nJewelScale;

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Spell focus-like effect (implemented via visual)
        effect eBuff = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_MAGICAL), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eBuff,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
