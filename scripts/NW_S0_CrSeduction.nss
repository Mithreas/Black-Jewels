// NW_S0_CrSeduction
// Seduction - Basic Craft
// Compel a target to view you favorably

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
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    // Will save
    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_AFFECTING))
    {
        // Charisma bonus to checks directed at caster
        effect eCha = EffectCharm();
        gsSPApplyEffect(
            oTarget,
            eCha,
            nSpell,
            nDuration);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oTarget);
    }
}
