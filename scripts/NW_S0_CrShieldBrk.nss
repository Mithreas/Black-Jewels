// NW_S0_CrShieldBrk
// Shield Breaker - Warlord Caste Power
// Psychic strike that penetrates shields

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
    
    // Maximize
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nJewelScale;
    
    // Empower
    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage / 2);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
    
    if (!gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, OBJECT_SELF, oTarget)) return;
    
    // Apply force damage
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FORCE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
    
    // Shield damage is handled separately - double damage to shields
}
