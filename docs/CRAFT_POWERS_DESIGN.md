# Black Jewels Craft Powers Design Document

## Overview

This document outlines the implementation of **Craft powers** - the magical abilities of the Blood in the Black Jewels setting - for the NWN module.

## TLK String Reference IDs

**Reserved Range:** 16777603 - 16777668 (33 spells × 2 = 66 IDs)

| ID | Type | Spell |
|----|------|-------|
| 16777603 | Name | Weave Shield |
| 16777604 | Desc | Weave Shield |
| 16777605 | Name | Strengthen |
| 16777606 | Desc | Strengthen |
| 16777607 | Name | Minor Healing |
| 16777608 | Desc | Minor Healing |
| 16777609 | Name | Minor Illusion |
| 16777610 | Desc | Minor Illusion |
| 16777611 | Name | Seduction |
| 16777612 | Desc | Seduction |
| 16777613 | Name | Scrying |
| 16777614 | Desc | Scrying |
| 16777615 | Name | Summoning |
| 16777616 | Desc | Summoning |
| 16777617 | Name | Major Transformation |
| 16777618 | Desc | Major Transformation |
| 16777619 | Name | Battle Fury |
| 16777620 | Desc | Battle Fury |
| 16777621 | Name | Shield Breaker |
| 16777622 | Desc | Shield Breaker |
| 16777623 | Name | Combat Mastery |
| 16777624 | Desc | Combat Mastery |
| 16777625 | Name | Fury of the Warlord |
| 16777626 | Desc | Fury of the Warlord |
| 16777627 | Name | Social Grace |
| 16777628 | Desc | Social Grace |
| 16777629 | Name | Shadow Walking |
| 16777630 | Desc | Shadow Walking |
| 16777631 | Name | Presence |
| 16777632 | Desc | Presence |
| 16777633 | Name | Cleanse |
| 16777634 | Desc | Cleanse |
| 16777635 | Name | Mend |
| 16777636 | Desc | Mend |
| 16777637 | Name | Restoration |
| 16777638 | Desc | Restoration |
| 16777639 | Name | Revitalize |
| 16777640 | Desc | Revitalize |
| 16777641 | Name | Abyssal Guidance |
| 16777642 | Desc | Abyssal Guidance |
| 16777643 | Name | Sanctify |
| 16777644 | Desc | Sanctify |
| 16777645 | Name | Blessing |
| 16777646 | Desc | Blessing |
| 16777647 | Name | Aura Reading |
| 16777648 | Desc | Aura Reading |
| 16777649 | Name | Entrap |
| 16777650 | Desc | Entrap |
| 16777651 | Name | Venom Touch |
| 16777652 | Desc | Venom Touch |
| 16777653 | Name | Dream Walker |
| 16777654 | Desc | Dream Walker |
| 16777655 | Name | Greater Illusion |
| 16777656 | Desc | Greater Illusion |
| 16777657 | Name | Madness |
| 16777658 | Desc | Madness |
| 16777659 | Name | Land's Bounty |
| 16777660 | Desc | Land's Bounty |
| 16777661 | Name | Territorial Sense |
| 16777662 | Desc | Territorial Sense |
| 16777663 | Name | Dominion |
| 16777664 | Desc | Dominion |
| 16777665 | Name | Courtly Presence |
| 16777666 | Desc | Courtly Presence |
| 16777667 | Name | Weather Sense |
| 16777668 | Desc | Weather Sense |

---

## Existing Foundation

### Jewel System (`inc_jewels.nss`)
- 13 Jewel strengths: White (1) → Yellow (2) → Tiger Eye (3) → Rose (4) → Summer Sky (5) → Purple Dusk (6) → Opal (7) → Green (8) → Sapphire (9) → Red (10) → Gray (11) → Ebony Gray (12) → Black (13)
- Birthright Jewel (fixed at character creation)
- Rank Jewel (earned through play)
- Wisdom is the primary attribute for using Craft powers

### Classes
- **Base Classes**: Blood Male, Blood Female
- **Male Caste Prestige**: Warlord, Prince, Warlord Prince
- **Female Caste Prestige**: Witch, Healer, Priestess, Black Widow, Queen

### Existing Craft Mechanics
- Spells marked as level 0 (Basic Craft) or level 1 (Caste powers) apply psychic drain
- Base drain: 50 for Basic Craft, 100 for Caste powers
- Drain modified by: `100 / (2 - spellLevel) / (1 + JewelStrength + WisdomMod)`
- Shield mechanics exist via `jShieldCharacter()`

---

## Craft Powers by Tier

### Tier 1: Basic Craft (All Blood)
Available to any character with a Jewel - Blood Male, Blood Female, and all Caste classes get Basic Craft only.

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 1 | **Weave Shield** | 16777603 | 16777604 | 0 |
| 2 | **Strengthen** | 16777605 | 16777606 | 0 |
| 3 | **Minor Healing** | 16777607 | 16777608 | 0 |
| 4 | **Minor Illusion** | 16777609 | 16777610 | 0 |
| 5 | **Seduction** | 16777611 | 16777612 | 0 |
| 6 | **Scrying** | 16777613 | 16777614 | 0 |
| 7 | **Summoning** | 16777615 | 16777616 | 0 |
| 8 | **Major Transformation** | 16777617 | 16777618 | 0 |

---

### Tier 2: Caste-Specific Powers

#### Warlord & Warlord Prince
Warlord Prince gets enhanced combat powers; Warlord has basic versions.

| # | Power | TLK Name | TLK Desc | Spell Lvl | Access |
|---|-------|----------|----------|-----------|--------|
| 9 | **Battle Fury** | 16777619 | 16777620 | 1 | Warlord |
| 10 | **Shield Breaker** | 16777621 | 16777622 | 1 | Warlord |
| 11 | **Combat Mastery** | 16777623 | 16777624 | 1 | Warlord Prince |
| 12 | **Fury of the Warlord** | 16777625 | 16777626 | 1 | Warlord Prince |

#### Prince

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 13 | **Social Grace** | 16777627 | 16777628 | 1 |
| 14 | **Shadow Walking** | 16777629 | 16777630 | 1 |
| 15 | **Presence** | 16777631 | 16777632 | 1 |

#### Healer

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 16 | **Cleanse** | 16777633 | 16777634 | 1 |
| 17 | **Mend** | 16777635 | 16777636 | 1 |
| 18 | **Restoration** | 16777637 | 16777638 | 1 |
| 19 | **Revitalize** | 16777639 | 16777640 | 1 |

#### Priestess

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 20 | **Abyssal Guidance** | 16777641 | 16777642 | 1 |
| 21 | **Sanctify** | 16777643 | 16777644 | 1 |
| 22 | **Blessing** | 16777645 | 16777646 | 1 |
| 23 | **Aura Reading** | 16777647 | 16777648 | 1 |

#### Black Widow

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 24 | **Entrap** | 16777649 | 16777650 | 1 |
| 25 | **Venom Touch** | 16777651 | 16777652 | 1 |
| 26 | **Dream Walker** | 16777653 | 16777654 | 1 |
| 27 | **Greater Illusion** | 16777655 | 16777656 | 1 |
| 28 | **Madness** | 16777657 | 16777658 | 1 |

#### Queen

| # | Power | TLK Name | TLK Desc | Spell Lvl |
|---|-------|----------|----------|-----------|
| 29 | **Land's Bounty** | 16777659 | 16777660 | 1 |
| 30 | **Territorial Sense** | 16777661 | 16777662 | 1 |
 **Dominion**| 31 | | 16777663 | 16777664 | 1 |
| 32 | **Courtly Presence** | 16777665 | 16777666 | 1 |
| 33 | **Weather Sense** | 16777667 | 16777668 | 1 |

---

## Detailed Spell Descriptions

### Basic Craft (Tier 1)

**Weave Shield** (16777603-16777604)
- **Name:** Weave Shield
- **Description:** Weave a protective barrier of psychic energy around yourself. This shield provides a +2 deflection bonus to AC for 30 seconds + 6 seconds per Jewel rank. The shield's effectiveness increases with your Jewel rank - the deflection bonus increases by +1 for every 2 Jewel ranks (rounded down). While the shield is active, incoming attacks must penetrate both your physical defenses and the psychic barrier. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.

**Strengthen** (16777605-16777606)
- **Name:** Strengthen
- **Description:** Enhance your physical capabilities by channeling psychic energy through your body. You gain a +2 enhancement bonus to Strength and Constitution for 30 seconds + 6 seconds per Jewel rank. This enhancement allows you to carry greater loads, deal more damage in combat, and resist physical hardships. The enhancement's power scales with your Jewel rank - the bonus increases by +1 for every 2 Jewel ranks (rounded down). Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.

**Minor Healing** (16777607-16777608)
- **Name:** Minor Healing
- **Description:** Channel psychic energy to knit wounds and restore vitality. This power heals 1d6 + 1 per Jewel rank. This power cannot heal lethal damage or restore ability scores. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.

**Minor Illusion** (16777609-16777610)
- **Name:** Minor Illusion
- **Description:** Create a minor visual illusion within close range. The illusion appears in a 5-foot square area and can depict a silent, immobile image of your choice. Observers receive a Will save (DC 10 + 1 per Jewel rank) to recognize the illusion as false. The illusion is purely visual and cannot produce sound, smell, or tactile feedback. This power cannot affect creatures that cannot see. The illusion persists for 30 seconds + 6 seconds per Jewel rank. Using this power draws upon your psychic energy and cannot be used while your Jewels are drained.

**Seduction** (16777611-16777612)
- **Name:** Seduction
- **Description:** Compel a target to view you favorably. The target gains a +2 bonus to all Charisma-based checks directed at you and a -2 penalty to attack rolls made against you for 3 minutes. Additionally, the target has a 25% chance ( +5% per Jewel rank) to have their actions toward you randomly be helpful rather than neutral or hostile. The target receives a Will save (DC 10 + 1 per Jewel rank) to negate this effect. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. This power cannot be used while your Jewels are drained.

**Scrying** (16777613-16777614)
- **Name:** Scrying
- **Description:** [REQUIRES ROSE JEWEL (4) OR HIGHER] See through the veil of distance to observe a location or creature. You must have an object or person associated with the target (a possession, a piece of hair, blood, etc.) to scry upon them. Alternatively, you can scry upon a specific location you have previously visited. You can see and hear as if you were present at the remote location for 3 minutes. The target receives a Will save (DC 10 + 1 per Jewel rank) to notice the scrying attempt and can attempt to block it with appropriate wards. This power cannot be used while your Jewels are drained.

**Summoning** (16777615-16777616)
- **Name:** Summoning
- **Description:** [REQUIRES OPAL JEWEL (7) OR HIGHER] Call a creature from the Realms to serve you. Summon a creature with challenge rating equal to or less than 1/4 your Jewel rank (minimum 1). The summoned creature appears adjacent to you and serves you for 3 minutes. The creature fights your enemies and follows your commands. If killed, the creature cannot be summoned again for 24 hours. This power cannot be used while your Jewels are drained.

**Major Transformation** (16777617-16777618)
- **Name:** Major Transformation
- **Description:** [REQUIRES GREEN JEWEL (8) OR HIGHER] Transform your physical form into another shape. You can assume the form of any creature whose challenge rating is equal to or less than 1/2 your Jewel rank (minimum 1). You gain the natural attacks, abilities, and movement modes of the new form but retain your own mental faculties. You can remain in this form for 3 minutes. This transformation is not perfect - you retain your own hit points and are still vulnerable to effects that target your true form. This power cannot be used while your Jewels are drained.

---

### Caste Powers (Tier 2)

#### Warlord Powers

**Battle Fury** (16777619-16777620)
- **Name:** Battle Fury
- **Description:** Enter a controlled combat trance that enhances your combat prowess. You gain a +2 morale bonus to attack rolls and a -2 penalty to Armor Class for 30 seconds + 6 seconds per Jewel rank. This fury channels your psychic energy directly into combat effectiveness, making you more deadly but less able to defend yourself. While in battle fury, you cannot use shields or defensive spells that require concentration. The attack bonus increases by +1 for every 2 Jewel ranks (rounded down). This power draws heavily upon your psychic energy and cannot be used while your Jewels are drained.

**Shield Breaker** (16777621-16777622)
- **Name:** Shield Breaker
- **Description:** Unleash a focused psychic strike designed to pierce magical and physical shields. Make a melee touch attack that deals 1d6 force damage per Jewel rank. If the target has a shield bonus (from a shield item, spell, or effect), the shield takes double the damage that bypasses the shield's protection. This damage can reduce or eliminate the target's shield effectiveness more quickly than normal attacks. This power cannot be used while your Jewels are drained.

#### Warlord Prince Powers

**Combat Mastery** (16777623-16777624)
- **Name:** Combat Mastery
- **Description:** Channel your psychic energy to elevate your combat skills beyond normal limits. You gain a +2 insight bonus to attack rolls, a +2 bonus to damage rolls, and immunity to being disarmed for 30 seconds + 6 seconds per Jewel rank. This power represents the pinnacle of Warlord Prince combat training, combining physical prowess with psychic enhancement. The attack and damage bonuses increase by +1 for every 2 Jewel ranks (rounded down). This power cannot be used while your Jewels are drained.

**Fury of the Warlord** (16777625-16777626)
- **Name:** Fury of the Warlord
- **Description:** Unleash a devastating area effect that devastates all enemies within 15 feet. All creatures in the area take 2d6 force damage per Jewel rank (half on a successful Reflex save, DC 10 + 1 per Jewel rank). This fury represents the destructive potential of a Warlord Prince at full power, channeling psychic energy through physical devastation. This power cannot be used while your Jewels are drained.

#### Prince Powers

**Social Grace** (16777627-16777628)
- **Name:** Social Grace
- **Description:** Enhance your social interactions by projecting an aura of confidence and authority. You gain a +2 competence bonus to Diplomacy and Intimidate checks for 60 seconds + 6 seconds per Jewel rank. When you display your Jewels during social interactions, this bonus increases to +4 (+1 per Jewel rank). This power helps Princes navigate courtly politics and negotiate with the subtleties required of their station. This power cannot be used while your Jewels are drained.

**Shadow Walking** (16777629-16777630)
- **Name:** Shadow Walking
- **Description:** Merge with shadows to move unseen. You gain a +2 competence bonus to Hide and Move Silently checks for 60 seconds + 6 seconds per Jewel rank. This power represents the Prince's mastery of subtle movement and social infiltration. This power cannot be used while your Jewels are drained.

**Presence** (16777631-16777632)
- **Name:** Presence
- **Description:** Command the attention of all within earshot. As a standard action, you can speak a single phrase that forces all creatures within 30 feet to make a Will save (DC 10 + 1 per Jewel rank) or be forced to drop from combat and pay attention to you for 30 seconds. Affected creatures stop fighting and cannot take any hostile actions. Creatures that succeed on their save are immune to this effect for 24 hours. This power is particularly effective for Princes conducting court business. The duration increases by +6 seconds per Jewel rank. This power cannot be used while your Jewels are drained.

#### Healer Powers

**Cleanse** (16777633-16777634)
- **Name:** Cleanse
- **Description:** Purify the body of afflicting forces. Remove one disease or poison affecting the target. If the target is affected by multiple diseases or poisons, this power removes the most severe. Cleanse can cure mundane diseases and poisons as well as magical ones (DC 10 + 1 per Jewel rank to overcome magical afflictions), though it cannot reverse permanent damage already caused. This power cannot remove curses or ongoing magical effects unless they are disease or poison-based. This power cannot be used while your Jewels are drained.

**Mend** (16777635-16777636)
- **Name:** Mend
- **Description:** Heal wounds with greater effectiveness than basic Craft healing. Restore 1d8 + 1 per Jewel rank hit points to the target. This healing is more potent than Minor Healing and can address more serious injuries. Mend also provides 5 temporary hit points per Jewel rank that last for 3 minutes. These temporary hit points absorb damage before the actual hit points. This power cannot heal lethal damage or restore ability scores. This power cannot be used while your Jewels are drained.

**Restoration** (16777637-16777638)
- **Name:** Restoration
- **Description:** Reverse the effects of ability damage and drain. Restore 1d4 + 1 per Jewel rank points to each ability score that has been damaged or drained. This power can heal ability damage from attacks, spells, or magical effects, though it cannot restore ability scores reduced to 0 or restore drained experience levels. Restoration works gradually, with the full effect occurring over 6 seconds. This power cannot be used while your Jewels are drained.

**Revitalize** (16777639-16777640)
- **Name:** Revitalize
- **Description:** Restore energy and remove exhaustion or fatigue. The target removes the exhausted or fatigued condition. Additionally, the target gains a +2 morale bonus to Constitution checks and Fortitude saves for 3 minutes + 1 minute per Jewel rank. This power helps characters recover from strenuous activities and continue performing at peak capacity. This power cannot be used while your Jewels are drained.

#### Priestess Powers

**Abyssal Guidance** (16777641-16777642)
- **Name:** Abyssal Guidance
- **Description:** Tap into the Abyss, the psychic domain where Jewelled characters descend to access their power, to enhance a target's Craft abilities. The target gains a +1 bonus to the DC of their Craft powers per Jewel rank and a +1 bonus to overcome spell resistance per Jewel rank for 3 minutes + 1 minute per Jewel rank. Additionally, the target's Craft powers cost 5 less psychic drain to use (minimum 1) per Jewel rank. This power cannot be used while your Jewels are drained.

**Sanctify** (16777643-16777644)
- **Name:** Sanctify
- **Description:** Create a protected zone warded against hostile Craft. All Craft powers cast within a 20-foot radius gain a +1 bonus to their DC per Jewel rank, and hostile Craft powers cast by enemies within the area suffer a -1 penalty to their DC per Jewel rank for 3 minutes. Additionally, any creature attempting to scry on a location within the sanctified area must make a Will save (DC 10 + 1 per Jewel rank) or have their scrying attempt fail. This power represents the Priestess's authority over the Abyss. This power cannot be used while your Jewels are drained.

**Blessing** (16777645-16777646)
- **Name:** Blessing
- **Description:** Grant a target insight into their immediate future. The target gains a +1 insight bonus to all saving throws per Jewel rank and a +1 perception bonus per Jewel rank for 3 minutes + 1 minute per Jewel rank. This power cannot be used while your Jewels are drained.

**Aura Reading** (16777647-16777648)
- **Name:** Aura Reading
- **Description:** Perceive the Jewel strength and Craft potential of another creature. As a standard action, you can examine a target within 30 feet and determine their Birthright Jewel rank (if any), their Rank Jewel rank (if awakened), and their current psychic strength. You also learn whether they have any active Craft effects and whether they are Blood. A successful Will save (DC 10 + 1 per Jewel rank) by the target negates this effect. This power cannot be used while your Jewels are drained.

#### Black Widow Powers

**Entrap** (16777649-16777650)
- **Name:** Entrap
- **Description:** Summon psychic tendrils that bind the target. The target must make a Reflex save (DC 10 + 1 per Jewel rank) or be entangled for 30 seconds + 6 seconds per Jewel rank. An entangled creature cannot move from their position, though they can still attack and cast spells. Creatures that succeed on their save are immune to this effect for 24 hours. This power cannot be used while your Jewels are drained.

**Venom Touch** (16777651-16777652)
- **Name:** Venom Touch
- **Description:** Channel poison through a melee touch attack. Your touch attack deals 1d6 poison damage per Jewel rank that bypasses resistance. Additionally, the target must make a Fortitude save (DC 10 + 1 per Jewel rank) or suffer 1d4 poison damage per round for 3 rounds. This power cannot be used while your Jewels are drained.

**Dream Walker** (16777653-16777654)
- **Name:** Dream Walker
- **Description:** Enter the dreams of a sleeping target within range. You can communicate telepathically with the target for 3 minutes. The target must be within 60 feet and must be sleeping (not just resting). The target receives a Will save (DC 10 + 1 per Jewel rank) to resist contact. While in the dream, you are invisible and inaudible to the physical world. This power cannot be used while your Jewels are drained.

**Greater Illusion** (16777655-16777656)
- **Name:** Greater Illusion
- **Description:** Create a complex multi-sense illusion within long range. The illusion can occupy up to a 10-foot cube per Jewel rank and includes visual, auditory, olfactory, and thermal components. Creatures can interact with the illusion physically. Creatures receive a Will save (DC 10 + 1 per Jewel rank) to recognize the illusion as false. This illusion persists for 3 minutes + 1 minute per Jewel rank and does not require concentration. The illusion appears as a copy of the caster by default. This power cannot be used while your Jewels are drained.

**Madness** (16777657-16777658)
- **Name:** Madness
- **Description:** Unleash a psychic assault that destabilizes the target's mind. The target must make a Will save (DC 10 + 1 per Jewel rank) or become confused for 3 rounds + 1 round per Jewel rank. A confused creature randomly attacks friends, is unable to distinguish enemies from allies, and cannot take actions reliably. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. This power cannot be used while your Jewels are drained.

#### Queen Powers

**Land's Bounty** (16777659-16777660)
- **Name:** Land's Bounty
- **Description:** Accelerate the growth of plants and crops in a 30-foot radius. All plants within the area grow at 10 times normal speed for 1 hour. This can cause instant maturation of crops, rapid healing of blighted land, or accelerated growth of newly planted seeds. Additionally, any creature with the Land domain or plant-related abilities within the area gains a +2 bonus to their powers. The area increases by +5 feet per Jewel rank. This power cannot be used while your Jewels are drained.

**Territorial Sense** (16777661-16777662)
- **Name:** Territorial Sense
- **Description:** Extend your awareness across your territory. You become aware of all creatures within 100 feet that pose a threat to you or your holdings. This awareness includes the location, type, and number of threats but not detailed information about them. You also sense any changes to your territory - such as unauthorized entry, building construction, or magical scrying attempts. This power requires you to have an established territory and does not create one if you have none. The range increases by +20 feet per Jewel rank. This power cannot be used while your Jewels are drained.

**Dominion** (16777663-16777664)
- **Name:** Dominion
- **Description:** Assert your royal authority over those of lesser standing. All creatures of lower caste within 30 feet must make a Will save (DC 10 + 1 per Jewel rank) or become dominated for 30 seconds. A dominated creature must obey your verbal commands and cannot take actions you have not authorized. Queens are unaffected by this power. Creatures that succeed on their save are immune to this effect for 24 hours. This power has no effect on creatures immune to mind-affecting effects. The range increases by +5 feet per Jewel rank and duration by +6 seconds per Jewel rank. This power cannot be used while your Jewels are drained.

**Courtly Presence** (16777665-16777666)
- **Name:** Courtly Presence
- **Description:** Project an aura of authority that enhances diplomatic outcomes. You gain a +2 bonus to all Diplomacy checks and a +2 bonus to Gather Information checks for 3 minutes. Additionally, when you enter a negotiation or diplomatic situation, the first impression modifier is increased by +2. The bonuses increase by +1 per Jewel rank. This power cannot be used while your Jewels are drained.

**Weather Sense** (16777667-16777668)
- **Name:** Weather Sense
- **Description:** Attune yourself to the weather patterns of your land. You can predict the weather for the next 24 hours with perfect accuracy. Additionally, you can attempt to influence the weather within 5 miles. You can cause it to rain, stop rain, reduce visibility with fog, or cause winds to increase or decrease. This influence is subtle and takes 1 hour to take effect. The prediction accuracy and influence range increase with your Jewel rank (prediction increases by +6 hours per Jewel rank, influence range increases by +1 mile per Jewel rank). This power cannot be used while your Jewels are drained.

---

## Implementation Plan

### Phase 1: Add Spell Columns to spells.2da

Add new columns to control class access:
- **Warlord**: Warlord/Warlord Prince (combat powers)
- **Prince**: Prince powers
- **Healer**: Healer powers
- **Widow**: Black Widow powers
- **Queen**: Queen powers
- **Priestess**: Priestess powers

Spell levels:
- 0 = Basic Craft (including Jewel-gated powers)
- 1 = Caste powers

### Phase 2: Class Spell Tables (Level 1-5 Server Cap)

#### 2.1 Spell Gain Tables (Spells Cast Per Day)

**cls_spgn_blood.2da** (Blood Male/Female - Basic Craft Only)

| Level | NumSpellLevels | SpellLvl0 | SpellLvl1 |
|-------|----------------|------------|------------|
| 1 | 1 | 3 | **** |
| 2 | 1 | 3 | **** |
| 3 | 1 | 4 | **** |
| 4 | 1 | 4 | **** |
| 5 | 1 | 4 | **** |

**cls_spgn_caste.2da** (All Caste Classes - Basic Craft + Caste Powers)

| Level | NumSpellLevels | SpellLvl0 | SpellLvl1 |
|-------|----------------|------------|------------|
| 1 | 2 | 3 | 2 |
| 2 | 2 | 3 | 2 |
| 3 | 2 | 4 | 3 |
| 4 | 2 | 4 | 3 |
| 5 | 2 | 4 | 3 |

---

#### 2.2 Spell Known Tables

**cls_spkn_blood.2da** (Blood Male/Female)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | **** |
| 2 | 2 | **** |
| 3 | 3 | **** |
| 4 | 3 | **** |
| 5 | 4 | **** |

**cls_spkn_warlord.2da** (Warlord)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 1 |
| 2 | 2 | 1 |
| 3 | 3 | 2 |
| 4 | 3 | 2 |
| 5 | 4 | 2 |

**cls_spkn_wprince.2da** (Warlord Prince)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 2 |
| 2 | 2 | 2 |
| 3 | 3 | 2 |
| 4 | 3 | 3 |
| 5 | 4 | 3 |

**cls_spkn_prince.2da** (Prince)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 1 |
| 2 | 2 | 1 |
| 3 | 3 | 2 |
| 4 | 3 | 2 |
| 5 | 4 | 2 |

**cls_spkn_healer.2da** (Healer)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 2 |
| 2 | 2 | 2 |
| 3 | 3 | 3 |
| 4 | 3 | 3 |
| 5 | 4 | 4 |

**cls_spkn_priestess.2da** (Priestess)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 2 |
| 2 | 2 | 2 |
| 3 | 3 | 3 |
| 4 | 3 | 3 |
| 5 | 4 | 4 |

**cls_spkn_widow.2da** (Black Widow)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 2 |
| 2 | 2 | 3 |
| 3 | 3 | 3 |
| 4 | 3 | 4 |
| 5 | 4 | 4 |

**cls_spkn_queen.2da** (Queen)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | 2 |
| 2 | 2 | 2 |
| 3 | 3 | 3 |
| 4 | 3 | 3 |
| 5 | 4 | 4 |

**cls_spkn_witch.2da** (Witch - Basic Caste, no unique powers)

| Level | SpellLvl0 | SpellLvl1 |
|-------|------------|------------|
| 1 | 2 | **** |
| 2 | 2 | **** |
| 3 | 3 | **** |
| 4 | 3 | **** |
| 5 | 4 | **** |

---

### Phase 3: Spell Scripts (NSS)

Create spell scripts using standard NWN naming convention `NW_S0_Cr*` (level 0-3 spells):

| # | Power | Script File |
|---|-------|-------------|
| 1 | Weave Shield | NW_S0_CrShield |
| 2 | Strengthen | NW_S0_CrStr |
| 3 | Minor Healing | NW_S0_CrHeal |
| 4 | Minor Illusion | NW_S0_CrIllus |
| 5 | Seduction | NW_S0_CrSeduction |
| 6 | Scrying | NW_S0_CrScrying |
| 7 | Summoning | NW_S0_CrSummon |
| 8 | Major Transformation | NW_S0_CrTransform |
| 9 | Battle Fury | NW_S0_CrBattleFury |
| 10 | Shield Breaker | NW_S0_CrShieldBreaker |
| 11 | Combat Mastery | NW_S0_CrCombatMastery |
| 12 | Fury of the Warlord | NW_S0_CrWarlordFury |
| 13 | Social Grace | NW_S0_CrSocialGrace |
| 14 | Shadow Walking | NW_S0_CrShadowWalk |
| 15 | Presence | NW_S0_CrPresence |
| 16 | Cleanse | NW_S0_CrCleanse |
| 17 | Mend | NW_S0_CrMend |
| 18 | Restoration | NW_S0_CrRestoration |
| 19 | Revitalize | NW_S0_CrRevitalize |
| 20 | Abyssal Guidance | NW_S0_CrAbyssGuidance |
| 21 | Sanctify | NW_S0_CrSanctify |
| 22 | Blessing | NW_S0_CrBlessing |
| 23 | Aura Reading | NW_S0_CrAuraReading |
| 24 | Entrap | NW_S0_CrEntrap |
| 25 | Venom Touch | NW_S0_CrVenomTouch |
| 26 | Dream Walker | NW_S0_CrDreamWalk |
| 27 | Greater Illusion | NW_S0_CrGreaterIllusion |
| 28 | Madness | NW_S0_CrMadness |
| 29 | Land's Bounty | NW_S0_CrLandsBounty |
| 30 | Territorial Sense | NW_S0_CrTerritorySense |
| 31 | Dominion | NW_S0_CrDominion |
| 32 | Courtly Presence | NW_S0_CrCourtPresence |
| 33 | Weather Sense | NW_S0_CrWeatherSense |

### Phase 4: Integration

- Add SetTlkOverride() calls in a module load script for all spell names and descriptions
- Ensure psychic drain applies correctly to all Craft powers
- Jewel-based scaling for power effectiveness
- Jewel-gated powers (Scrying, Summoning, Major Transformation) should check Jewel rank before allowing use
- Test class restrictions work correctly
- Update classes.2da to reference appropriate spell gain and spell known tables

---

## Technical Notes

### Spell Casting Integration
The existing system in `gs_spellscript.nss:229-246` handles psychic drain:
```nwn
if (nSpellLevel < 2)
{
    int nWisdom = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
    if (nWisdom < 0) nWisdom = 0;
    int nPsychicDrain = (100 / (2 - nSpellLevel)) / (1 + jGetJewelStrength(OBJECT_SELF) + nWisdom);
    gsSTDoCasterDamage(OBJECT_SELF, nPsychicDrain);
}
```

### Jewel-Based Scaling
Spell effectiveness should scale with Jewel rank:
- Duration: `6 seconds * JewelStrength`
- Damage/Healing: `1d6 * JewelStrength`
- DC: `10 + JewelStrength`

### Jewel-Gated Power Implementation
Powers that require specific Jewel ranks (Scrying, Summoning, Major Transformation) must check `jGetJewelStrength()` before allowing the spell to be cast. If the caster's Rank Jewel is below the required level, the spell should fail with an appropriate message.

### Class Access Summary
| Class | Basic Craft | Combat | Diplomatic | Healing | Illusion/Dreams | Abyss | Land |
|-------|-------------|--------|------------|---------|-----------------|-------|------|
| Blood M/F | ✓ | - | - | - | - | - | - |
| Warlord | ✓ | ✓ | - | - | - | - | - |
| Warlord Prince | ✓ | ✓+ | - | - | - | - | - |
| Prince | ✓ | - | ✓ | - | - | - | - |
| Witch | ✓ | - | - | - | - | - | - |
| Healer | ✓ | - | - | ✓ | - | - | - |
| Priestess | ✓ | - | - | - | - | ✓ | - |
| Black Widow | ✓ | - | - | - | ✓ | - | - |
| Queen | ✓ | - | ✓ | - | - | - | ✓ |

---

## Next Steps

1. Review spell descriptions for completeness and accuracy
2. Confirm TLK ID reservation (16777603-16777668)
3. Begin Phase 1: Add columns to spells.2da
4. Implement SetTlkOverride() for spell names/descriptions in module load script
5. Proceed with spell script development
6. Configure/update class spell gain and spell known tables in 2da files
