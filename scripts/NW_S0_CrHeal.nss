// NW_S0_CrHeal
// Minor Healing - Basic Craft
// Channel psychic energy to heal wounds

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    // Jewel scaling: 1d6 + 1 per Jewel rank
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    int nHealing = d6(1) + nJewelScale;
    
    // Maximize metamagic
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nHealing = 6 + nJewelScale;
    
    // Empower metamagic (50% bonus)
    if (nMetaMagic == METAMAGIC_EMPOWER) nHealing = nHealing + (nHealing / 2);

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        effect eHeal = EffectHeal(nHealing);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oTarget);
    }
}
