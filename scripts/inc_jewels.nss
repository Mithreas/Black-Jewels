// inc_jewels
// Library for utility functions around Jewel strength and power.
#include "inc_pc"

const int J_NONE       = 0;
const int J_WHITE      = 1;
const int J_YELLOW     = 2;
const int J_TIGEREYE   = 3;
const int J_ROSE       = 4;
const int J_SUMMERSKY  = 5;
const int J_PURPLEDUSK = 6;
const int J_OPAL       = 7;
const int J_GREEN      = 8;
const int J_SAPPHIRE   = 9;
const int J_RED        = 10;
const int J_GRAY       = 11;
const int J_EBONGRAY   = 12;
const int J_BLACK      = 13;

// Craft spell TLK IDs - Name = Base, Desc = Base + 1
const int CRS_NAME_BASE = 16777603;
const int CRS_DESC_BASE = 16777604;

int jGetBirthrightJewel (object oPC);
int jGetBirthrightJewelPower (object oPC);
void jSetBirthrightJewel (object oPC, int nJewel);

int jGetRankJewel (object oPC);
int jGetRankJewelPower (object oPC);
void jSetRankJewel (object oPC, int nJewel);

// Typically used to retrieve the PC's current Jewel rank - their Jewel of rank
// if they have one and their birthright if not.
int jGetJewelStrength (object oPC);
int jGetJewelPower (object oPC);

// Utility functions for managing shields
int jGetShieldStrength (object oTarget);
int jGetShieldPower (object oTarget);
void jShieldCharacter (object oTarget, int nJewelStrength, int nJewelPower);

// We use the Alignment field to record Jewel rank so it shows up 
// nicely on the character sheet. 
void jRefreshAlignment(object oPC);

// Call OnModuleLoad to override the text used for alignments and various other things.
void jOverrideTlks();

int jGetBirthrightJewel (object oPC)
{
	object oHide = gsPCGetCreatureHide(oPC);
	return (GetLocalInt(oHide, "BIRTHRIGHT_JEWEL"));
}

int jGetBirthrightJewelPower (object oPC)
{
	object oHide = gsPCGetCreatureHide(oPC);
	int nPower   = GetLocalInt(oHide, "BIRTHRIGHT_JEWEL_POWER");
	
	// Jewel power is a random strength between 1 and 100 to break 
	// ties of equal Jewel rank.  Assign the first time we need it
	// (but check that we have a Jewel first!). 
	if (!nPower && jGetBirthrightJewel(oPC))
	{
		nPower = Random(100) + 1;
		SetLocalInt(oHide, "BIRTHRIGHT_JEWEL_POWER", nPower);
	}
	
	return nPower;
}

void jSetBirthrightJewel (object oPC, int nJewel)
{
	SetLocalInt(gsPCGetCreatureHide(oPC), "BIRTHRIGHT_JEWEL", nJewel);
}

int jGetRankJewel (object oPC)
{
	object oHide = gsPCGetCreatureHide(oPC);
	return (GetLocalInt(oHide, "RANK_JEWEL"));
}

int jGetRankJewelPower (object oPC)
{
	object oHide = gsPCGetCreatureHide(oPC);
	int nPower   = GetLocalInt(oHide, "RANK_JEWEL_POWER");
	
	// Jewel power is a random strength between 1 and 100 to break 
	// ties of equal Jewel rank.  Assign the first time we need it
	// (but check that we have a Jewel first!). 
	if (!nPower && jGetRankJewel(oPC))
	{
		nPower = Random(100) + 1;
		SetLocalInt(oHide, "RANK_JEWEL_POWER", nPower);
	}
	
	return nPower;
}

void jSetRankJewel (object oPC, int nJewel)
{
	SetLocalInt(gsPCGetCreatureHide(oPC), "RANK_JEWEL", nJewel);
}

int jGetJewelStrength (object oPC)
{
	int nJewel   = jGetRankJewel(oPC);
	if (!nJewel) nJewel = jGetBirthrightJewel(oPC);
	return nJewel;
}

int jGetJewelPower (object oPC)
{
	int nPower = jGetRankJewelPower(oPC);
	if (!nPower) nPower = jGetBirthrightJewelPower(oPC);
	return nPower;
}

int jGetShieldStrength (object oTarget)
{
	return GetLocalInt(oTarget, "J_SHIELD_STRENGTH");
}

int jGetShieldPower (object oTarget)
{
	return GetLocalInt(oTarget, "J_SHIELD_POWER");
}

void jShieldCharacter (object oTarget, int nJewelStrength, int nJewelPower)
{
	// Handle VFX if any in the individual Craft power scripts.  But the effectiveness
	// of the shield needs to be stored in variables so belongs here.
	SetLocalInt(oTarget, "J_SHIELD_STRENGTH", nJewelStrength);
	SetLocalInt(oTarget, "J_SHIELD_POWER", nJewelPower);
}

void jRefreshAlignment(object oPC)
{
  // LG = White
  // LN = Yellow
  // LE = Tiger Eye
  // NG = Rose
  // NN = Summer Sky
  // NE = Purple Dusk
  // CG = Opal
  // CN = Green
  // CE = Sapphire or darker
  // yes that leaves nothing specific for red etc - we'll deal with that later :)
  int nJewelRank = jGetJewelStrength(oPC);
  if (!nJewelRank) return;
  
  AdjustAlignment(oPC, ALIGNMENT_LAWFUL, -100, FALSE);
  AdjustAlignment(oPC, ALIGNMENT_GOOD, -100, FALSE);
  
  //Law/Chaos
  switch (nJewelRank)
  {
    case 1:
	case 2:
	case 3:
	  AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 100, FALSE);
      break;
	case 4:
	case 5:
	case 6:
	  AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 50, FALSE);
      break;
	case 7:
	case 8:
	default:
	  // No adjustment
      break;
  }
  
  //Good/Evil
  switch (nJewelRank)
  {
    case 1:
	case 4:
	case 7:
	  AdjustAlignment(oPC, ALIGNMENT_GOOD, 100, FALSE);
      break;
	case 2:
	case 5:
	case 8:
	  AdjustAlignment(oPC, ALIGNMENT_GOOD, 50, FALSE);
      break;
	case 3:
	case 6:
	default:
	  // No adjustment.
      break;
  }

}

void jOverrideTlks()
{
  SetTlkOverride(112, "White");
  SetTlkOverride(113, "Yellow");
  SetTlkOverride(114, "Tiger Eye");
  SetTlkOverride(115, "Rose");
  SetTlkOverride(116, "Summer Sky");
  SetTlkOverride(117, "Purple Dusk");
  SetTlkOverride(118, "Opal");
  SetTlkOverride(119, "Green");
  SetTlkOverride(120, "Dark");
  SetTlkOverride(199, "Males can take the castes Warlord, Prince or Warlord Prince.  Males protect first, and serve and obey second.");
  SetTlkOverride(200, "Females can take the castes Witch, Healer, Priestess, Black Widow and Queen.  Queens rule the Blood, and Widows, Healers and Priestesses have specialised roles.");
  SetTlkOverride(447, "Unlike in most settings, gender matters in this one, determining the castes you can take.");
  
  SetTlkOverride(459, "Strength measures the muscle and physical power of your character.  This is especially useful in physical combat.");
  SetTlkOverride(460, "Dexterity measures agility, reflexes, and balance. This matters for various skills, for accuracy in ranged combat, and for avoiding damage.");
  SetTlkOverride(461, "Constitution represents the health and stamina of your character. High constitution increases the number of hit points a character has (affecting how much damage they can take), and this makes it important for everyone, but especially so for those intending to spend a lot of time in combat. If constitution ever increases, hit points increase retroactively as well.");
  SetTlkOverride(462, "Wisdom describes a character's willpower, common sense, perception, and intuition, whereas Intelligence represents the ability to analyze information. Wisdom is the primary attribute for using Craft powers; a character with high Wisdom will be able to use powers more often and more effectively.");
  SetTlkOverride(463, "Intelligence determines how well your character learns and reasons. It is important for any character who wants to have a strong assortment of skills, however increasing your Intelligence will not grant bonus skill points retroactively.");
  SetTlkOverride(478, "Charisma measures a character's force of personality, persuasiveness, ability to lead, and physical attractiveness. It represents actual personal strength, not merely how one is perceived by others in a social setting. A key attribute for Queens, but all characters benefit from having a high charisma when speaking with others in the world.");

  // Craft Spell Names (16777603-16777667, odd numbers)
  SetTlkOverride(16777603, "Weave Shield");
  SetTlkOverride(16777605, "Strengthen");
  SetTlkOverride(16777607, "Minor Healing");
  SetTlkOverride(16777609, "Minor Illusion");
  SetTlkOverride(16777611, "Seduction");
  SetTlkOverride(16777613, "Scrying");
  SetTlkOverride(16777615, "Summoning");
  SetTlkOverride(16777617, "Major Transformation");
  SetTlkOverride(16777619, "Battle Fury");
  SetTlkOverride(16777621, "Shield Breaker");
  SetTlkOverride(16777623, "Combat Mastery");
  SetTlkOverride(16777625, "Fury of the Warlord");
  SetTlkOverride(16777627, "Social Grace");
  SetTlkOverride(16777629, "Shadow Walking");
  SetTlkOverride(16777631, "Presence");
  SetTlkOverride(16777633, "Cleanse");
  SetTlkOverride(16777635, "Mend");
  SetTlkOverride(16777637, "Restoration");
  SetTlkOverride(16777639, "Revitalize");
  SetTlkOverride(16777641, "Abyssal Guidance");
  SetTlkOverride(16777643, "Sanctify");
  SetTlkOverride(16777645, "Blessing");
  SetTlkOverride(16777647, "Aura Reading");
  SetTlkOverride(16777649, "Entrap");
  SetTlkOverride(16777651, "Venom Touch");
  SetTlkOverride(16777653, "Dream Walker");
  SetTlkOverride(16777655, "Greater Illusion");
  SetTlkOverride(16777657, "Madness");
  SetTlkOverride(16777659, "Land's Bounty");
  SetTlkOverride(16777661, "Territorial Sense");
  SetTlkOverride(16777663, "Dominion");
  SetTlkOverride(16777665, "Courtly Presence");
  SetTlkOverride(16777667, "Weather Sense");

  // Craft Spell Descriptions (16777604-16777668, even numbers)
  SetTlkOverride(16777604, "Weave a protective barrier of psychic energy around yourself. This shield provides a +2 deflection bonus to AC for 30 seconds + 6 seconds per Jewel rank. The shield's effectiveness increases with your Jewel rank - the deflection bonus increases by +1 for every 2 Jewel ranks (rounded down). While the shield is active, incoming attacks must penetrate both your physical defenses and the psychic barrier. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.");
  SetTlkOverride(16777606, "Enhance your physical capabilities by channeling psychic energy through your body. You gain a +2 enhancement bonus to Strength and Constitution for 30 seconds + 6 seconds per Jewel rank. This enhancement allows you to carry greater loads, deal more damage in combat, and resist physical hardships. The enhancement's power scales with your Jewel rank - the bonus increases by +1 for every 2 Jewel ranks (rounded down). Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.");
  SetTlkOverride(16777608, "Channel psychic energy to knit wounds and restore vitality. This power heals 1d6 + 1 per Jewel rank. This power cannot heal lethal damage or restore ability scores. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.");
  SetTlkOverride(16777610, "Create a minor visual illusion within close range. The illusion appears in a 5-foot square area and can depict a silent, immobile image of your choice. Observers receive a Will save (DC 10 + 1 per Jewel rank) to recognize the illusion as false. The illusion is purely visual and cannot produce sound, smell, or tactile feedback. This power cannot affect creatures that cannot see. The illusion persists for 30 seconds + 6 seconds per Jewel rank. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.");
  SetTlkOverride(16777612, "Compel a target to view you favorably. The target gains a +2 bonus to all Charisma-based checks directed at you and a -2 penalty to attack rolls made against you for 3 minutes. Additionally, the target has a 25% chance (+5% per Jewel rank) to have their actions toward you randomly be helpful rather than neutral or hostile. The target receives a Will save (DC 10 + 1 per Jewel rank) to negate this effect. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777614, "[REQUIRES ROSE JEWEL (4) OR HIGHER] See through the veil of distance to observe a location or creature. You must have an object or person associated with the target (a possession, a piece of hair, blood, etc.) to scry upon them. Alternatively, you can scry upon a specific location you have previously visited. You can see and hear as if you were present at the remote location for 3 minutes. The target receives a Will save (DC 10 + 1 per Jewel rank) to notice the scrying attempt and can attempt to block it with appropriate wards. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777616, "[REQUIRES OPAL JEWEL (7) OR HIGHER] Call a creature from the Realms to serve you. Summon a creature with challenge rating equal to or less than 1/4 your Jewel rank (minimum 1). The summoned creature appears adjacent to you and serves you for 3 minutes. The creature fights your enemies and follows your commands. If killed, the creature cannot be summoned again for 24 hours. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777618, "[REQUIRES GREEN JEWEL (8) OR HIGHER] Transform your physical form into another shape. You can assume the form of any creature whose challenge rating is equal to or less than 1/2 your Jewel rank (minimum 1). You gain the natural attacks, abilities, and movement modes of the new form but retain your own mental faculties. You can remain in this form for 3 minutes. This transformation is not perfect - you retain your own hit points and are still vulnerable to effects that target your true form. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777620, "Enter a controlled combat trance that enhances your combat prowess. You gain a +2 morale bonus to attack rolls and a -2 penalty to Armor Class for 30 seconds + 6 seconds per Jewel rank. This fury channels your psychic energy directly into combat effectiveness, making you more deadly but less able to defend yourself. While in battle fury, you cannot use shields or defensive spells that require concentration. The attack bonus increases by +1 for every 2 Jewel ranks (rounded down). This power draws heavily upon your psychic energy and cannot be used while your Jewels are drained.");
  SetTlkOverride(16777622, "Unleash a focused psychic strike designed to pierce magical and physical shields. Make a melee touch attack that deals 1d6 force damage per Jewel rank. If the target has a shield bonus (from a shield item, spell, or effect), the shield takes double the damage that bypasses the shield's protection. This damage can reduce or eliminate the target's shield effectiveness more quickly than normal attacks. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777624, "Channel your psychic energy to elevate your combat skills beyond normal limits. You gain a +2 insight bonus to attack rolls, a +2 bonus to damage rolls, and immunity to being disarmed for 30 seconds + 6 seconds per Jewel rank. This power represents the pinnacle of Warlord Prince combat training, combining physical prowess with psychic enhancement. The attack and damage bonuses increase by +1 for every 2 Jewel ranks (rounded down). This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777626, "Unleash a devastating area effect that devastates all enemies within 15 feet. All creatures in the area take 2d6 force damage per Jewel rank (half on a successful Reflex save, DC 10 + 1 per Jewel rank). This fury represents the destructive potential of a Warlord Prince at full power, channeling psychic energy through physical devastation. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777628, "Enhance your social interactions of confidence and authority. You gain a by projecting an aura +2 competence bonus to Diplomacy and Intimidate checks for 60 seconds + 6 seconds per Jewel rank. When you display your Jewels during social interactions, this bonus increases to +4 (+1 per Jewel rank). This power helps Princes navigate courtly politics and negotiate with the subtleties required of their station. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777630, "Merge with shadows to move unseen. You gain a +2 competence bonus to Hide and Move Silently checks for 60 seconds + 6 seconds per Jewel rank. This power represents the Prince's mastery of subtle movement and social infiltration. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777632, "Command the attention of all within earshot. As a standard action, you can speak a single phrase that forces all creatures within 30 feet to make a Will save (DC 10 + 1 per Jewel rank) or be forced to drop from combat and pay attention to you for 30 seconds. Affected creatures stop fighting and cannot take any hostile actions. Creatures that succeed on their save are immune to this effect for 24 hours. This power is particularly effective for Princes conducting court business. The duration increases by +6 seconds per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777634, "Purify the body of afflicting forces. Remove one disease or poison affecting the target. If the target is affected by multiple diseases or poisons, this power removes the most severe. Cleanse can cure mundane diseases and poisons as well as magical ones (DC 10 + 1 per Jewel rank to overcome magical afflictions), though it cannot reverse permanent damage already caused. This power cannot remove curses or ongoing magical effects unless they are disease or poison-based. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777636, "Heal wounds with greater effectiveness than basic Craft healing. Restore 1d8 + 1 per Jewel rank hit points to the target. This healing is more potent than Minor Healing and can address more serious injuries. Mend also provides 5 temporary hit points per Jewel rank that last for 3 minutes. These temporary hit points absorb damage before the actual hit points. This power cannot heal lethal damage or restore ability scores. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777638, "Reverse the effects of ability damage and drain. Restore 1d4 + 1 per Jewel rank points to each ability score that has been damaged or drained. This power can heal ability damage from attacks, spells, or magical effects, though it cannot restore ability scores reduced to 0 or restore drained experience levels. Restoration works gradually, with the full effect occurring over 6 seconds. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777640, "Restore energy and remove exhaustion or fatigue. The target removes the exhausted or fatigued condition. Additionally, the target gains a +2 morale bonus to Constitution checks and Fortitude saves for 3 minutes + 1 minute per Jewel rank. This power helps characters recover from strenuous activities and continue performing at peak capacity. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777642, "Tap into the Abyss, the psychic domain where Jewelled characters descend to access their power, to enhance a target's Craft abilities. The target gains a +1 bonus to the DC of their Craft powers per Jewel rank and a +1 bonus to overcome spell resistance per Jewel rank for 3 minutes + 1 minute per Jewel rank. Additionally, the target's Craft powers cost 5 less psychic drain to use (minimum 1) per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777644, "Create a protected zone warded against hostile Craft. All Craft powers cast within a 20-foot radius gain a +1 bonus to their DC per Jewel rank, and hostile Craft powers cast by enemies within the area suffer a -1 penalty to their DC per Jewel rank for 3 minutes. Additionally, any creature attempting to scry on a location within the sanctified area must make a Will save (DC 10 + 1 per Jewel rank) or have their scrying attempt fail. This power represents the Priestess's authority over the Abyss. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777646, "Grant a target insight into their immediate future. The target gains a +1 insight bonus to all saving throws per Jewel rank and a +1 perception bonus per Jewel rank for 3 minutes + 1 minute per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777648, "Perceive the Jewel strength and Craft potential of another creature. As a standard action, you can examine a target within 30 feet and determine their Birthright Jewel rank (if any), their Rank Jewel rank (if awakened), and their current psychic strength. You also learn whether they have any active Craft effects and whether they are Blood. A successful Will save (DC 10 + 1 per Jewel rank) by the target negates this effect. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777650, "Summon psychic tendrils that bind the target. The target must make a Reflex save (DC 10 + 1 per Jewel rank) or be entangled for 30 seconds + 6 seconds per Jewel rank. An entangled creature cannot move from their position, though they can still attack and cast spells. Creatures that succeed on their save are immune to this effect for 24 hours. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777652, "Channel poison through a melee touch attack. Your touch attack deals 1d6 poison damage per Jewel rank that bypasses resistance. Additionally, the target must make a Fortitude save (DC 10 + 1 per Jewel rank) or suffer 1d4 poison damage per round for 3 rounds. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777654, "Enter the dreams of a sleeping target within range. You can communicate telepathically with the target for 3 minutes. The target must be within 60 feet and must be sleeping (not just resting). The target receives a Will save (DC 10 + 1 per Jewel rank) to resist contact. While in the dream, you are invisible and inaudible to the physical world. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777656, "Create a complex multi-sense illusion within long range. The illusion can occupy up to a 10-foot cube per Jewel rank and includes visual, auditory, olfactory, and thermal components. Creatures can interact with the illusion physically. Creatures receive a Will save (DC 10 + 1 per Jewel rank) to recognize the illusion as false. This illusion persists for 3 minutes + 1 minute per Jewel rank and does not require concentration. The illusion appears as a copy of the caster by default. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777658, "Unleash a psychic assault that destabilizes the target's mind. The target must make a Will save (DC 10 + 1 per Jewel rank) or become confused for 3 rounds + 1 round per Jewel rank. A confused creature randomly attacks friends, is unable to distinguish enemies from allies, and cannot take actions reliably. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777660, "Accelerate the growth of plants and crops in a 30-foot radius. All plants within the area grow at 10 times normal speed for 1 hour. This can cause instant maturation of crops, rapid healing of blighted land, or accelerated growth of newly planted seeds. Additionally, any creature with the Land domain or plant-related abilities within the area gains a +2 bonus to their powers. The area increases by +5 feet per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777662, "Extend your awareness across your territory. You become aware of all creatures within 100 feet that pose a threat to you or your holdings. This awareness includes the location, type, and number of threats but not detailed information about them. You also sense any changes to your territory - such as unauthorized entry, building construction, or magical scrying attempts. This power requires you to have an established territory and does not create one if you have none. The range increases by +20 feet per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777664, "Assert your royal authority over those of lesser standing. All creatures of lower caste within 30 feet must make a Will save (DC 10 + 1 per Jewel rank) or become dominated for 30 seconds. A dominated creature must obey your verbal commands and cannot take actions you have not authorized. Queens are unaffected by this power. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. The range increases by +5 feet per Jewel rank and duration by +6 seconds per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777666, "Project an aura of authority that enhances diplomatic outcomes. You gain a +2 bonus to all Diplomacy checks and a +2 bonus to Gather Information checks for 3 minutes. Additionally, when you enter a negotiation or diplomatic situation, the first impression modifier is increased by +2. The bonuses increase by +1 per Jewel rank. This power cannot be used while your Jewels are drained.");
  SetTlkOverride(16777668, "Attune yourself to the weather patterns of your land. You can predict the weather for the next 24 hours with perfect accuracy. Additionally, you can attempt to influence the weather within 5 miles. You can cause it to rain, stop rain, reduce visibility with fog, or cause winds to increase or decrease. This influence is subtle and takes 1 hour to take effect. The prediction accuracy and influence range increase with your Jewel rank (prediction increases by +6 hours per Jewel rank, influence range increases by +1 mile per Jewel rank). This power cannot be used while your Jewels are drained.");
}