#include "inc_flag"
#include "inc_iprop"
#include "inc_jewels"
#include "inc_text"
#include "inc_worship"
#include "inc_spell"
#include "inc_state"
#include "inc_strack"
#include "inc_pc"
#include "inc_spells"
#include "inc_class"
#include "inc_divination"
#include "inc_relations"
#include "x2_inc_switches"
#include "inc_wildmagic"
#include "inc_spells"
#include "inc_subdual"

int _GetIsSummonSpell(int nSpellId, int bUndead = 0, int bSwords = 0)
{
  switch (nSpellId)
  {
    // Summon spells and abilities
    // Excludes undead summoning (raising)
    case SPELL_SUMMON_CREATURE_I:
    case SPELL_SUMMON_CREATURE_II:
    case SPELL_SUMMON_CREATURE_III:
    case SPELL_SUMMON_CREATURE_IV:
    case SPELL_SUMMON_CREATURE_IX:
    case SPELL_SUMMON_CREATURE_V:
    case SPELL_SUMMON_CREATURE_VI:
    case SPELL_SUMMON_CREATURE_VII:
    case SPELL_SUMMON_CREATURE_VIII:
    case 303:
    case 304:
    case SPELL_SUMMON_SHADOW:
    case SPELL_SHADES_SUMMON_SHADOW:
    case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:
    case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:
    case 378:
    case 379:
    case SPELL_ELEMENTAL_SUMMONING_ITEM:
    case 564:
    case 701:
    case SPELL_PLANAR_ALLY:
    case 610: // BG Fiendish Servant
    case SPELL_EPIC_DRAGON_KNIGHT:
      return TRUE;
      break;
    // Planar binding might be cast at a creature.  If so, not a summon.
    case SPELL_GREATER_PLANAR_BINDING:
    case SPELL_LESSER_PLANAR_BINDING:
    case SPELL_PLANAR_BINDING:
      if (!GetIsObjectValid(GetSpellTargetObject()))
        return TRUE;
  }

  if (bUndead)
  {
    switch  (nSpellId)
    {
        case SPELL_ANIMATE_DEAD:
        case SPELL_CREATE_GREATER_UNDEAD:
        case SPELL_CREATE_UNDEAD:
		case 623: // PM abilities
		case 624: // PM abilities
		case 627: // PM abilities
        case SPELL_EPIC_MUMMY_DUST:
            return TRUE;
    }
  }

  if (bSwords)
  {
    switch (nSpellId)
    {
        case SPELL_MORDENKAINENS_SWORD:
        case SPELL_SHELGARNS_PERSISTENT_BLADE:
            return TRUE;
    }
  }

  return FALSE;
}

void main()
{
    int nSpell = GetSpellId();
	int nSchool = GetSpellSchool(nSpell);
    int bBypassAntimagic = GetLocalInt(OBJECT_SELF, "BypassAntimagic");

    DeleteLocalInt(OBJECT_SELF, "BypassAntimagic");

    int bIsMundaneAbility = GetIsItemMundane(GetSpellCastItem());

    if (GetIsDM(OBJECT_SELF))                return;
    if (GetIsDMPossessed(OBJECT_SELF))       return;

    UpdateCreatureSpellVariables(OBJECT_SELF);

    if(!CheckSpontaneousCasting())
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    //spelltracker override
    if (GetLocalInt(OBJECT_SELF, "GS_SPT_OVERRIDE"))
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    //area flag
    if (gsFLGetAreaFlag("OVERRIDE_MAGIC") && !bIsMundaneAbility && !bBypassAntimagic)
    {
        if (GetIsPC(OBJECT_SELF)) FloatingTextStringOnCreature(GS_T_16777445, OBJECT_SELF, FALSE);
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    if (! GetIsPC(OBJECT_SELF))              return;
    if (GetIsPossessedFamiliar(OBJECT_SELF)) return;

    object oHide = gsPCGetCreatureHide();
    object oTarget   = GetSpellTargetObject();
    int nHarmful     = Get2DAString("spells", "HostileSetting", nSpell) == "1";

    if(GetIsObjectValid(GetSpellCastItem()) && !gsIPDoUMDCheck(GetSpellCastItem(), OBJECT_SELF))
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }
	
    location lTarget = GetSpellTargetLocation();

    //::  ActionReplay - Apply Wild Magic if the area is affected by it (Logic in ar_FaerzressWildMagic)
    if(!bIsMundaneAbility && !(!GetIsObjectValid(GetSpellCastItem()) && GetIsShadowMage(OBJECT_SELF)))
    {
        ar_FaerzressWildMagic(OBJECT_SELF, oTarget, lTarget, nSpell, nHarmful);
    }

    if (gsFLGetAreaFlag("OVERRIDE_SUMMONS") && _GetIsSummonSpell(GetSpellId()) && !bIsMundaneAbility)
    {
      FloatingTextStringOnCreature("Your attempt to summon fails!" , OBJECT_SELF);
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
    }

    //set target of harmful spell to hostile
    if (GetIsObjectValid(oTarget))
    {
        if (nHarmful && nSpell != SPELL_CHARM_MONSTER &&
            nSpell != SPELL_CHARM_PERSON && nSpell != SPELL_CHARM_PERSON_OR_ANIMAL)
        {
          SetPCDislike(OBJECT_SELF, oTarget);

          if (oTarget != OBJECT_SELF && GetIsPC(OBJECT_SELF) && GetIsPC(oTarget))
          {
            miRERecordCombatHit(oTarget, OBJECT_SELF);

            // dunshine: always disable subdual mode when a harmful spell is cast on a PC
            gvd_SetSubdualMode(OBJECT_SELF, 0);
          }

        }
    }
    else
    {
        object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
        oTarget          = oCreature;

        if (nHarmful && nSpell != SPELL_CHARM_MONSTER &&
            nSpell != SPELL_CHARM_PERSON && nSpell != SPELL_CHARM_PERSON_OR_ANIMAL)
        {
            while (GetIsObjectValid(oCreature))
            {
                SetPCDislike(OBJECT_SELF, oCreature);

                if (oCreature != OBJECT_SELF && GetIsPC(OBJECT_SELF) && GetIsPC(oCreature))
                {
                  miRERecordCombatHit(oCreature, OBJECT_SELF);
                }

                oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
            }
        }
    }
	
	// Restore spell slots.
    if (! GetIsObjectValid(GetSpellCastItem()))
    {
          int nSpellLevel = StringToInt(Get2DAString("spells", "Innate", nSpell));
 
          // Metamagic
          switch (GetMetaMagicFeat())
          {
            case METAMAGIC_ANY:
            case METAMAGIC_NONE:
              nSpellLevel += 0;
              break;
            case METAMAGIC_EXTEND:
            case METAMAGIC_SILENT:
            case METAMAGIC_STILL:
              nSpellLevel += 1;
              break;
            case METAMAGIC_EMPOWER:
              nSpellLevel += 2;
              break;
            case METAMAGIC_MAXIMIZE:
              nSpellLevel += 3;
              break;
            case METAMAGIC_QUICKEN:
              nSpellLevel += 4;
              break;
          }

          // Reset spell slots.
          NWNX_Creature_SetRemainingSpellSlots(OBJECT_SELF,
                                 GetLastSpellCastClass(),
                                 nSpellLevel,
                                 NWNX_Creature_GetMaxSpellSlots(OBJECT_SELF, GetLastSpellCastClass(), nSpellLevel));

		// Craft powers are level 0 (basic Craft) or level 1 (all caste powers)
		// Base drain for using a power is 50 for Basic Craft and 100 for caste powers
		//    = 100 / (2 - nSpellLevel)
		// A stronger Jewel means you can use a lot more powers.  Divide the cost by
		// 1 + Jewel rank - so 1 for those without Jewels up to 14 for Black.  6 for
		// Summer Sky, 5 for Rose etc.  Add the character's positive Wisdom bonus.
		if (nSpellLevel < 2)
		{
			int nWisdom = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
			if (nWisdom < 0) nWisdom = 0;
			int nPsychicDrain = (100 / (2 - nSpellLevel)) / (1 + jGetJewelStrength(OBJECT_SELF) + nWisdom);
			gsSTDoCasterDamage(OBJECT_SELF, nPsychicDrain);
		}
		else
		{
			// Somehow someone is casting a higher level spell.  Shouldn't be possible
			// but avoid giving divide by 0 errors or adding psychic reserves.	
		}

    } else {
      // cast from item

    }

    // spell is being cast, so log it in the divination system.
    if (nSchool == SPELL_SCHOOL_NECROMANCY) 
    {
      miDVGivePoints(OBJECT_SELF, ELEMENT_DEATH, 3.0);
    }
	else if (nSchool == SPELL_SCHOOL_CONJURATION) // Conjuration
    {
      miDVGivePoints(OBJECT_SELF, ELEMENT_LIFE, 3.0);		
    }
	else if (nSchool == SPELL_SCHOOL_EVOCATION) // Evocation
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_FIRE, 3.0);
	}
	else if (nSchool == SPELL_SCHOOL_ENCHANTMENT) // Enchantment
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_EARTH, 3.0);
	}
	else if (nSchool == SPELL_SCHOOL_TRANSMUTATION) // Transmutation
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
	}
	else if (nSchool == SPELL_SCHOOL_ILLUSION) // Illusion
	{
	  miDVGivePoints(OBJECT_SELF, ELEMENT_AIR, 3.0);
	}
	else
	{
	  // School is Abjuration or Divination - no elemental alignment. 
	}

    //spell information
    gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
    gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
    gsSPSetSpellCallback();

    // Allow override of any spell script by setting a SPELL_OVERRIDE_X string on the creature
    // where X is the spell Id, and the string is the name of the script to be fired.
    if(GetSpellOverride())
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }
}
