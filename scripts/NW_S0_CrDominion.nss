// NW_S0_CrDominion
// Dominion - Queen Caste Power
// Dominate lower caste

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
    
    // Area: 30 feet + 5 feet per Jewel rank
    float fRadius = FeetToMeters(30.0 + (5.0 * IntToFloat(nJewelScale)));
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    // Dominate effect
    effect eDom = EffectDominated();
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    
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
                    eDom,
                    nSpell,
                    SecondsToSeconds(nDuration));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}
