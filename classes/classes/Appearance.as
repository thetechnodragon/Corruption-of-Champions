﻿package classes
{
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Player;
	import classes.Monster;
	import classes.CoC_Settings;
	import classes.internals.Utils;


	public class Appearance extends Utils
	{
		// Eventually, this should contain the entire char appearance.
		// At the moment, it's pretty piecemeal.
		// TODO remove when we have proper enums for this
		include "../../includes/appearanceDefs.as";

		public static function inverseMap(x:Object):Object
		{
			var result:Object = {};
			for (var i:String in x) {
				result[String(x[i])] = i;
			}
			return result;
		}

		public static function hairOrFur(i_creature:Creature):String
		{
			if (i_creature.skinType == 1)
				return "fur";
			else
				return "hair";
		}

		public static function hairDescription(i_creature:Creature):String
		{
			var description:String = "";
			var options:Array;
			//
			// LENGTH ADJECTIVE!
			//
			if (i_creature.hairLength == 0) {
				options = ["shaved",
					"bald",
					"smooth",
					"hairless",
					"glabrous"];
				description = randomChoice(options) + " head";
				return description;
			}
			if (i_creature.hairLength < 1) {
				options = ["close-cropped, ",
					"trim, ",
					"very short, "];
				description += randomChoice(options);
			}
			if (i_creature.hairLength >= 1 && i_creature.hairLength < 3) description += "short, ";
			if (i_creature.hairLength >= 3 && i_creature.hairLength < 6) description += "shaggy, ";
			if (i_creature.hairLength >= 6 && i_creature.hairLength < 10) description += "moderately long, ";
			if (i_creature.hairLength >= 10 && i_creature.hairLength < 16) {
				if (rand(2) == 0) description += "long, ";
				else description += "shoulder-length, ";
			}
			if (i_creature.hairLength >= 16 && i_creature.hairLength < 26) {
				if (rand(2) == 0) description += "very long, ";
				else description += "flowing locks of ";
			}
			if (i_creature.hairLength >= 26 && i_creature.hairLength < 40) description += "ass-length, ";
			if (i_creature.hairLength >= 40 && i_creature.hairLength < i_creature.tallness) description += "obscenely long, ";
			else if (i_creature.hairLength >= i_creature.tallness) {
				if (rand(2) == 0) description += "floor-length, ";
				else description += "floor-dragging, ";
			}
			//
			// COLORS
			//
			description += i_creature.hairColor + " ";
			//
			// HAIR WORDS
			//
			//If furry and longish hair sometimes call it a mane (50%)
			if (i_creature.skinType == 1 && i_creature.hairLength > 3 && rand(2) == 0) {
				if (i_creature.hairType == 1) description += "feather-";
				else if (i_creature.hairType == 2) description += "transparent ";
				else if (i_creature.hairType == 3) description += "goo-";
				else if (i_creature.hairType == 4) description += "tentacle-";
				description += "mane";
				return description;
			}
			//if medium length refer to as locks sometimes
			//CUT - locks is plural and screws up tense.
			/*if(creature.hairLength >= 3 && creature.hairLength < 16 && rand(2) == 0) {
			 descript += "locks of hair";
			 return descript;
			 }*/
			//If nothing else used, use hair!
			if (i_creature.hairType == 1) description += "feather-";
			else if (i_creature.hairType == 2) description += "transparent ";
			else if (i_creature.hairType == 3) description += "goo-";
			else if (i_creature.hairType == 4) description += "tentacle-";
			description += "hair";

			return description;
		}

		/**
		 * Describe tongue. Monsters don't have tongues, apparently.
		 * @param    i_character Either Player or NonPlayer
		 * @return    A beautiful description of a tongue.
		 */
		public static function tongueDescription(i_character:Character):String
		{
			if (i_character.tongueType == 1) return "serpentine tongue";
			else if (i_character.tongueType == 2) return "demonic tongue";
			else if (i_character.tongueType == 3) return "draconic tongue";
			else return "tongue";
		}

		public static function nippleDescription(i_creature:Creature, i_rowNum:Number):String
		{
			//DEBUG SHIT!
			if (i_rowNum > (i_creature.breastRows.length - 1)) {
				CoC_Settings.error("<B>Error: Invalid breastRows (" + i_rowNum + ") passed to nippleDescription()</b>");
				return "<B>Error: Invalid breastRows (" + i_rowNum + ") passed to nippleDescription()</b>";
			}
			if (i_rowNum < 0) {
				CoC_Settings.error("<B>Error: Invalid breastRows (" + i_rowNum + ") passed to nippleDescription()</b>");
				return "<B>Error: Invalid breastRows (" + i_rowNum + ") passed to nippleDescription()</b>";
			}
			var haveDescription:Boolean = false;
			var description:String = "";
			var options:Array;
			var rando:Number = 0;
			//Size descriptors 33% chance
			if (rand(4) == 0) {
				//TINAHHHH
				if (i_creature.nippleLength < .25) {
					options = ["tiny ",
						"itty-bitty ",
						"teeny-tiny ",
						"dainty "];
					description += randomChoice(options);
				}
				//Prominant
				if (i_creature.nippleLength >= .4 && i_creature.nippleLength < 1) {
					options = ["prominent ",
						"pencil eraser-sized ",
						"eye-catching ",
						"pronounced ",
						"striking "];
					description += randomChoice(options);
				}
				//Big 'uns
				if (i_creature.nippleLength >= 1 && i_creature.nippleLength < 2) {
					options = ["forwards-jutting ",
						"over-sized ",
						"fleshy ",
						"large protruding "];
					description += randomChoice(options);
				}
				//'Uge
				if (i_creature.nippleLength >= 2 && i_creature.nippleLength < 3.2) {
					options = ["elongated ",
						"massive ",
						"awkward ",
						"lavish ",
						"hefty "];
					description += randomChoice(options);
				}
				//Massive
				if (i_creature.nippleLength >= 3.2) {
					options = ["bulky ",
						"ponderous ",
						"thumb-sized ",
						"cock-sized ",
						"cow-like "];
					description += randomChoice(options);
				}
				haveDescription = true;
			}
			//Milkiness/Arousal/Wetness Descriptors 33% of the time
			if (rand(3) == 0 && !haveDescription) {
				//Fuckable chance first!
				if (i_creature.hasFuckableNipples()) {
					//Fuckable and lactating?
					if (i_creature.biggestLactation() > 1) {
						options = ["milk-lubricated ",
							"lactating ",
							"lactating ",
							"milk-slicked ",
							"milky "];
						description += randomChoice(options);
					}
					//Just fuckable
					else {
						options = ["wet ",
							"mutated ",
							"slimy ",
							"damp ",
							"moist ",
							"slippery ",
							"oozing ",
							"sloppy ",
							"dewy "];
						description += randomChoice(options);
					}
					haveDescription = true;
				}
				//Just lactating!
				else if (i_creature.biggestLactation() > 0) {
					//Light lactation
					if (i_creature.biggestLactation() <= 1) {
						options = ["milk moistened ",
							"slightly lactating ",
							"milk-dampened "];
						description += randomChoice(options);
					}
					//Moderate lactation
					if (i_creature.biggestLactation() > 1 && i_creature.biggestLactation() <= 2) {
						options = ["lactating ",
							"milky ",
							"milk-seeping "];
						description += randomChoice(options);
					}
					//Heavy lactation
					if (i_creature.biggestLactation() > 2) {
						options = ["dripping ",
							"dribbling ",
							"milk-leaking ",
							"drooling "];
						description += randomChoice(options);
					}
					haveDescription = true;
				}
			}
			//Possible arousal descriptors
			else if (rand(3) == 0 && !haveDescription) {
				if (i_creature.lust > 50 && i_creature.lust < 75) {
					options = ["erect ",
						"perky ",
						"erect ",
						"firm ",
						"tender "];
					description += randomChoice(options);
					haveDescription = true;
				}
				if (i_creature.lust >= 75) {
					options = ["throbbing ",
						"trembling ",
						"needy ",
						"throbbing "];
					description += randomChoice(options);
					haveDescription = true;
				}
			}
			if (!haveDescription && rand(2) == 0 && i_creature.nipplesPierced > 0 && i_rowNum == 0) {
				if (i_creature.nipplesPierced == 5) description += "chained ";
				else description += "pierced ";
				haveDescription = true;
			}
			if (!haveDescription && i_creature.skinType == 3) {
				options = ["slime-slick ",
					"goopy ",
					"slippery "];
				description += randomChoice(options);
			}
			if (!haveDescription && i_creature.findStatusAffect(StatusAffects.BlackNipples) >= 0) {
				options = ["black ",
					"ebony ",
					"sable "];
				description += randomChoice(options);
			}

			//Nounsssssssss*BOOM*
			var choice:int = 0;
			choice = rand(5);
			if (choice == 0) description += "nipple";
			if (choice == 1) {
				if (i_creature.nippleLength < .5) description += "perky nipple";
				else description += "cherry-like nub";
			}
			if (choice == 2) {
				if (i_creature.hasFuckableNipples()) description += "fuckable nip";
				else {
					if (i_creature.biggestLactation() >= 1 && i_creature.nippleLength >= 1) description += "teat";
					else description += "nipple";
				}
			}
			if (choice == 3) {
				if (i_creature.hasFuckableNipples()) description += "nipple-hole";
				else {
					if (i_creature.biggestLactation() >= 1 && i_creature.nippleLength >= 1) description += "teat";
					else description += "nipple";
				}
			}
			if (choice == 4) {
				if (i_creature.hasFuckableNipples()) description += "nipple-cunt";
				else description += "nipple";
			}
			return description;
			/*OLD
			 if(creature.breastRows[rowNum].lactationMultiplier >= 1.5 && creature.breastRows[rowNum].lactationMultiplier < 1.75) {
			 if(creature.breastRows[rowNum].milkFullness > 75) return "over-full leaking teat";
			 if(rand(2) == 0) return "milky teat";
			 else return "milk spout";
			 }
			 if(creature.breastRows[rowNum].lactationMultiplier >= 1.75) {
			 if(creature.breastRows[rowNum].milkFullness > 75) return "over-full leaking teat";
			 if(rand(2) == 0) return "milk-drooling teat";
			 else return "drippy cow-teat";
			 }
			 if(creature.lust > 75) {
			 if(rand(2) == 0) return "painfully hard nipple";
			 else return "over-stimulated nipple";
			 }
			 if(creature.lust > 50) {
			 if(rand(2) == 0) return "erect nipple";
			 else return "hard nipple";
			 }
			 if(creature.breastRows[rowNum].milkFullness > 75) return "milky over-full nipple";
			 return "nipple";
			 */
		}

		public static function hipDescription(i_character:Character):String
		{
			var description:String = "";
			var options:Array;
			if (i_character.hipRating <= 1) {
				options = ["tiny ",
					"narrow ",
					"boyish "];
				description = randomChoice(options);
			}
			else if (i_character.hipRating > 1 && i_character.hipRating < 4) {
				options = ["slender ",
					"narrow ",
					"thin "];
				description = randomChoice(options);
				if (i_character.thickness < 30) {
					if (rand(2) == 0) description = "slightly-flared ";
					else description = "curved ";
				}
			}
			else if (i_character.hipRating >= 4 && i_character.hipRating < 6) {
				options = ["well-formed ",
					"pleasant "];
				description = randomChoice(options);
				if (i_character.thickness < 30) {
					if (rand(2) == 0) description = "flared ";
					else description = "curvy ";
				}
			}
			else if (i_character.hipRating >= 6 && i_character.hipRating < 10) {
				options = ["ample ",
					"noticeable ",
					"girly "];
				description = randomChoice(options);
				if (i_character.thickness < 30) {
					if (rand(2) == 0) description = "flared ";
					else description = "waspish ";
				}
			}
			else if (i_character.hipRating >= 10 && i_character.hipRating < 15) {
				options = ["flared ",
					"curvy ",
					"wide "];
				description = randomChoice(options);
				if (i_character.thickness < 30) {
					if (rand(2) == 0) description = "flared ";
					else description = "waspish ";
				}
			}
			else if (i_character.hipRating >= 15 && i_character.hipRating < 20) {
				if (i_character.thickness < 40) {
					if (rand(2) == 0) description = "flared, ";
					else description = "waspish, ";
				}
				options = ["fertile ",
					"child-bearing ",
					"voluptuous "];
				description += randomChoice(options);
			}
			else if (i_character.hipRating >= 20) {
				if (i_character.thickness < 40) {
					if (rand(2) == 0) description = "flaring, ";
					else description = "incredibly waspish, ";
				}
				options = ["broodmother-sized ",
					"cow-like ",
					"inhumanly-wide "];
				description += randomChoice(options);
			}
			//Taurs
			if (i_character.isTaur() && rand(3) == 0) description += "flanks";
			//Nagas have sides, right?
			else if (i_character.isNaga() && rand(3) == 0) description += "sides";
			//Non taurs or taurs who didn't roll flanks
			else {
				options = ["hips",
					"thighs"];
				description += randomChoice(options);
			}

			return description;
		}

		public static function cockDescription(i_creature:Creature, i_cockIndex:Number):String
		{
			if (i_creature.totalCocks() == 0) {
				CoC_Settings.error("<b>ERROR: CockDescript Called But No Cock Present</b>");
				return "<b>ERROR: CockDescript Called But No Cock Present</b>";
			}
			if (i_creature.totalCocks() <= i_cockIndex || (i_cockIndex == 99 || i_cockIndex == -1)) {
				CoC_Settings.error("<b>ERROR: CockDescript called with index of " + i_cockIndex + " - out of BOUNDS</b>");
				return "<b>ERROR: CockDescript called with index of " + i_cockIndex + " - out of BOUNDS</b>";
			}

			//Cocknum 99 to default to boring descriptions!
			if (i_cockIndex != 99) {
				if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.HORSE) return horseDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.DOG) return dogDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.FOX) return foxDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.TENTACLE) return tentacleDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.DEMON) return demonDescript(i_cockIndex)
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.CAT) return catDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.LIZARD) return snakeDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.ANEMONE) return anemoneDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.KANGAROO) return kangaDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.DRAGON) return dragonDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.DISPLACER) return displacerDescript(i_cockIndex);
				else if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.HUMAN) return humanDescript(i_cockIndex);
				else {
					CoC_Settings.error("cockDescription failed to describe your cock");
					trace("ERROR: Cock type failed to match. " + i_creature.cocks[i_cockIndex].cockType);
					return "cockDescription failed to describe your cock";
				}
			}
			else
				i_cockIndex = 0;

			var description:String = "";
			var options:Array;

			//50% of the time add a descriptor
			if (rand(2) == 0)
				description += cockAdjective(i_creature, i_cockIndex) + " ";
			var rando:Number = 0;
			options = ["cock",
				"prick",
				"pecker",
				"shaft",
				"dick",
				"manhood",
				"member",
				"meatstick",
				"schlong",
				"wang",
				"fuckpole",
				"package",
				"love muscle",
				"rod",
				"anaconda"];
			description += randomChoice(options);

			return description;
		}

		public static function cockNoun(cockType:*):String
		{
			if (cockType is int) {
				trace("Someone is still calling cockNoun with an integer cock type");
				trace("Fix this shit already, dammit!")
				cockType = CockTypesEnum.ParseConstantByIndex(cockType);
			}
			var options:Array;
			var description:String = "";
			if (cockType == CockTypesEnum.HUMAN) {
				// Yeah, this is kind of messy
				// there is no other easy way to preserve the weighting fenoxo did
				options = ["cock",
					"cock",
					"cock",
					"cock",
					"cock",
					"prick",
					"prick",
					"pecker",
					"shaft",
					"shaft",
					"shaft"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DOG) {
				options = ["dog-shaped dong",
					"canine shaft",
					"pointed prick",
					"knotty dog-shaft",
					"bestial cock",
					"animalistic puppy-pecker",
					"pointed dog-dick",
					"pointed shaft",
					"canine member",
					"canine cock",
					"knotted dog-cock"];

				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.FOX) {
				options = ["fox-shaped dong",
					"vulpine shaft",
					"pointed prick",
					"knotty fox-shaft",
					"bestial cock",
					"animalistic vixen-pricker",
					"pointed fox-dick",
					"pointed shaft",
					"vulpine member",
					"vulpine cock",
					"knotted fox-cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.HORSE) {
				options = ["flared horse-cock",
					"equine prick",
					"bestial horse-shaft",
					"flat-tipped horse-member",
					"animalistic stallion-prick",
					"equine dong",
					"beast cock",
					"flared stallion-cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DEMON) {
				options = ["nub-covered demon-dick",
					"nubby shaft",
					"corrupted cock",
					"perverse pecker",
					"bumpy demon-dick",
					"demonic cock",
					"demonic dong",
					"cursed cock",
					"infernal prick",
					"unholy cock",
					"blighted cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.TENTACLE) {
				options = ["twisting tentacle-prick",
					"wriggling plant-shaft",
					"sinuous tentacle-cock",
					"squirming cock-tendril",
					"writhing tentacle-pecker",
					"wriggling plant-prick",
					"penile flora",
					"smooth shaft",
					"undulating tentacle-dick",
					"slithering vine-prick",
					"vine-shaped cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.CAT) {
				options = ["feline dick",
					"spined cat-cock",
					"pink kitty-cock",
					"spiny prick",
					"animalistic kitty-prick",
					"oddly-textured cat-penis",
					"feline member",
					"spined shaft",
					"feline shaft",
					"barbed dick",
					"nubby kitten-prick"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.LIZARD) {
				options = ["reptilian dick",
					"purple cock",
					"inhuman cock",
					"reptilian prick",
					"purple prick",
					"purple member",
					"serpentine member",
					"serpentine shaft",
					"reptilian shaft",
					"bulbous snake-shaft",
					"bulging snake-dick"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.ANEMONE) {
				options = ["anemone dick",
					"tentacle-ringed cock",
					"blue member",
					"stinger-laden shaft",
					"pulsating prick",
					"anemone prick",
					"stinger-coated member",
					"blue cock",
					"tentacle-ringed dick",
					"near-transparent shaft",
					"squirming shaft"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.KANGAROO) {
				options = ["kangaroo-like dick",
					"pointed cock",
					"marsupial member",
					"tapered shaft",
					"curved pecker",
					"pointed prick",
					"squirming kangaroo-cock",
					"marsupial cock",
					"tapered kangaroo-dick",
					"curved kangaroo-cock",
					"squirming shaft"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DRAGON) {
				options = ["dragon-like dick",
					"segmented shaft",
					"pointed prick",
					"knotted dragon-cock",
					"mythical mast",
					"segmented tool",
					"draconic dick",
					"draconic cock",
					"tapered dick",
					"unusual endowment",
					"scaly shaft"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DISPLACER) {
				options = ["coerl cock",
					"tentacle-tipped phallus",
					"starfish-tipped shaft",
					"alien member",
					"almost-canine dick",
					"bizarre prick",
					"beastly cock",
					"cthulhu-tier cock",
					"coerl cock",
					"animal dong",
					"star-capped tool",
					"knotted erection"];
				description += randomChoice(options);
			}
			else {
				options = ["cock",
					"prick",
					"pecker",
					"shaft"];
				description += randomChoice(options);
			}

			//trace("Correct Appearance.cockNoun - Produced noun descriptor - ", descript);
			return description;
		}

		public static function cockAdjective(i_creature:Creature, i_cockIndex:Number = -1):String
		{
			var description:String = "";
			var multi:Boolean = false;
			var options:Array;

			//If used for multiple cocks, set multi flag
			if (i_cockIndex < 0) {
				//Since we have multi dicks lets talk about the biggest!
				i_cockIndex = i_creature.biggestCockIndex();
				multi = true;
			}
			//Pierced - 1/5 chance
			if (!multi && rand(5) == 0 && i_creature.cocks[i_cockIndex].pierced > 0) {
				description += "pierced";
			}
			else if (!multi && rand(5) == 0 && i_creature.cocks[i_cockIndex].sock != "") {
				options = ["sock-sheathed",
					"garment-wrapped",
					"smartly dressed",
					"cloth-shrouded",
					"fabric swaddled",
					"covered"];
				description += randomChoice(options);
			}
			//Goo - 1/4 chance
			else if (i_creature.skinType == 3 && rand(4) == 0) {
				options = ["goopey",
					"gooey",
					"slimy"];
				description += randomChoice(options);
			}
			//Length 1/3 chance
			else if (rand(3) == 0) {
				if (i_creature.cocks[i_cockIndex].cockLength < 3) {
					options = ["little",
						"toy-sized",
						"mini",
						"budding",
						"tiny"];
					description += randomChoice(options);
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 5) {
					description += randomChoice("short", "small");
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 7) {
					description += randomChoice("fair-sized", "nice");
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 11) {
					options = ["sizable"];

					if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.HORSE) {
						options.push("pony-sized", "colt-like");
					}
					else
						options.push("long", "lengthy");

					description += randomChoice(options);
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 14) {
					options = ["huge", "foot-long"];
					if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.DOG)
						options.push("mastiff-like");
					else
						options.push("cucumber-length");
					description += randomChoice(options);
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 18) {
					description += randomChoice("massive", "knee-length", "forearm-length");
				}
				else if (i_creature.cocks[i_cockIndex].cockLength < 30) {
					description += randomChoice("enormous", "giant", "arm-like");
				}
				else {
					if (i_creature.cocks[i_cockIndex].cockType == CockTypesEnum.TENTACLE && rand(2) == 0)
						description += "coiled ";
					else {
						options = ["towering",
							"freakish",
							"monstrous",
							"massive"];
						description += randomChoice(options);
					}
				}
			}
			//Hornyness 1/2
			else if (i_creature.lust > 75 && rand(2) == 0) {
				//Uber horny like a baws!
				if (i_creature.lust > 90) {
					//Weak as shit cum
					if (i_creature.cumQ() < 50) {
						description += randomChoice("throbbing", "pulsating");
					}
					//lots of cum? drippy.
					else if (i_creature.cumQ() < 200) {
						description += randomChoice("dribbling", "leaking", "drooling");
					}
					//Tons of cum
					else {
						description += randomChoice("very drippy", "pre-gushing", "cum-bubbling", "pre-slicked", "pre-drooling");
					}
				}
				//A little less lusty, but still lusty.
				else if (i_creature.lust > 75) {
					if (i_creature.cumQ() < 50) {
						description += randomChoice("turgid", "blood-engorged", "rock-hard", "stiff", "eager");
					}
					//A little drippy
					else if (i_creature.cumQ() < 200) {
						description += randomChoice("turgid", "blood-engorged", "rock-hard", "stiff", "eager", "fluid-beading", "slowly-oozing");
					}
					//uber drippy
					else {
						description += randomChoice("dribbling", "drooling", "fluid-leaking", "leaking");
					}
				}
			}
			//Girth - fallback
			else {
				if (i_creature.cocks[i_cockIndex].cockThickness <= .75) {
					description += randomChoice("thin", "slender", "narrow");
				}
				else if (i_creature.cocks[i_cockIndex].cockThickness <= 1.2) {
					description += "ample";
				}
				else if (i_creature.cocks[i_cockIndex].cockThickness <= 1.4) {
					description += randomChoice("ample", "big");
				}
				else if (i_creature.cocks[i_cockIndex].cockThickness <= 2) {
					description += randomChoice("broad", "meaty", "girthy");
				}
				else if (i_creature.cocks[i_cockIndex].cockThickness <= 3.5) {
					description += randomChoice("fat", "distended", "wide");
				}
				else if (i_creature.cocks[i_cockIndex].cockThickness > 3.5) {
					description += randomChoice("inhumanly distended", "monstrously thick", "bloated");
				}
			}
			return description;
		}

		//Cock adjectives for single cock
		public static function cockAdjectives(i_cockLength:Number, i_cockThickness:Number, i_cockType:CockTypesEnum, i_creature:Creature):String
		{
			var description:String = "";
			var rando:Number = 0;
			var descripts:Number = 0;
			//length or thickness, usually length.
			if (rand(4) == 0) {
				if (i_cockLength < 3) {
					rando = rand(3);
					if (rando == 0) description = "little";
					else if (rando == 1) description = "toy-sized";
					else description = "tiny";
				}
				else if (i_cockLength < 5) {
					if (rand(2) == 0) description = "short";
					else description = "small";
				}
				else if (i_cockLength < 7) {
					if (rand(2) == 0) description = "fair-sized";
					else description = "nice";
				}
				else if (i_cockLength < 9) {
					rando = rand(3);
					if (rando == 0) description = "long";
					else if (rando == 1) description = "lengthy";
					else if (rando == 2) description = "sizable";
				}
				else if (i_cockLength < 13) {
					if (rand(2) == 0) description = "huge";
					else description = "foot-long";
				}
				else if (i_cockLength < 18) {
					if (rand(2) == 0) description = "massive";
					else description = "forearm-length";
				}
				else if (i_cockLength < 30) {
					if (rand(2) == 0) description = "enormous";
					else description = "monster-length";
				}
				else {
					rando = rand(3);
					if (rando == 0) description = "towering";
					else if (rando == 1) description = "freakish";
					else description = "massive";
				}
				descripts = 1;
			}
			//thickness go!
			else if (rand(4) == 0 && descripts == 0) {
				if (i_cockThickness <= .75) description += "narrow";
				else if (i_cockThickness <= 1.1) description += "nice";
				else if (i_cockThickness <= 1.4) {
					if (rand(2) == 0) description += "ample";
					else description += "big";
				}
				else if (i_cockThickness <= 2) {
					if (rand(2) == 0) description += "broad";
					else description += "girthy";
				}
				else if (i_cockThickness <= 3.5) {
					if (rand(2) == 0) description += "fat";
					else description += "distended";
				}
				else {
					if (rand(2) == 0) description += "inhumanly distended";
					else description += "monstrously thick";
				}
				descripts = 1;
			}
			//Length/Thickness done.  Moving on to special animal characters/lust stuff.
			/*Animal Fillers - turned off due to duplication in noun segment
			 else if(type == 1 && descripts == 0 && rand(2) == 0) {
			 if(rand(2) == 0) descript += "flared ";
			 else descript += "musky ";
			 }
			 else if(type == 2 && descripts == 0 && rand(2) == 0) {
			 descript += "musky ";
			 }*/
			//FINAL FALLBACKS - lust descriptors
			//Lust stuff
			else if (i_creature.lust > 90) {
				//lots of cum? drippy.
				if (i_creature.cumQ() > 50 && i_creature.cumQ() < 200 && rand(2) == 0) {
					//for hroses and dogs
					if (i_cockType.Group == "animal") description += "animal-pre leaking";
					else description += "pre-slickened";
					descripts = 1;
				}
				//Tons of cum
				if (i_creature.cumQ() >= 200 && rand(2) == 0) {
					//for horses and dogs
					if (i_cockType.Group == "animal") description += "animal-spunk dripping";
					else description += "cum-drooling";
					descripts = 1;
				}
				//Not descripted? Pulsing and twitching
				if (descripts == 0) {
					if (rand(2) == 0) description += "throbbing";
					else description += "pulsating";
					descripts = 1;
				}
			}
			//A little less lusty, but still lusty.
			else if (i_creature.lust > 75) {
				if (descripts == 0 && i_creature.cumQ() > 50 && i_creature.cumQ() < 200 && rand(2) == 0) {
					description += "pre-leaking";
					descripts = 1;
				}
				if (descripts == 0 && i_creature.cumQ() >= 200 && rand(2) == 0) {
					description += "pre-cum dripping";
					descripts = 1;
				}
				if (descripts == 0) {
					if (rand(2) == 0) description += "rock-hard";
					else description += "eager";
					descripts = 1;
				}
			}
			//Not lusty at all, fallback adjective
			else if (i_creature.lust > 50) description += "hard";
			else description += "ready";
			return description;
		}

		//Short cock description. Describes length or girth. Supports multiple cocks.
		public static function cockDescriptionShort(i_cockIndex:int, i_creature:Creature):String
		{
			// catch calls where we're outside of combat, and eCockDescript could be called.
			if (i_creature.cocks.length == 0)
				return "<B>ERROR. INVALID CREATURE SPECIFIED to cockDescriptShort</B>";

			var description:String = "";
			var descripted:Boolean = false;
			//Discuss length one in 3 times
			if (int(Math.random() * 3 == 0)) {

				if (i_creature.cocks[i_cockIndex].cockLength >= 30)
					description = "towering ";
				else if (i_creature.cocks[i_cockIndex].cockLength >= 18)
					description = "enormous ";
				else if (i_creature.cocks[i_cockIndex].cockLength >= 13)
					description = "massive ";
				else if (i_creature.cocks[i_cockIndex].cockLength >= 10)
					description = "huge ";
				else if (i_creature.cocks[i_cockIndex].cockLength >= 7)
					description = "long ";
				else if (i_creature.cocks[i_cockIndex].cockLength >= 5)
					description = "average ";
				else
					description = "short ";
				descripted = true;
			}

			//Discuss girth one in 2 times if not already talked about length.
			else if (int(Math.random() * 2 == 0) && !descripted) {
				//narrow, thin, ample, broad, distended, voluminous
				if (i_creature.cocks[i_cockIndex].cockThickness <= .75) description = "narrow ";
				if (i_creature.cocks[i_cockIndex].cockThickness > 1 && i_creature.cocks[i_cockIndex].cockThickness <= 1.4) description = "ample ";
				if (i_creature.cocks[i_cockIndex].cockThickness > 1.4 && i_creature.cocks[i_cockIndex].cockThickness <= 2) description = "broad ";
				if (i_creature.cocks[i_cockIndex].cockThickness > 2 && i_creature.cocks[i_cockIndex].cockThickness <= 3.5) description = "fat ";
				if (i_creature.cocks[i_cockIndex].cockThickness > 3.5) description = "distended ";
				descripted = true;
			}
			if (descripted && i_creature.cocks[i_cockIndex].cockType.Index > 0) description += ", ";
			description += Appearance.cockNoun(i_creature.cocks[i_cockIndex].cockType);

			return description;
		}

		public static function cockMultiNoun(cockType:*):String
		{
			if (cockType is int) {
				trace("Someone is still calling cockNoun with an integer cock type");
				trace("Fix this shit already, dammit!");
				cockType = CockTypesEnum.ParseConstantByIndex(cockType);
			}
			var options:Array;
			var description:String = "";
			if (cockType == CockTypesEnum.HUMAN) {
				options = ["cock",
					"cock",
					"cock",
					"cock",
					"cock",
					"prick",
					"prick",
					"pecker",
					"shaft",
					"shaft",
					"shaft"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DOG) {
				options = ["doggie dong",
					"canine shaft",
					"pointed prick",
					"dog-shaft",
					"dog-cock",
					"puppy-pecker",
					"dog-dick",
					"pointed shaft",
					"canine cock",
					"canine cock",
					"dog cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.HORSE) {
				options = ["horsecock",
					"equine prick",
					"horse-shaft",
					"horse-prick",
					"stallion-prick",
					"equine dong"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.DEMON) {
				options = ["demon-dick",
					"nubby shaft",
					"corrupted cock",
					"perverse pecker",
					"bumpy demon-dick",
					"demonic cock",
					"demonic dong",
					"cursed cock",
					"infernal prick",
					"unholy cock",
					"blighted cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.TENTACLE) {
				options = ["tentacle prick",
					"plant-like shaft",
					"tentacle cock",
					"cock-tendril",
					"tentacle pecker",
					"plant prick",
					"penile flora",
					"smooth inhuman shaft",
					"tentacle dick",
					"vine prick",
					"vine-like cock"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.CAT) {
				options = ["feline dick",
					"cat-cock",
					"kitty-cock",
					"spiny prick",
					"pussy-prick",
					"cat-penis",
					"feline member",
					"spined shaft",
					"feline shaft",
					"'barbed' dick",
					"kitten-prick"];
				description += randomChoice(options);
			}
			else if (cockType == CockTypesEnum.LIZARD) {
				options = ["reptile-dick",
					"purple cock",
					"inhuman cock",
					"reptilian prick",
					"purple prick",
					"purple member",
					"serpentine member",
					"serpentine shaft",
					"reptilian shaft",
					"snake-shaft",
					"snake dick"];
				description += randomChoice(options);
			}
			else {
				description += randomChoice("cock", "prick", "pecker", "shaft");
			}
			return description;
		}

		//TODO Give Method a better name
		/**
		 * Descripes cocks, either singular ("one of"/"one of your") or each ("each of"/"each of your").
		 * @param    i_creature Creature type, either Player or Monster
		 * @param    i_capitalised Capitalised for start of sentence.
		 * @param    i_singular true = "one of", false = "each"
		 * @return    Short description of cock(s)
		 */
		public static function cockMultiDesc(i_creature:Creature, i_capitalised:Boolean, i_singular:Boolean):String
		{
			var description:String = "";
			var notCapitalised:Boolean = false;
			if (i_creature.totalCocks() > 1) {
				if (i_singular) {
					(i_capitalised) ? description += "O" : description += "o";
					description += "ne of ";
				}
				else {
					(i_capitalised) ? description += "E" : description += "e";
					description += "ach of ";
				}
				notCapitalised = true;
			}

			(i_capitalised && !(notCapitalised)) ? description += "Y" : description += "y";
			description += "our ";

			description += cockMultiLDescriptionShort(i_creature);
			return description;
		}

		public static function cockMultiLDescriptionShort(i_creature:Creature):String
		{
			var description:String = "";
			if (i_creature.cocks.length < 1) {
				CoC_Settings.error("<b>ERROR: NO WANGS DETECTED for cockMultiLightDesc()</b>");
				return "<b>ERROR: NO WANGS DETECTED for cockMultiLightDesc()</b>";
			}
			if (i_creature.horseCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.HORSE);
			else if (i_creature.dogCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.DOG);
			else if (i_creature.demonCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.DEMON);
			else if (i_creature.tentacleCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.TENTACLE);
			else if (i_creature.catCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.CAT);
			else if (i_creature.lizardCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.LIZARD);
			else if (i_creature.anemoneCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.ANEMONE);
			else if (i_creature.kangaCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.KANGAROO);
			else if (i_creature.dragonCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.DRAGON);
			else if (i_creature.displacerCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.DISPLACER);
			else if (i_creature.foxCocks() == i_creature.totalCocks()) description += cockNoun(CockTypesEnum.FOX);
			else description += cockNoun(CockTypesEnum.HUMAN);
			//Add s if plural
			if (i_creature.cockTotal() > 1) description += "s";
			//Reset to normal description if singular
			else description = cockDescription(i_creature, 0);
			return description;
		}

		/**
		 * Describe creatures balls.
		 * @param    i_forcedSize    Force a description of the size of the balls
		 * @param    i_plural        Show plural forms
		 * @param    i_creature        Monster, Player or NonPlayer
		 * @param    i_withArticle    Show description with article in front
		 * @return    Full description of balls
		 */
		public static function ballsDescription(i_forcedSize:Boolean, i_plural:Boolean, i_creature:Creature, i_withArticle:Boolean = false):String
		{
			if (i_creature.balls == 0) return "prostate";

			var haveDescription:Boolean = false;
			var rando:Number = 0;
			var description:String = "";
			var options:Array;

			if (i_plural && (i_creature.findStatusAffect(StatusAffects.Uniball) < 0)) {
				if (i_creature.balls == 1) {
					if (i_withArticle) {
						options = ["a single",
							"a solitary",
							"a lone",
							"an individual"];
					}
					else {
						options = ["single",
							"solitary",
							"lone",
							"individual"];
					}
					description += randomChoice(options);
				}
				else if (i_creature.balls == 2) {
					if (i_withArticle) {
						options = ["a pair of",
							"two",
							"a duo of"];
					}
					else {
						options = ["pair of",
							"two",
							"duo of"];
					}
					description += randomChoice(options);
				}
				else if (i_creature.balls == 3) {
					options = ["three",
						"triple"];
					(i_withArticle) ? options.push("a trio of") : options.push("trio of");
					description += randomChoice(options);
				}
				else if (i_creature.balls == 4) {
					options = ["four",
						"quadruple"];
					(i_withArticle) ? options.push("a quartette of") : options.push("quartette of");
					description += randomChoice(options);
				}
				else {
					if (i_withArticle) {
						options = ["a multitude of",
							"many",
							"a large handful of"];
					}
					else {
						options = ["multitude of",
							"many",
							"large handful of"];
					}
					description += randomChoice(options);
				}
			}
			//size!
			if (i_creature.ballSize > 1 && (rand(3) <= 1 || i_forcedSize)) {
				if (description) description += " ";

				if (i_creature.ballSize >= 18)
					description += "hideously swollen and oversized";
				else if (i_creature.ballSize >= 15)
					description += "beachball-sized";
				else if (i_creature.ballSize >= 12)
					description += "watermelon-sized";
				else if (i_creature.ballSize >= 9)
					description += "basketball-sized";
				else if (i_creature.ballSize >= 7)
					description += "soccerball-sized";
				else if (i_creature.ballSize >= 5)
					description += "cantaloupe-sized";
				else if (i_creature.ballSize >= 4)
					description += "grapefruit-sized";
				else if (i_creature.ballSize >= 3)
					description += "apple-sized";
				else if (i_creature.ballSize >= 2)
					description += "baseball-sized";
				else if (i_creature.ballSize > 1)
					description += "large";

			}
			//UNIBALL
			if (i_creature.findStatusAffect(StatusAffects.Uniball) >= 0) {
				if (description) description += " ";
				options = ["tightly-compressed",
					"snug",
					"cute",
					"pleasantly squeezed",
					"compressed-together"];
				description += randomChoice(options);

			}
			//Descriptive
			if (i_creature.hoursSinceCum >= 48 && rand(2) == 0 && !i_forcedSize) {
				if (description) description += " ";
				options = ["overflowing",
					"swollen",
					"cum-engorged"];
				description += randomChoice(options);

			}
			//lusty
			if (i_creature.lust > 90 && (description == "") && rand(2) == 0 && !i_forcedSize) {
				options = ["eager",
					"full",
					"needy",
					"desperate",
					"throbbing",
					"heated",
					"trembling",
					"quivering",
					"quaking"];
				description += randomChoice(options);

			}
			//Slimy skin
			if (i_creature.skinType == 3) {
				if (description) description += " ";
				options = ["goopey",
					"gooey",
					"slimy"];
				description += randomChoice(options);

			}
			if (description) description += " ";

			options = ["nut",
				"gonad",
				"teste",
				"testicle",
				"testicle",
				"ball",
				"ball",
				"ball"];

			// I don't know how this was ever supposed to work.
			//if (i_creature.balls == 4 && i_plural) options.push("quads", "quads", "quads");

			description += randomChoice(options);
			if (i_plural) description += "s";

			if (i_creature.findStatusAffect(StatusAffects.Uniball) >= 0 && rand(2) == 0) {
				if (rand(3) == 0)
					description += " merged into a cute, spherical package";
				else if (rand(2) == 0)
					description += " combined into a round, girlish shape";
				else
					description += " squeezed together into a perky, rounded form";
			}
			return description;
		}

		//Returns random description of scrotum
		public static function sackDescript(i_creature:Creature):String
		{
			if (i_creature.balls == 0) return "prostate";

			var options:Array;
			var description:String = "";

			options = ["scrotum",
				"sack",
				"nutsack",
				"ballsack",
				"beanbag",
				"pouch"];

			description += randomChoice(options);

			return description;
		}

		public static function sheathDescription(i_character:Character):String
		{
			if (i_character.hasSheath()) return "sheath";
			else return "base";
		}

		public static function vaginaDescript(i_creature:Creature, i_vaginaIndex:Number = 0):String
		{
			if (i_vaginaIndex > (i_creature.vaginas.length - 1)) {
				CoC_Settings.error("<B>Error: Invalid vagina number (" + i_vaginaIndex + ") passed to vaginaDescript()</b>");
				return "<B>Error: Invalid vagina number (" + i_vaginaIndex + ") passed to vaginaDescript()</b>";
			}
			if (i_vaginaIndex < 0) {
				CoC_Settings.error("<B>Error: Invalid vaginaNum (" + i_vaginaIndex + ") passed to vaginaDescript()</b>");
				return "<B>Error: Invalid vaginaNum (" + i_vaginaIndex + ") passed to vaginaDescript()</b>";
			}
			if (i_creature.vaginas.length <= 0) {
				CoC_Settings.error("ERROR: Called vaginaDescription with no vaginas");
				return "ERROR: Called vaginaDescription with no vaginas";
			}

			var description:String = "";
			var weighting:Number = 0;
			var haveDescription:Boolean = false;
			var options:Array;

			//Very confusing way to display values.
			if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 0) weighting = 61;
			if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 4 || i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 5) weighting = 10;

			//tightness descript - 40% display rate
			if (rand(100) + weighting > 60) {
				if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 0) {
					if (i_creature.vaginas[i_vaginaIndex].virgin) description += "virgin";
					else description += "tight";
				}
				if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 2)
					description += "loose";
				if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 3)
					description += "very loose";
				if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 4)
					description += "gaping";
				if (i_creature.vaginas[i_vaginaIndex].vaginalLooseness == 5)
					description += "gaping-wide";

			}
			//wetness descript - 30% display rate
			if (rand(100) + weighting > 70) {
				if (description != "") description += ", ";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 0)
					description += "dry";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 1)
					description += "moist";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 2)
					description += "wet";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 3)
					description += "slick";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 4)
					description += "drooling";
				if (i_creature.vaginas[i_vaginaIndex].vaginalWetness == 5)
					description += "slavering";
			}
			if (i_creature.vaginas[i_vaginaIndex].labiaPierced > 0 && rand(3) == 0) {
				if (description != "") description += ", ";
				description += "pierced";
			}
			if (description == "" && i_creature.skinType == 3) {
				if (description != "")
					description += ", ";
				if (rand(2) == 0)
					description += "gooey";
				else
					description += "slimy";
			}
			if (i_creature.vaginaType() == 5 && Math.floor(Math.random() * 2) == 0) {
				if (description != "") description += ", ";
				options = ["black",
					"onyx",
					"ebony",
					"dusky",
					"sable",
					"obsidian",
					"midnight-hued",
					"jet black"];
				description += randomChoice(options);
			}

			if (description != "")
				description += " ";
			options = ["vagina",
				"pussy",
				"cooter",
				"twat",
				"cunt",
				"snatch",
				"fuck-hole",
				"muff"];
			description += randomChoice(options);
			//Something that would be nice to have but needs a variable in Creature or Character.
			//if(i_creature.bunnyScore() >= 3) description += "rabbit hole";

			return description;
		}

		public static function clitDescription(i_creature:Creature):String
		{
			var description:String = "";
			var options:Array;
			var haveDescription:Boolean = false;
			//Length Adjective - 50% chance
			if (rand(2) == 0) {
				//small clits!
				if (i_creature.clitLength <= .5) {
					options = ["tiny ",
						"little ",
						"petite ",
						"diminutive ",
						"miniature "];
					description += randomChoice(options);
				}
				//"average".
				if (i_creature.clitLength > .5 && i_creature.clitLength < 1.5) {
					//no size comment
				}
				//Biggies!
				if (i_creature.clitLength >= 1.5 && i_creature.clitLength < 4) {
					options = ["large ",
						"large ",
						"substantial ",
						"substantial ",
						"considerable "];
					description += randomChoice(options);
				}
				//'Uge
				if (i_creature.clitLength >= 4) {
					options = ["monster ",
						"tremendous ",
						"colossal ",
						"enormous ",
						"bulky "];
					description += randomChoice(options);
				}
			}
			//Descriptive descriptions - 50% chance of being called
			if (rand(2) == 0) {
				//Doggie descriptors - 50%
				//TODO Conditionals don't make sense, need to introduce a class variable to keep of "something" or move race or Creature/Character
				if (i_creature.skinType == 1 > 2 && !haveDescription && rand(2) == 0) {
					description += "bitch-";
					haveDescription = true;
				}
				/*Horse descriptors - 50%
				 if(creature.skinType == 1 > 2 && !descripted && rand(2) == 0) {
				 descripted = true;
				 descript += "mare-";
				 }*/
				//Horny descriptors - 75% chance
				if (i_creature.lust > 70 && rand(4) < 3 && !haveDescription) {
					options = ["throbbing ",
						"pulsating ",
						"hard "];
					description += randomChoice(options);
					haveDescription = true;
				}
				//High libido - always use if no other descript
				if (i_creature.lib > 50 && rand(2) == 0 && !haveDescription) {
					options = ["insatiable ",
						"greedy ",
						"demanding ",
						"rapacious"];
					description += randomChoice(options);
					haveDescription = true;
				}
			}
			if (i_creature.hasVagina()) {
				if (!haveDescription && i_creature.vaginas[0].clitPierced > 0) {
					description += "pierced ";
					haveDescription = true;
				}
			}
			else {
				CoC_Settings.error("ERROR: CLITDESCRIPT WITH NO CLIT");
				return("ERROR: CLITDESCRIPT WITH NO CLIT");
			}

			//Clit nouns
			options = ["clit",
				"clitty",
				"button",
				"pleasure-buzzer",
				"clit",
				"clitty",
				"button",
				"clit",
				"clit",
				"button"];
			description += randomChoice(options);

			return description;
		}

		/**
		 * Gives a full description of a Character's butt.
		 * Be aware that it only supports Characters, not all Creatures.
		 * @param    i_character
		 * @return    A full description of a Character's butt.
		 */
		public static function buttDescription(i_character:Character):String
		{
			var description:String = "";
			var options:Array;
			if (i_character.buttRating <= 1) {
				if (i_character.tone >= 60)
					description += "incredibly tight, perky ";
				else {
					options = ["tiny",
						"very small",
						"dainty"];
					description = randomChoice(options);
					//Soft PC's buns!
					if (i_character.tone <= 30 && rand(3) == 0) description += " yet soft";
					description += " ";
				}
			}
			if (i_character.buttRating > 1 && i_character.buttRating < 4) {
				if (i_character.tone >= 65) {
					options = ["perky, muscular ",
						"tight, toned ",
						"compact, muscular ",
						"tight ",
						"muscular, toned "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["tight ",
						"firm ",
						"compact ",
						"petite "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["small, heart-shaped ",
						"soft, compact ",
						"soft, heart-shaped ",
						"small, cushy ",
						"small ",
						"petite ",
						"snug ", ];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 4 && i_character.buttRating < 6) {
				//TOIGHT LIKE A TIGER
				if (i_character.tone >= 65) {
					options = ["nicely muscled ",
						"nice, toned ",
						"muscly ",
						"nice toned ",
						"toned ",
						"fair "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["nice ",
						"fair "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["nice, cushiony ",
						"soft ",
						"nicely-rounded, heart-shaped ",
						"cushy ",
						"soft, squeezable "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 6 && i_character.buttRating < 8) {
				//TOIGHT LIKE A TIGER
				if (i_character.tone >= 65) {
					options = ["full, toned ",
								"muscly handful of ",
								"shapely, toned ",
								"muscular, hand-filling ",
								"shapely, chiseled ",
								"full ",
								"chiseled "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["handful of ",
						"full ",
						"shapely ",
						"hand-filling "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					if (rand(8) == 0) return "supple, handful of ass";
					options = ["somewhat jiggly ",
						"soft, hand-filling ",
						"cushiony, full ",
						"plush, shapely ",
						"full ",
						"soft, shapely ",
						"rounded, spongy "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 8 && i_character.buttRating < 10) {
				//TOIGHT LIKE A TIGER
				if (i_character.tone >= 65) {
					options = ["large, muscular ",
						"substantial, toned ",
						"big-but-tight ",
						"squeezable, toned ",
						"large, brawny ",
						"big-but-fit ",
						"powerful, squeezable ",
						"large "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["squeezable ",
						"large ",
						"substantial "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["large, bouncy ",
						"soft, eye-catching ",
						"big, slappable ",
						"soft, pinchable ",
						"large, plush ",
						"squeezable ",
						"cushiony ",
						"plush ",
						"pleasantly plump "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 10 && i_character.buttRating < 13) {
				//TOIGHT LIKE A TIGER
				if (i_character.tone >= 65) {
					options = ["thick, muscular ",
						"big, burly ",
						"heavy, powerful ",
						"spacious, muscular ",
						"toned, cloth-straining ",
						"thick ",
						"thick, strong "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["jiggling ",
						"spacious ",
						"heavy ",
						"cloth-straining "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["super-soft, jiggling ",
						"spacious, cushy ",
						"plush, cloth-straining ",
						"squeezable, over-sized ",
						"spacious ",
						"heavy, cushiony ",
						"slappable, thick ",
						"jiggling ",
						"spacious ",
						"soft, plump "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 13 && i_character.buttRating < 16) {
				//TOIGHT LIKE A TIGER
				if (i_character.tone >= 65) {
					options = ["expansive, muscled ",
						"voluminous, rippling ",
						"generous, powerful ",
						"big, burly ",
						"well-built, voluminous ",
						"powerful ",
						"muscular ",
						"powerful, expansive "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["expansive ",
						"generous ",
						"voluminous ",
						"wide "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["pillow-like ",
						"generous, cushiony ",
						"wide, plush ",
						"soft, generous ",
						"expansive, squeezable ",
						"slappable ",
						"thickly-padded ",
						"wide, jiggling ",
						"wide ",
						"voluminous ",
						"soft, padded "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 16 && i_character.buttRating < 20) {
				if (i_character.tone >= 65) {
					options = ["huge, toned ",
						"vast, muscular ",
						"vast, well-built ",
						"huge, muscular ",
						"strong, immense ",
						"muscle-bound "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					if (rand(5) == 0) return "jiggling expanse of ass";
					if (rand(5) == 0) return "copious ass-flesh";
					options = ["huge ",
						"vast ",
						"giant "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["vast, cushiony ",
						"huge, plump ",
						"expansive, jiggling ",
						"huge, cushiony ",
						"huge, slappable ",
						"seam-bursting ",
						"plush, vast ",
						"giant, slappable ",
						"giant ",
						"huge ",
						"swollen, pillow-like "];
					description = randomChoice(options);
				}
			}
			if (i_character.buttRating >= 20) {
				if (i_character.tone >= 65) {
					if (rand(7) == 0) return "colossal, muscly ass";
					options = ["ginormous, muscle-bound ",
						"colossal yet toned ",
						"strong, tremdously large ",
						"tremendous, muscled ",
						"ginormous, toned ",
						"colossal, well-defined "];
					description = randomChoice(options);
				}
				//Nondescript
				else if (i_character.tone >= 30) {
					options = ["ginormous ",
						"colossal ",
						"tremendous ",
						"gigantic "];
					description = randomChoice(options);
				}
				//FLABBAH
				else {
					options = ["ginormous, jiggly ",
						"plush, ginormous ",
						"seam-destroying ",
						"tremendous, rounded ",
						"bouncy, colossal ",
						"thong-devouring ",
						"tremendous, thickly padded ",
						"ginormous, slappable ",
						"gigantic, rippling ",
						"gigantic ",
						"ginormous ",
						"colossal ",
						"tremendous "];
					description = randomChoice(options);
				}
			}
			options = ["butt",
						"butt",
						"butt",
						"butt",
						"ass",
						"ass",
						"ass",
						"ass",
						"backside",
						"backside",
						"derriere",
						"rump",
						"bottom"];
			
			description += randomChoice(options);
			//if(rando == 2) desc += "cheeks";
			return description;
		}

		/**
		 * Gives a short description of a creature's butt.
		 * Different from buttDescription in that it supports all creatures, not just characters.
		 * Warning, very judgemental.
		 * @param    creature
		 * @return Short description of a butt.
		 */
		public static function buttDescriptionShort(i_creature:Creature):String
		{
			var description:String = "";
			var options:Array;
			if (i_creature.buttRating <= 1) {
				options = ["insignificant ",
					"very small "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating > 1 && i_creature.buttRating < 4) {
				options = ["tight ",
					"firm ",
					"compact "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 4 && i_creature.buttRating < 6) {
				options = ["regular ",
					"unremarkable "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 6 && i_creature.buttRating < 8) {
				if (rand(3) == 0) return "handful of ass";
				options = ["full ",
					"shapely "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 8 && i_creature.buttRating < 10) {
				options = ["squeezable ",
					"large ",
					"substantial "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 10 && i_creature.buttRating < 13) {
				options = ["jiggling ",
					"spacious ",
					"heavy "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 13 && i_creature.buttRating < 16) {
				if (rand(3) == 0) return "generous amount of ass";
				options = ["expansive ",
					"voluminous "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 16 && i_creature.buttRating < 20) {
				if (rand(3) == 2) return "jiggling expanse of ass";
				options = ["huge ",
					"vast "];
				description = randomChoice(options);
			}
			if (i_creature.buttRating >= 20) {
				options = ["ginormous ",
					"colossal ",
					"tremendous "];
				description = randomChoice(options);
			}
			options = ["butt ",
				"ass "];
			description += randomChoice(options);
			if (rand(2) == 0) description += "cheeks";
			return description;
		}

		public static function assholeDescript(i_creature:Creature):String
		{
			var description:String = "";
			
			// The way this was setup didn't work. Trying to inline-define object key-values wasn't looking up the variable *VALUES* it was using the string representation
			// of the variable name as the key.
			// ie, querying ANAL_WETNESS_DESCRIPTORS[0] would actually return "undefined" rather than "".
			// This is just fucking awful but I'm just making things work in the face of bugs I'm running into.
			
			// 66% Wetness Descript
			var ANAL_WETNESS_DESCRIPTORS:Object = new Object(); 
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_DRY] = "";
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_NORMAL] = "";
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_MOIST] = "moist ";
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_SLIMY] = "slimy ";
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_DROOLING] = "drooling ";
			ANAL_WETNESS_DESCRIPTORS[ANAL_WETNESS_SLIME_DROOLING] = "slime-drooling ";
			
			if (rand(3) <= 1)
			{
				description += ANAL_WETNESS_DESCRIPTORS[i_creature.ass.analWetness];
			}
			
			var ANAL_TIGHTNESS_DESCRIPTORS:Object = new Object();
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_VIRGIN] = "virgin ";
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_TIGHT] = "tight ";
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_NORMAL] = "loose ";
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_LOOSE] = "roomy ";
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_STRETCHED] = "stretched ";
			ANAL_TIGHTNESS_DESCRIPTORS[ANAL_LOOSENESS_GAPING] = "gaping ";
			
			//25% tightness description
			if (rand(4) == 0 || (i_creature.ass.analLooseness <= 1 && rand(4) <= 2)) 
			{
				description += ANAL_TIGHTNESS_DESCRIPTORS[i_creature.ass.analLooseness];
			}
			
			//asshole descriptor
			description += randomChoice("ass",
					"anus",
					"pucker",
					"backdoor",
					"asshole",
					"butthole");

			return description;
		}

		private static function humanDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.HUMAN);
			return descript;
		}

		private static function kangaDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.KANGAROO);
			return descript;
		}

		public static function dogDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.DOG);
			return descript;
		}

		private static function foxDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.FOX);
			return descript;
		}

		private static function tentacleDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.TENTACLE);
			return descript;
		}

		private static function demonDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.DEMON);
			return descript;
		}


		//Horsecock + Descript
		public static function horseDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.HORSE);
			return descript;
		}

		private static function catDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.CAT);
			return descript;
		}

		private static function anemoneDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.ANEMONE);
			return descript;
		}

		private static function dragonDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.DRAGON);
			return descript;
		}

		private static function displacerDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.DISPLACER);
			return descript;
		}


		private static function snakeDescript(cockNum:Number):String
		{
			var descript:String = "";
			//if(rand(2) == 0) descript += cockAdjective(cockNum) + ", ";
			descript += cockNoun(CockTypesEnum.LIZARD);
			return descript;
		}

		public static const BREAST_CUP_NAMES:Array = [
			"flat, manly breast",//0
			//				1			2			3			4			5				6			7		8			9
			"A-cup", "B-cup", "C-cup", "D-cup", "DD-cup", "big DD-cup", "E-cup", "big E-cup", "EE-cup",// 1-9
			"big EE-cup", "F-cup", "big F-cup", "FF-cup", "big FF-cup", "G-cup", "big G-cup", "GG-cup", "big GG-cup", "H-cup",//10-19
			"big H-cup", "HH-cup", "big HH-cup", "HHH-cup", "I-cup", "big I-cup", "II-cup", "big II-cup", "J-cup", "big J-cup",//20-29
			"JJ-cup", "big JJ-cup", "K-cup", "big K-cup", "KK-cup", "big KK-cup", "L-cup", "big L-cup", "LL-cup", "big LL-cup",//30-39
			"M-cup", "big M-cup", "MM-cup", "big MM-cup", "MMM-cup", "large MMM-cup", "N-cup", "large N-cup", "NN-cup", "large NN-cup",//40-49
			"O-cup", "large O-cup", "OO-cup", "large OO-cup", "P-cup", "large P-cup", "PP-cup", "large PP-cup", "Q-cup", "large Q-cup",//50-59
			"QQ-cup", "large QQ-cup", "R-cup", "large R-cup", "RR-cup", "large RR-cup", "S-cup", "large S-cup", "SS-cup", "large SS-cup",//60-69
			"T-cup", "large T-cup", "TT-cup", "large TT-cup", "U-cup", "large U-cup", "UU-cup", "large UU-cup", "V-cup", "large V-cup",//70-79
			"VV-cup", "large VV-cup", "W-cup", "large W-cup", "WW-cup", "large WW-cup", "X-cup", "large X-cup", "XX-cup", "large XX-cup",//80-89
			"Y-cup", "large Y-cup", "YY-cup", "large YY-cup", "Z-cup", "large Z-cup", "ZZ-cup", "large ZZ-cup", "ZZZ-cup", "large ZZZ-cup"//90-99
		];

		public static function breastCup(size:Number):String
		{
			return BREAST_CUP_NAMES[Math.floor(size)] || BREAST_CUP_NAMES[BREAST_CUP_NAMES.length - 1];
		}

		/**
		 * Returns breast size from cup name.
		 * Acceptable input: "flat","A","B","C","D","DD","DD+",... "ZZZ","ZZZ+" or exact match from BREAST_CUP_NAMES array
		 */
		public static function breastCupInverse(name:String, defaultValue:Number = 0):Number
		{
			if (name.length == 0) return defaultValue;
			if (name == "flat") return 0;
			var big:Boolean = name.charAt(name.length - 1) == "+";
			if (big) name = name.substr(0, name.length - 1);
			for (var i:int = 0; i < BREAST_CUP_NAMES.length; i++) {
				if (name == BREAST_CUP_NAMES[i]) return i;
				if (BREAST_CUP_NAMES[i].indexOf(name) == 0) return i + (big ? 1 : 0);
			}
			return defaultValue;
		}

		public static function createMapFromPairs(src:Array):Object
		{
			var result:Object = {};
			for (var i:int = 0; i < src.length; i++) result[src[i][0]] = src[i][1];
			return result;
		}

		public static const DEFAULT_GENDER_NAMES:Object = createMapFromPairs(
				[
					[GENDER_NONE, "genderless"],
					[GENDER_MALE, "male"],
					[GENDER_FEMALE, "female"],
					[GENDER_HERM, "hermaphrodite"]
				]
		);
		public static const DEFAULT_SKIN_NAMES:Object = createMapFromPairs(
				[
					[SKIN_TYPE_PLAIN, "skin"],
					[SKIN_TYPE_FUR, "fur"],
					[SKIN_TYPE_SCALES, "scales"],
					[SKIN_TYPE_GOO, "goo"],
					[SKIN_TYPE_UNDEFINED, "undefined flesh"]
				]
		);
		public static const DEFAULT_SKIN_DESCS:Object = createMapFromPairs(
				[
					[SKIN_TYPE_PLAIN, "skin"],
					[SKIN_TYPE_FUR, "fur"],
					[SKIN_TYPE_SCALES, "scales"],
					[SKIN_TYPE_GOO, "skin"],
					[SKIN_TYPE_UNDEFINED, "skin"]
				]
		);
		public static const DEFAULT_HAIR_NAMES:Object = createMapFromPairs(
				[
					[HAIR_NORMAL, "normal"],
					[HAIR_FEATHER, "feather"],
					[HAIR_GHOST, "transparent"],
					[HAIR_GOO, "goopy"],
					[HAIR_ANEMONE, "tentacle"]
				]
		);
		public static const DEFAULT_FACE_NAMES:Object = createMapFromPairs(
				[
					[FACE_HUMAN, "human"],
					[FACE_HORSE, "horse"],
					[FACE_DOG, "dog"],
					[FACE_COW_MINOTAUR, "cow"],
					[FACE_SHARK_TEETH, "shark"],
					[FACE_SNAKE_FANGS, "snake"],
					[FACE_CAT, "cat"],
					[FACE_LIZARD, "lizard"],
					[FACE_BUNNY, "bunny"],
					[FACE_KANGAROO, "kangaroo"],
					[FACE_SPIDER_FANGS, "spider"],
					[FACE_FOX, "fox"],
					[FACE_DRAGON, "dragon"],
					[FACE_RACCOON_MASK, "raccoon mask"],
					[FACE_RACCOON, "racoon"],
					[FACE_BUCKTEETH, "buckteeth"],
					[FACE_MOUSE, "mouse"]
				]
		);
		public static const DEFAULT_TONGUE_NAMES:Object = createMapFromPairs(
				[
					[TONUGE_HUMAN, "human"],
					[TONUGE_SNAKE, "snake"],
					[TONUGE_DEMONIC, "demonic"],
					[TONUGE_DRACONIC, "draconic"]
				]
		);
		public static const DEFAULT_EYES_NAMES:Object = createMapFromPairs(
				[
					[EYES_HUMAN, "human"],
					[EYES_FOUR_SPIDER_EYES, "4 spider"],
					[EYES_BLACK_EYES_SAND_TRAP, "sandtrap black"]
				]
		);
		public static const DEFAULT_EARS_NAMES:Object = createMapFromPairs(
				[
					[EARS_HUMAN, "human"],
					[EARS_HORSE, "horse"],
					[EARS_DOG, "dog"],
					[EARS_COW, "cow"],
					[EARS_ELFIN, "elfin"],
					[EARS_CAT, "cat"],
					[EARS_LIZARD, "lizard"],
					[EARS_BUNNY, "bunny"],
					[EARS_KANGAROO, "kangaroo"],
					[EARS_FOX, "fox"],
					[EARS_DRAGON, "dragon"],
					[EARS_RACCOON, "raccoon"],
					[EARS_MOUSE, "mouse"]
				]
		);
		public static const DEFAULT_HORNS_NAMES:Object = createMapFromPairs(
				[
					[HORNS_NONE, "non-existant"],
					[HORNS_DEMON, "demon"],
					[HORNS_COW_MINOTAUR, "cow"],
					[HORNS_DRACONIC_X2, "2 draconic"],
					[HORNS_DRACONIC_X4_12_INCH_LONG, "four 12\" long draconic"],
					[HORNS_ANTLERS, "deer"]
				]
		);
		public static const DEFAULT_ANTENNAE_NAMES:Object = createMapFromPairs(
				[
					[ANTENNAE_NONE, "non-existant"],
					[ANTENNAE_BEE, "bee"]
				]
		);
		public static const DEFAULT_ARM_NAMES:Object = createMapFromPairs(
				[
					[ARM_TYPE_HUMAN, "human"],
					[ARM_TYPE_HARPY, "harpy"],
					[ARM_TYPE_SPIDER, "spider"]
				]
		);
		public static const DEFAULT_TAIL_NAMES:Object = createMapFromPairs(
				[
					[TAIL_TYPE_NONE, "non-existant"],
					[TAIL_TYPE_HORSE, "horse"],
					[TAIL_TYPE_DOG, "dog"],
					[TAIL_TYPE_DEMONIC, "demonic"],
					[TAIL_TYPE_COW, "cow"],
					[TAIL_TYPE_SPIDER_ADBOMEN, "spider abdomen"],
					[TAIL_TYPE_BEE_ABDOMEN, "bee abdomen"],
					[TAIL_TYPE_SHARK, "shark"],
					[TAIL_TYPE_CAT, "cat"],
					[TAIL_TYPE_LIZARD, "lizard"],
					[TAIL_TYPE_RABBIT, "rabbit"],
					[TAIL_TYPE_HARPY, "harpy"],
					[TAIL_TYPE_KANGAROO, "kangaroo"],
					[TAIL_TYPE_FOX, "fox"],
					[TAIL_TYPE_DRACONIC, "draconic"],
					[TAIL_TYPE_RACCOON, "raccoon"],
					[TAIL_TYPE_MOUSE, "mouse"]
				]
		);
		public static const DEFAULT_WING_NAMES:Object = createMapFromPairs(
				[
					[WING_TYPE_NONE, "non-existant"],
					[WING_TYPE_BEE_LIKE_SMALL, "small bee-like"],
					[WING_TYPE_BEE_LIKE_LARGE, "large bee-like"],
					[WING_TYPE_HARPY, "harpy"],
					[WING_TYPE_IMP, "imp"],
					[WING_TYPE_BAT_LIKE_TINY, "tiny bat-like"],
					[WING_TYPE_BAT_LIKE_LARGE, "large bat-like"],
					[WING_TYPE_SHARK_FIN, "shark fin"],
					[WING_TYPE_FEATHERED_LARGE, "large feathered"],
					[WING_TYPE_DRACONIC_SMALL, "small draconic"],
					[WING_TYPE_DRACONIC_LARGE, "large draconic"],
					[WING_TYPE_GIANT_DRAGONFLY, "giant dragonfly"]
				]
		);
		public static const DEFAULT_WING_DESCS:Object = createMapFromPairs(
				[
					[WING_TYPE_NONE, "non-existant"],
					[WING_TYPE_BEE_LIKE_SMALL, "small bee-like"],
					[WING_TYPE_BEE_LIKE_LARGE, "large bee-like"],
					[WING_TYPE_HARPY, "large feathery"],
					[WING_TYPE_IMP, "small"],
					[WING_TYPE_BAT_LIKE_TINY, "tiny, bat-like"],
					[WING_TYPE_BAT_LIKE_LARGE, "large, bat-like"],
					[WING_TYPE_SHARK_FIN, ""],
					[WING_TYPE_FEATHERED_LARGE, "large, feathered"],
					[WING_TYPE_DRACONIC_SMALL, "small, draconic"],
					[WING_TYPE_DRACONIC_LARGE, "large, draconic"],
					[WING_TYPE_GIANT_DRAGONFLY, "giant dragonfly"]
				]
		);
		public static const DEFAULT_LOWER_BODY_NAMES:Object = createMapFromPairs(
				[
					[LOWER_BODY_TYPE_HUMAN, "human"],
					[LOWER_BODY_TYPE_HOOFED, "hoofed"],
					[LOWER_BODY_TYPE_DOG, "dog"],
					[LOWER_BODY_TYPE_NAGA, "naga"],
					[LOWER_BODY_TYPE_CENTAUR, "centaur"],
					[LOWER_BODY_TYPE_DEMONIC_HIGH_HEELS, "demonic high-heels"],
					[LOWER_BODY_TYPE_DEMONIC_CLAWS, "demonic claws"],
					[LOWER_BODY_TYPE_BEE, "bee"],
					[LOWER_BODY_TYPE_GOO, "goo"],
					[LOWER_BODY_TYPE_CAT, "cat"],
					[LOWER_BODY_TYPE_LIZARD, "lizard"],
					[LOWER_BODY_TYPE_PONY, "pony"],
					[LOWER_BODY_TYPE_BUNNY, "bunny"],
					[LOWER_BODY_TYPE_HARPY, "harpy"],
					[LOWER_BODY_TYPE_KANGAROO, "kangaroo"],
					[LOWER_BODY_TYPE_CHITINOUS_SPIDER_LEGS, "chitinous spider legs"],
					[LOWER_BODY_TYPE_DRIDER_LOWER_BODY, "drider"],
					[LOWER_BODY_TYPE_FOX, "fox"],
					[LOWER_BODY_TYPE_DRAGON, "dragon"],
					[LOWER_BODY_TYPE_RACCOON, "raccoon"]
				]
		);
		public static const DEFAULT_PIERCING_NAMES:Object = createMapFromPairs(
				[
					[PIERCING_TYPE_NONE, "none"],
					[PIERCING_TYPE_STUD, "stud"],
					[PIERCING_TYPE_RING, "ring"],
					[PIERCING_TYPE_LADDER, "ladder"],
					[PIERCING_TYPE_HOOP, "hoop"],
					[PIERCING_TYPE_CHAIN, "chain"]
				]
		);
		public static const DEFAULT_VAGINA_TYPE_NAMES:Object = createMapFromPairs(
				[
					[VAGINA_TYPE_HUMAN, "human"],
					[VAGINA_TYPE_BLACK_SAND_TRAP, "black sandtrap"]
				]
		);
		public static const DEFAULT_VAGINA_WETNESS_SCALES:Array = [
			[VAGINA_WETNESS_DRY, "dry"],
			[VAGINA_WETNESS_NORMAL, "normal"],
			[VAGINA_WETNESS_WET, "wet"],
			[VAGINA_WETNESS_SLICK, "slick"],
			[VAGINA_WETNESS_DROOLING, "drooling"],
			[VAGINA_WETNESS_SLAVERING, "slavering"],
		];
		public static const DEFAULT_VAGINA_LOOSENESS_SCALES:Array = [
			[VAGINA_LOOSENESS_TIGHT, "tight"],
			[VAGINA_LOOSENESS_NORMAL, "normal"],
			[VAGINA_LOOSENESS_LOOSE, "loose"],
			[VAGINA_LOOSENESS_GAPING, "gaping"],
			[VAGINA_LOOSENESS_GAPING_WIDE, "gaping wide"],
			[VAGINA_LOOSENESS_LEVEL_CLOWN_CAR, "clown-car level"]
		];
		public static const DEFAULT_ANAL_WETNESS_SCALES:Array = [
			[ANAL_WETNESS_DRY, "dry"],
			[ANAL_WETNESS_NORMAL, "normal"],
			[ANAL_WETNESS_MOIST, "moist"],
			[ANAL_WETNESS_SLIMY, "slimym"],
			[ANAL_WETNESS_DROOLING, "drooling"],
			[ANAL_WETNESS_SLIME_DROOLING, "slime-drooling"],
		];
		public static const DEFAULT_ANAL_LOOSENESS_SCALES:Array = [
			[ANAL_LOOSENESS_VIRGIN, "virgin"],
			[ANAL_LOOSENESS_TIGHT, "tight"],
			[ANAL_LOOSENESS_NORMAL, "normal"],
			[ANAL_LOOSENESS_LOOSE, "loose"],
			[ANAL_LOOSENESS_STRETCHED, "stretched"],
			[ANAL_LOOSENESS_GAPING, "gaping"]
		];
		public static const DEFAULT_HIP_RATING_SCALES:Array = [
			[HIP_RATING_BOYISH, "boyish"],
			[HIP_RATING_SLENDER, "slender"],
			[HIP_RATING_AVERAGE, "average"],
			[HIP_RATING_AMPLE, "ample"],
			[HIP_RATING_CURVY, "curvy"],
			[HIP_RATING_FERTILE, "fertile"],
			[HIP_RATING_INHUMANLY_WIDE, "inhumanly wide"]
		];
		public static const DEFAULT_BUTT_RATING_SCALES:Array = [
			[BUTT_RATING_BUTTLESS, "buttless"],
			[BUTT_RATING_TIGHT, "tight"],
			[BUTT_RATING_AVERAGE, "average"],
			[BUTT_RATING_NOTICEABLE, "noticeable"],
			[BUTT_RATING_LARGE, "large"],
			[BUTT_RATING_JIGGLY, "jiggly"],
			[BUTT_RATING_EXPANSIVE, "expansive"],
			[BUTT_RATING_HUGE, "huge"],
			[BUTT_RATING_INCONCEIVABLY_BIG, "inconceivably big"]
		];

		/**
		 * Assume scale = [[0,"small"],[5,"average"],[10,"big"]]
		 *      value < 0   ->   "less than small"
		 *      value = 0   ->   "small"
		 *  0 < value < 5   ->   "between small and average"
		 *      value = 5   ->   "average"
		 *  5 < value < 10  ->   "between average and big"
		 *      value = 10  ->   "big"
		 *      value > 10  ->   "more than big"
		 */
		public static function describeByScale(value:Number, scale:Array, lessThan:String = "less than", moreThan:String = "more than"):String
		{
			if (scale.length == 0) return "undescribeale";
			if (scale.length == 1) return "about " + scale[0][1];
			if (value < scale[0][0]) return lessThan + " " + scale[0][1];
			if (value == scale[0][0]) return scale[0][1];
			for (var i:int = 1; i < scale.length; i++) {
				if (value < scale[i][0]) return "between " + scale[i - 1][1] + " and " + scale[i][1];
				if (value == scale[i][0]) return scale[i][1];
			}
			return moreThan + " " + scale[scale.length - 1][1];
		}

		/**
		 * numberOfThings(0,"brain") = "no brains"
		 * numberOfThings(1,"head") = "one head"
		 * numberOfThings(2,"tail") = "2 tails"
		 * numberOfThings(3,"hoof","hooves") = "3 hooves"
		 */
		public static function numberOfThings(n:int, name:String, pluralForm:String = null):String
		{
			pluralForm = pluralForm || (name + "s");
			if (n == 0) return "no " + pluralForm;
			if (n == 1) return "one " + name;
			return n + " " + pluralForm;
		}

		/**
		 * 13 -> 2'1"
		 * 5.5 -> 5.5"
		 * Positive only!
		 */
		public static function feetsAndInches(n:Number):String
		{
			var feet:int = Math.floor(n / 12);
			var inches:Number = n - feet * 12;
			if (feet > 0) return feet + "'" + inches + "\"";
			else return inches + "\"";
		}

		/**
		 * 13 -> 13" (2'1")
		 */
		public static function inchesAndFeetsAndInches(n:Number):String
		{
			if (n < 12) return n + "\"";
			return n + "\" (" + feetsAndInches(n) + ")";
		}

		public static function allBreastsDescript(creature:Creature):String
		{
			var storage:String = "";
			if (creature.breastRows.length == 0) return "unremarkable chest muscles ";
			if (creature.breastRows.length == 2) {
				//if(creature.totalBreasts() == 4) storage += "quartet of ";
				storage += "two rows of ";
			}
			if (creature.breastRows.length == 3) {
				if (rand(2) == 0) storage += "three rows of ";
				else storage += "multi-layered ";
			}
			if (creature.breastRows.length == 4) {
				if (rand(2) == 0) storage += "four rows of ";
				else storage += "four-tiered ";
			}
			if (creature.breastRows.length == 5) {
				if (rand(2) == 0) storage += "five rows of ";
				else storage += "five-tiered ";
			}
			storage += biggestBreastSizeDescript(creature);
			return storage;

		}

		public static function biggestBreastSizeDescript(creature:Creature):String
		{
			var temp14:int = Math.random() * 3;
			var descript:String = "";
			var temp142:int = creature.biggestTitRow();
			//ERROR PREVENTION
			if (creature.breastRows.length - 1 < temp142) {
				CoC_Settings.error("");
				return "<b>ERROR, biggestBreastSizeDescript() working with invalid breastRow</b>";
			}
			else if (temp142 < 0) {
				CoC_Settings.error("");
				return "ERROR SHIT SON!  BIGGESTBREASTSIZEDESCRIPT PASSED NEGATIVE!";
			}
			if (creature.breastRows[temp142].breastRating < 1) return "flat breasts";
			//50% of the time size-descript them
			if (rand(2) == 0) descript += breastSize(creature.breastRows[temp142].breastRating);
			//Nouns!
			temp14 = rand(10);
			if (temp14 == 0) descript += "breasts";
			if (temp14 == 1) {
				if (creature.breastRows[temp142].lactationMultiplier > 2) descript += "milk-udders";
				else descript += "breasts";
			}
			if (temp14 == 2) {
				if (creature.breastRows[temp142].lactationMultiplier > 1.5) descript += "milky ";
				if (creature.breastRows[temp142].breastRating > 4) descript += "tits";
				else descript += "breasts";
			}
			if (temp14 == 3) {
				//if(creature.breastRows[temp142].breastRating > 6) descript += "rack";
				descript += "breasts";
			}
			if (temp14 == 4) descript += "tits";
			if (temp14 == 5) descript += "tits";
			if (temp14 == 6) descript += "tits";
			if (temp14 == 7) {
				if (creature.breastRows[temp142].lactationMultiplier >= 1 && creature.breastRows[temp142].lactationMultiplier < 2.5) descript += "milk jugs";
				if (creature.breastRows[temp142].lactationMultiplier >= 2.5) descript += "udders";
				if (creature.breastRows[temp142].lactationMultiplier < 1) descript += "jugs";
			}
			if (temp14 == 8) {
				if (creature.breastRows[temp142].breastRating > 6) descript += "love-pillows";
				else descript += "boobs";
			}
			if (temp14 == 9) {
				if (creature.breastRows[temp142].breastRating > 6) descript += "tits";
				else descript += "breasts";
			}
			return descript;
		}

		public static function breastSize(val:Number):String
		{
			var descript:String = "";
			//Catch all for dudes.
			if (val < 1) return "manly ";
			//Small - A->B
			if (val <= 2) {
				descript += randomChoice("palmable ", "tight ", "perky ", "baseball-sized ");
			}
			//C-D
			else if (val <= 4) {
				descript += randomChoice("nice ", "hand-filling ", "well-rounded ", "supple ", "softball-sized ");
			}
			//DD->big EE
			else if (val < 11) {
				descript += randomChoice("big ", "large ", "pillowy ", "jiggly ", "volleyball-sized ");
			}
			//F->big FF
			else if (val < 15) {
				descript += randomChoice("soccerball-sized ", "hand-overflowing ", "generous ", "jiggling ");
			}
			//G -> HHH
			else if (val < 24) {
				descript += randomChoice("basketball-sized ", "whorish ", "cushiony ", "wobbling ");
			}
			//I -> KK
			else if (val < 35) {
				descript += randomChoice("massive motherly ", "luscious ", "smothering ", "prodigious ");
			}
			//K- > MMM+
			else {
				descript += randomChoice("mountainous ", "monumental ", "back-breaking ", "exercise-ball-sized ", "immense ");
			}
			return descript;
		}

		public static function chestDesc(creature:Creature):String
		{
			if (creature.biggestTitSize() < 1) return "chest";
			else return biggestBreastSizeDescript(creature);
		}

		public static function assholeOrPussy(creature:Creature):String
		{
			if (creature.hasVagina()) return vaginaDescript(creature, 0);
			return assholeDescript(creature);
		}


		public static function multiCockDescriptLight(creature:Creature):String
		{
			if (creature.cocks.length < 1) {

				CoC_Settings.error("");
				return "<B>Error: multiCockDescriptLight() called with no penises present.</B>";

			}
			//Get cock counts
			var descript:String = "";
			var currCock:Number = 0;
			var totCock:Number = creature.cocks.length;
			var dogCocks:Number = 0;
			var horseCocks:Number = 0;
			var normalCocks:Number = 0;
			var normalCockKey:Number = 0;
			var dogCockKey:Number = 0;
			var horseCockKey:Number = 0;
			var averageLength:Number = 0;
			var averageThickness:Number = 0;
			var same:Boolean = true;
			//For temp14 random values
			var rando:Number = 0;
			var descripted:Boolean = false;
			//If one, return normal cock descript
			if (totCock == 1) return creature.cockDescript(0);
			//Count cocks & Prep average totals
			while (currCock <= totCock - 1) {
				if (creature.cocks[currCock].cockType == CockTypesEnum.HUMAN) {
					normalCocks++;
					normalCockKey = currCock;
				}
				if (creature.cocks[currCock].cockType == CockTypesEnum.HORSE) {
					horseCocks++;
					horseCockKey = currCock;
				}
				if (creature.cocks[currCock].cockType == CockTypesEnum.DOG) {
					dogCocks++;
					dogCockKey = currCock;
				}
				averageLength += creature.cocks[currCock].cockLength;
				averageThickness += creature.cocks[currCock].cockThickness;
				//If cocks are matched make sure they still are
				if (same && currCock > 0 && creature.cocks[currCock].cockType != creature.cocks[currCock - 1].cockType) same = false;
				currCock++;
			}
			//Crunch averages
			averageLength /= currCock;
			averageThickness /= currCock;
			//Quantity descriptors
			if (creature.cockTotal() == 1) {
				if (dogCocks == 1) return dogDescript(0);
				if (horseCocks == 1) return horseDescript(0);
				if (normalCocks == 1) return creature.cockDescript(0);
				//Failsafe
				return creature.cockDescript(0);
			}
			if (currCock == 2) {
				//For cocks that are the same
				if (same) {
					descript += randomChoice("pair of ", "two ", "brace of ", "matching ", "twin ");
					descript += cockAdjective(creature);
					if (normalCocks == 2) descript += " " + Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
					if (horseCocks == 2) descript += ", " + Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
					if (dogCocks == 2) descript += ", " + Appearance.cockNoun(CockTypesEnum.DOG) + "s";
					//Failsafe
					if (creature.cocks[0].cockType.Index > 2) descript += ", " + Appearance.cockNoun(creature.cocks[0].cockType) + "s";
				}
				//Nonidentical
				else {
					descript += randomChoice("pair of ", "two ", "brace of ");
					descript += cockAdjective(creature) + ", ";
					descript += randomChoice("mutated cocks", "mutated dicks", "mixed cocks", "mismatched dicks");
				}
			}
			if (currCock == 3) {
				//For samecocks
				if (same) {
					descript += randomChoice("three ", "group of ", "menage a trois of ", "triad of ", "triumvirate of ");
					descript += cockAdjective(creature);
					if (normalCocks == 3) descript += " " + Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
					if (horseCocks == 3) descript += ", " + Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
					if (dogCocks == 3) descript += ", " + Appearance.cockNoun(CockTypesEnum.DOG) + "s";
					//Tentacles
					if (creature.cocks[0].cockType.Index > 2) descript += ", " + Appearance.cockNoun(creature.cocks[0].cockType) + "s";
				}
				else {
					descript += randomChoice("three ", "group of ");
					descript += cockAdjective(creature) + ", ";
					descript += randomChoice("mutated cocks", "mutated dicks", "mixed cocks", "mismatched dicks");
				}
			}
			//Large numbers of cocks!
			if (currCock > 3) {
				descript += randomChoice("bundle of ", "obscene group of ", "cluster of ", "wriggling bunch of ");
				//Cock adjectives and nouns
				descripted = false;
				//Same
				if (same) {
					if (currCock == normalCocks) {
						descript += cockAdjective(creature) + " ";
						descript += Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
						descripted = true;
					}
					if (currCock == dogCocks) {
						descript += cockAdjective(creature) + ", ";
						descript += Appearance.cockNoun(CockTypesEnum.DOG) + "s";
						descripted = true;
					}
					if (currCock == horseCocks) {
						descript += cockAdjective(creature) + ", ";
						descript += Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
						descripted = true;
					}
					if (creature.cocks[0].cockType.Index > 2) {
						descript += cockAdjective(creature) + ", ";
						descript += Appearance.cockNoun(creature.cocks[0].cockType) + "s";
						descripted = true;
					}
				}
				//If mixed
				if (!descripted) {
					descript += cockAdjective(creature) + ", ";
					descript += randomChoice("mutated cocks", "mutated dicks", "mixed cocks", "mismatched dicks");
				}
			}
			return descript;
		}

		public static function multiCockDescript(creature:Creature):String
		{
			if (creature.cocks.length < 1) {
				CoC_Settings.error("");
				return "<B>Error: multiCockDescript() called with no penises present.</B>";
			}
			//Get cock counts
			var descript:String = "";
			var currCock:Number = 0;
			var totCock:Number = creature.cocks.length;
			var dogCocks:Number = 0;
			var horseCocks:Number = 0;
			var normalCocks:Number = 0;
			var normalCockKey:Number = 0;
			var dogCockKey:Number = 0;
			var horseCockKey:Number = 0;
			var averageLength:Number = 0;
			var averageThickness:Number = 0;
			var same:Boolean = true;
			//For temp14 random values
			var rando:Number = 0;
			var descripted:Boolean = false;
			//Count cocks & Prep average totals
			while (currCock <= totCock - 1) {
				//trace("Counting cocks!");
				if (creature.cocks[currCock].cockType == CockTypesEnum.HUMAN) {
					normalCocks++;
					normalCockKey = currCock;
				}
				if (creature.cocks[currCock].cockType == CockTypesEnum.HORSE) {
					horseCocks++;
					horseCockKey = currCock;
				}
				if (creature.cocks[currCock].cockType == CockTypesEnum.DOG) {
					dogCocks++;
					dogCockKey = currCock;
				}
				averageLength += creature.cocks[currCock].cockLength;
				averageThickness += creature.cocks[currCock].cockThickness;
				//If cocks are matched make sure they still are
				if (same && currCock > 0 && creature.cocks[currCock].cockType != creature.cocks[currCock - 1].cockType) same = false;
				currCock++;
			}
			//Crunch averages
			averageLength /= currCock;
			averageThickness /= currCock;
			//Quantity descriptors
			if (currCock == 1) {
				if (dogCocks == 1) return dogDescript(0);
				if (horseCocks == 1) return horseDescript(0);
				if (normalCocks == 1) return cockDescript(creature,0);
				//Catch-all for when I add more cocks.  Let cock descript do the sorting.
				if (creature.cocks.length == 1) return cockDescript(creature,0);
			}
			if (currCock == 2) {
				//For cocks that are the same
				if (same) {
					descript += randomChoice("a pair of ", "two ", "a brace of ", "matching ", "twin ");
					descript += Appearance.cockAdjectives(averageLength, averageThickness, creature.cocks[0].cockType, creature);
					if (normalCocks == 2) descript += " " + Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
					if (horseCocks == 2) descript += ", " + Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
					if (dogCocks == 2) descript += ", " + Appearance.cockNoun(CockTypesEnum.DOG) + "s";
					//Tentacles
					if (creature.cocks[0].cockType.Index > 2)
						descript += ", " + Appearance.cockNoun(creature.cocks[0].cockType) + "s";
				}
				//Nonidentical
				else {
					descript += randomChoice("a pair of ", "two ", "a brace of ");
					descript += Appearance.cockAdjectives(averageLength, averageThickness, creature.cocks[0].cockType, creature) + ", ";
					descript += randomChoice("mutated cocks", "mutated dicks", "mixed cocks", "mismatched dicks");
				}
			}
			if (currCock == 3) {
				//For samecocks
				if (same) {
					descript += randomChoice("three ", "a group of ", "a menage a trois of ", "a triad of ", "a triumvirate of ");
					descript += Appearance.cockAdjectives(averageLength, averageThickness, creature.cocks[currCock - 1].cockType, creature);
					if (normalCocks == 3)
						descript += " " + Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
					if (horseCocks == 3)
						descript += ", " + Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
					if (dogCocks == 3)
						descript += ", " + Appearance.cockNoun(CockTypesEnum.DOG) + "s";
					//Tentacles
					if (creature.cocks[0].cockType.Index > 2) descript += ", " + Appearance.cockNoun(creature.cocks[0].cockType) + "s";   // Not sure what's going on here, referencing index *may* be a bug.

				}
				else {
					descript += randomChoice("three ", "a group of ");
					descript += Appearance.cockAdjectives(averageLength, averageThickness, creature.cocks[0].cockType, creature);
					descript += randomChoice(", mutated cocks", ", mutated dicks", ", mixed cocks", ", mismatched dicks");
				}
			}
			//Large numbers of cocks!
			if (currCock > 3) {
				descript += randomChoice("a bundle of ", "an obscene group of ", "a cluster of ", "a wriggling group of ");
				//Cock adjectives and nouns
				descripted = false;
				//If same types...
				if (same) {
					if (creature.cocks[0].cockType == CockTypesEnum.HUMAN) {
						descript += Appearance.cockAdjectives(averageLength, averageThickness, CockTypesEnum.HUMAN, creature) + " ";
						descript += Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
						descripted = true;
					}
					if (creature.cocks[0].cockType == CockTypesEnum.DOG) {
						descript += Appearance.cockAdjectives(averageLength, averageThickness, CockTypesEnum.DOG, creature) + ", ";
						descript += Appearance.cockNoun(CockTypesEnum.DOG) + "s";
						descripted = true;
					}
					if (creature.cocks[0].cockType == CockTypesEnum.HORSE) {
						descript += Appearance.cockAdjectives(averageLength, averageThickness, CockTypesEnum.HORSE, creature) + ", ";
						descript += Appearance.cockNoun(CockTypesEnum.HORSE) + "s";
						descripted = true;
					}
					//TODO More group cock type descriptions!
					if (creature.cocks[0].cockType.Index > 2) {
						descript += Appearance.cockAdjectives(averageLength, averageThickness, CockTypesEnum.HUMAN, creature) + ", ";
						descript += Appearance.cockNoun(creature.cocks[0].cockType) + "s";
						descripted = true;
					}
				}
				//If mixed
				if (!descripted) {
					descript += Appearance.cockAdjectives(averageLength, averageThickness, creature.cocks[0].cockType, creature) + ", ";
					rando = rand(4);
					descript += randomChoice("mutated cocks", "mutated dicks", "mixed cocks", "mismatched dicks");
				}
			}
			return descript;
		}

		public static function cockDescript(creature:Creature, cockIndex:Number = 0):String
		{
			//trace("WRONG COCKDESCRIPT FUNCTION CALLED");
			if (creature.totalCocks() == 0)
				return "<b>ERROR: CockDescript Called But No Cock Present</b>";
			if (creature.cockTotal() <= cockIndex && cockIndex != 99)
				return "<b>ERROR: CockDescript called with index of " + cockIndex + " - out of BOUNDS</b>";
			//Cocknum 99 to default to boring descriptions!
			var descript:String = "";
			if (cockIndex != 99) {
				if (rand(2) == 0)
					descript += cockAdjective(creature, cockIndex) + ", ";
				descript += Appearance.cockNoun(creature.cocks[cockIndex].cockType);
			}
			else {
				cockIndex = 0;
				//50% of the time add a descriptor
				if (rand(2) == 0)
					descript += cockAdjective(creature, cockIndex) + " ";
				var rando:Number = 0;
				rando = int(Math.random() * 10);
				if (rando >= 0 && rando <= 4)
					descript += "cock";
				if (rando == 5 || rando == 6)
					descript += "prick";
				if (rando == 7)
					descript += "pecker";
				if (rando > 7)
					descript += "shaft";
			}
			return descript;
		}
	}
}