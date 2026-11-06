// NW_S0_CrVenomTouch
// Venom Touch - Black Widow Caste Power
// Poison touch attack

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Damage: 1d6 per Jewel rank
    int nDamage = d6(nJewelScale);
    
    // DC: 10 + 1 per Jewel rank
    int nDC = 10 + nJewelScale;
    
    // Maximize
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nJewelScale;
    
    // Empower
    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage / 2);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    if (!gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;
    
    // Apply poison damage
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_POISON);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_L), oTarget);
    
    // Poison effect on target (ongoing)
    // Simplified - just apply damage once
}
