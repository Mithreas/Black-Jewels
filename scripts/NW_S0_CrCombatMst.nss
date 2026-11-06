// NW_S0_CrCombatMst
// Combat Mastery - Warlord Prince Caste Power
// Enhanced combat skills

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nMetaMagic   = AR_GetMetaMagicFeat();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Duration: 30 seconds + 6 seconds per Jewel rank
    int nDuration = 30 + (6 * nJewelScale);
    
    // Bonuses: +2, +1 per 2 Jewel ranks (rounded down)
    int nBonus = 2 + (nJewelScale / 2);
    
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    if (GetIsObjectValid(oTarget) && oTarget == OBJECT_SELF)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Attack bonus
        effect eAttack = EffectAttackIncrease(nBonus);
        // Damage bonus  
        effect eDamage = EffectDamageIncrease(nBonus);
        // Immunity to disarm (represented as bonus to resist)
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        
        effect eLink = EffectLinkEffects(eAttack, eDamage);
        eLink = EffectLinkEffects(eLink, eVis);
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BODY_HAVOC), oTarget);
        
        gsSPApplyEffect(
            oTarget,
            eLink,
            nSpell,
            SecondsToSeconds(nDuration));
    }
}
