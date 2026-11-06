// NW_S0_CrRestor
// Restoration - Healer Caste Power
// Reverse ability damage and drain

#include "inc_spells"
#include "inc_craft_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    
    int nJewelScale = crGetJewelScale(OBJECT_SELF);
    
    // Restore: 1d4 + 1 per Jewel rank to each ability
    int nRestore = d4(1) + nJewelScale;

    if (GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
            if (!gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;
        }
        
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
        
        // Restore each ability
        int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
        if (nStr < GetAbilityModifier(ABILITY_STRENGTH, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_STRENGTH, nRestore), oTarget);
        }
        
        int nDex = GetAbilityScore(oTarget, ABILITY_DEXTERITY);
        if (nDex < GetAbilityModifier(ABILITY_DEXTERITY, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_DEXTERITY, nRestore), oTarget);
        }
        
        int nCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
        if (nCon < GetAbilityModifier(ABILITY_CONSTITUTION, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_CONSTITUTION, nRestore), oTarget);
        }
        
        int nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
        if (nInt < GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nRestore), oTarget);
        }
        
        int nWis = GetAbilityScore(oTarget, ABILITY_WISDOM);
        if (nWis < GetAbilityModifier(ABILITY_WISDOM, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_WISDOM, nRestore), oTarget);
        }
        
        int nCha = GetAbilityScore(oTarget, ABILITY_CHARISMA);
        if (nCha < GetAbilityModifier(ABILITY_CHARISMA, oTarget) + 10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAbilityIncrease(ABILITY_CHARISMA, nRestore), oTarget);
        }
        
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
    }
}
