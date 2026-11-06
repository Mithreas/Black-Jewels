// NW_S0_CrGrtrIllus
// Greater Illusion - Black Widow Caste Power
// Complex multi-sense illusion

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 3 minutes + 1 minute per Jewel rank
    int nDuration = 180 + (60 * nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    // Area: 10-foot cube per Jewel rank
    float fSize = FeetToMeters(10.0 * IntToFloat(nJewelScale));

    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Create invisibility-like effect as illusion placeholder
    // Full illusion would require more complex implementation
    effect eIllus = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eIllus, lLoc, IntToFloat(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ETHEREAL), lLoc);
}
