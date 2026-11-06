// NW_S0_CrTransform
// Major Transformation - Basic Craft (Jewel-gated: Green 8+)
// Transform into another shape

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Jewel requirement: Green (8) or higher
    if (!crCheckJewelRequirement(OBJECT_SELF, 8, "Major Transformation")) return;
    
    // Duration: 3 minutes
    int nDuration = 180;
    
    // Polymorph to a generic form - actual forms would be selected via sub-spells
    // CR/2 determines available forms
    int nCR = nJewelScale / 2;
    if (nCR < 1) nCR = 1;
    
    // Use appropriate polymorph based on available CR
    int nPolymorph = POLYMORPH_TYPE_GIANT_SPIDER; // default
    if (nCR >= 4) nPolymorph = POLYMORPH_TYPE_TROLL;
    else if (nCR >= 3) nPolymorph = POLYMORPH_TYPE_OGRE;
    else if (nCR >= 2) nPolymorph = POLYMORPH_TYPE_HILL_GIANT;
    
    effect ePoly = EffectPolymorph(nPolymorph, TRUE);
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    gsSPApplyEffect(
        OBJECT_SELF,
        ePoly,
        nSpell,
        SecondsToSeconds(nDuration));
}
