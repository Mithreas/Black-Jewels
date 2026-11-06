// NW_S0_CrDreamWalk
// Dream Walker - Black Widow Caste Power
// Enter target's dreams

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
    
    // Range: 60 feet
    float fRange = FeetToMeters(60.0);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    // Check range
    if (GetDistanceBetween(OBJECT_SELF, oTarget) > fRange) return;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Will save to notice
    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_AFFECTING))
    {
        // Create ethereal-like effect
        effect eEthereal = EffectEthereal();
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ETHEREAL), OBJECT_SELF);
        
        gsSPApplyEffect(
            OBJECT_SELF,
            eEthereal,
            nSpell,
            SecondsToSeconds(nDuration));
        
        SendMessageToPC(OBJECT_SELF, "You enter " + GetName(oTarget) + "'s dreams.");
    }
}
