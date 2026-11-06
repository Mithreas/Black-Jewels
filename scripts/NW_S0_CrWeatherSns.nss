// NW_S0_CrWeatherSns
// Weather Sense - Queen Caste Power
// Predict and influence weather

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Prediction: 24 hours + 6 hours per Jewel rank
    int nPredict = 24 + (6 * nJewelScale);
    
    // Influence range: 5 miles + 1 mile per Jewel rank
    int nRange = 5 + nJewelScale;

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Weather prediction - simplified
    SendMessageToPC(OBJECT_SELF, "You sense the weather patterns. Current prediction: Clear skies for the next " + IntToString(nPredict) + " hours.");
    SendMessageToPC(OBJECT_SELF, "Your influence over weather extends to " + IntToString(nRange) + " miles.");
    
    // Influence ability note - would require additional mechanics
    SendMessageToPC(OBJECT_SELF, "You can subtly influence weather within your range. Changes take effect over 1 hour.");
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AURA), OBJECT_SELF);
}
