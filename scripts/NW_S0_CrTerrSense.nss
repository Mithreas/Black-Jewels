// NW_S0_CrTerrSense
// Territorial Sense - Queen Caste Power
// Sense threats in territory

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 10 minutes
    int nDuration = 600;
    
    // Range: 100 feet + 20 feet per Jewel rank
    float fRadius = FeetToMeters(100.0 + (20.0 * IntToFloat(nJewelScale)));

    location lLoc = GetLocation(OBJECT_SELF);
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    
    // Sense creatures in area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    int nCount = 0;
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF && GetIsEnemy(oTarget, OBJECT_SELF))
        {
            nCount++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    if (nCount > 0)
    {
        SendMessageToPC(OBJECT_SELF, "You sense " + IntToString(nCount) + " threats in your territory.");
    }
    else
    {
        SendMessageToPC(OBJECT_SELF, "Your territory is clear of threats.");
    }
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), OBJECT_SELF);
}
