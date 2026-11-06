// NW_S0_CrMadness
// Madness - Black Widow Caste Power
// Psychic assault causing confusion

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 3 rounds + 1 round per Jewel rank
    int nDuration = 18 + (6 * nJewelScale); // 3 rounds in seconds = 18
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    if (!gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;
    
    // Will save
    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_AFFECTING))
    {
        // Confusion effect
        effect eConfuse = EffectConfused();
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BRAM_STUN), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eConfuse,
            nSpell,
            nDuration);
    }
}
