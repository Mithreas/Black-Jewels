// NW_S0_CrWarlordFry
// Fury of the Warlord - Warlord Prince Caste Power
// Area damage effect

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Damage: 2d6 per Jewel rank
    int nDamage = d6(2 * nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    // Area: 15 feet
    float fRadius = FeetToMeters(15.0);
    
    // Maximize
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 12 * nJewelScale;
    
    // Empower
    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage / 2);
    
    location lLoc = GetSpellTargetLocation();
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    // Apply to each target in area
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FORCE);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF && gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget))
        {
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
            else
            {
                // Half damage on save
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage / 2, DAMAGE_TYPE_FORCE), oTarget);
            }
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}
