// NW_S0_CrPresence
// Presence - Prince Caste Power
// Command attention, force drop from combat

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    // Area: 30 feet
    float fRadius = FeetToMeters(30.0);
    
    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    // Daze effect - targets drop from combat
    effect eDaze = EffectDazed();
    effect eVis = EffectVisualEffect(VFX_IMP_BRAM_STUN);
    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF && gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
        {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_AFFECTING))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                gsSPApplyEffect(
                    oTarget,
                    eDaze,
                    nSpell,
                    SecondsToSeconds(nDuration));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}
