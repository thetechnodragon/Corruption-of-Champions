/**
 * Created by aimozg on 10.01.14.
 */
package classes.Items.Weapons
{
	import classes.Items.Weapon;
	import classes.PerkLib;
	import classes.Player;

	public class Spellblade extends Weapon
	{
		override public function equipEffect(player:Player, output:Boolean):void
		{
			player.createPerk(PerkLib.WizardsFocus,.5,0,0,0);
		}

		override public function unequipEffect(player:Player, output:Boolean):void
		{
			player.removePerk(PerkLib.WizardsFocus);
		}

		public function Spellblade()
		{
			super("S.Blade","S.Blade","inscribed spellblade","a spellblade","slash",8,500,"Forged not by a swordsmith but a sorceress, this arcane-infused blade amplifies your magic.  Unlike the wizard staves it is based on, this weapon also has a sharp edge, a technological innovation which has proven historically useful in battle.","Wizard's Focus")
		}
	}
}
