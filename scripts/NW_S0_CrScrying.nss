// NW_S0_CrScrying
// Scrying - Basic Craft (Jewel-gated)
// See through the veil of distance

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    // Jewel scaling
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Jewel requirement: Rose (4) or higher
    if (!crCheckJewelRequirement(OBJECT_SELF, 4, "Scrying")) return;
    
    // Duration: 3 minutes
    int nDuration = 180; // 3 minutes in seconds
    
    // Extend metamagic
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // Valid target check
    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Scrying effect - use see invisibility + true seeing combo
        // For now, apply a see invisibility effect
        effect eScry = EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectSeeInvisible());
        
        // DC based on Jewel rank
        int nDC = 10 + nJewelScale;
        
        // Will save to notice scrying
        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            // Target notices the scrying
            SendMessageToPC(oTarget, "You feel as though you are being watched.");
        }
        
        // Apply visual
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_MAGICAL_VISION),
            OBJECT_SELF);
        
        // Apply effect to caster (they can see through the scrying)
        gsSPApplyEffect(
            OBJECT_SELF,
            eScry,
            nSpell,
            nDuration);
    }
}
