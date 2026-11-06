// NW_S0_CrEntrap
// Entrap - Black Widow Caste Power
// Bind target with psychic tendrils

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    if (!gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;
    
    // Reflex save
    if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    {
        // Entangled effect
        effect eEntangle = EffectEntangle();
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WEB), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eEntangle,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
