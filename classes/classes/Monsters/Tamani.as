package classes.Monsters 
{
	import classes.Monster;
	
	/**
	 * ...
	 * @author aimozg
	 */
	public class Tamani extends Monster 
	{

		override public function defeated(hpVictory:Boolean):void
		{
			if (hpVictory) {
				outputText("Tamani is defeated!", true);
			} else {
				outputText("Tamani gives up on defeating you and starts masturbating!", true);
			}
			if(player.lust >= 33 && player.totalCocks() > 0) {
				outputText("  You could fuck her, but if that's the case why did you bother fighting her?\n\nWhat do you do to her?", false);
				var temp:int = 0;
				var temp2:int = 0;
				if(player.hasCock() && player.cockThatFits(analCapacity()) >= 0) temp = 3360;
				//NOT PREGGERS
				if(player.statusAffectv1("Tamani") <= -500 && player.canOvipositSpider()) {
					temp2 = 3837;
				}
				mainClassPtr.simpleChoices("Fuck",mainClassPtr.tamaniSexWon,"Buttfuck",temp,"",0,"Lay Eggs",temp2,"Leave",5007);
			}
			else mainClassPtr.eventParser(5007);
		}

		public function Tamani(mainClassPtr:*)
		{
			super(mainClassPtr);
			init01Names("", "Tamani", "tamani", "She keeps her arms folded across her " + mainClassPtr.tamaniChest() + " and glares at you.  The little thing is only about four feet tall, with pink and black dyed hair cut into a cute little 'do.  The greenish-gray skin of her breasts bulges out around her arms, supported by a few leather straps, amplifying her cleavage.  Her cunt lips are pierced multiple times, inflamed, and slightly parted.  There really isn't any clothing on her to hide them, just more of the ever-present straps wrapping around her thighs.");
			init02Female(VAGINA_WETNESS_DROOLING,VAGINA_LOOSENESS_NORMAL,55);
			init03BreastRows("E");
			init04Ass(ANAL_LOOSENESS_TIGHT,ANAL_WETNESS_DRY,40);
			init05Body(40,HIP_RATING_AMPLE+2,BUTT_RATING_LARGE);
			init06Skin("greenish gray");
			init07Hair("pink and black",16);
			init08Face();
			init09PrimaryStats(32,43,55,62,65,65,50);
			init10Weapon("fists","tiny punch");
			init11Armor("leather straps");
			init12Combat(40,40,0.9,Monster.TEMPERMENT_RANDOM_GRAPPLES);
			init13Level(4,rand(25) + 5);
			initX_Specials(5087,5088);


		}
		
	}

}