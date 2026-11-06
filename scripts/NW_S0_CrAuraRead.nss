// NW_S0_CrAuraRead
// Aura Reading - Priestess Caste Power
// Perceive Jewel strength of target

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;

    if (GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Will save to resist
        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            // Display aura information
            object oHide = gsPCGetCreatureHide(oTarget);
            int nBirthright = GetLocalInt(oHide, "BIRTHRIGHT_JEWEL");
            int nRank = GetLocalInt(oHide, "RANK_JEWEL");
            
            string sMessage = "Aura Reading: ";
            if (nBirthright > 0)
                sMessage += "Birthright: " + crGetJewelName(nBirthright);
            if (nRank > 0)
                sMessage += ", Rank: " + crGetJewelName(nRank);
            
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "You sense a strong will blocking your examination.");
        }
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), OBJECT_SELF);
    }
}
