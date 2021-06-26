package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;

class OptionsMenu extends MusicBeatState
{
	
	function OnOffBool(lol:Bool)
	{
		if (lol)
		{
			return "ON";
		}
		else
		{
			return "OFF";
		}
	}
	
	static var curSelected:Int = 0;
	var selector:FlxSprite;
	var textMenuItems:Array<String> = ['NOTEMISS', 'GAME MODES', 'CHARACTER PREFERENCES'];
	var textMenuoptions:Array<Dynamic> = ['', '', '', ''];

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;
	public static var oldmenucolor = 0xFF7289da;
	public static var newmenucolor = 0xFF7289da;
	
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		//menuBG.color = 0xFF7289da;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();
		
		textMenuoptions[0] = OnOffBool(PlayState.babymode);
		makeOptionsText();
		changeSelection(0);
		
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		OptionsMenu.newmenucolor = 0xFF7289da;
		FlxTween.color(menuBG, 0.6, OptionsMenu.oldmenucolor, OptionsMenu.newmenucolor,{
			onComplete: function(t:FlxTween)
			{
				OptionsMenu.oldmenucolor = 0xFF7289da;
			}
		});
	}
	function Refresh()
	{
		remove(grpOptionsTexts);
		makeOptionsText();
		changeSelection(0);
	}
	function makeOptionsText()
	{
		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, 30 + (70 * i), textMenuItems[i] + '  ' + textMenuoptions[i], true, false);
			optionText.ID = i;
			optionText.x += 10*(i+1);
			grpOptionsTexts.add(optionText);
		}
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.ACCEPT)
		{
			trace(textMenuItems[curSelected]);
			switch (textMenuItems[curSelected])
			{
				case "NOTEMISS":
				{
					PlayState.babymode = !PlayState.babymode;
					textMenuoptions[0] = OnOffBool(PlayState.babymode);
					Refresh();
				}
				case "CHARACTER PREFERENCES":
				{
					FlxG.switchState(new CharacterMenuState());
				}
				case 'GAME MODES':
				{
					FlxG.switchState(new GameModeState());
				}
			}
		}
	}
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpOptionsTexts.length - 1;
		if (curSelected >= grpOptionsTexts.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpOptionsTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
