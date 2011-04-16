package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.TableButton;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.AppState;
	import org.maths.FB.models.PickerData;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	
	public class Intro1Mediator extends AbstractLevelMediator
	{
		[Inject]
		public var intro1:Intro1;
		
		public function Intro1Mediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			// inject common components into AbstractMediator
			level = intro1;
			levelName = "intro1";
			content = intro1._content;
			homeButton = intro1._homeButton;
			skipButton = intro1._skipButton;
			checkButton = intro1._checkButton;
			nextButton = intro1._nextButton;
			tryAgainButton = intro1._tryAgainButton;
			
			intro1.h1.addEventListener(MouseEvent.CLICK, headerClicked);
			intro1.h2.addEventListener(MouseEvent.CLICK, headerClicked);
			intro1.product.addEventListener(MouseEvent.CLICK, productClicked);

			super.onRegister();
		}
		
		override public function onRemove():void
		{
			intro1.h1.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro1.h2.removeEventListener(MouseEvent.CLICK, headerClicked);
			intro1.product.removeEventListener(MouseEvent.CLICK, productClicked);

			super.onRemove();
		}
		
		override protected function enableAll():void
		{
			intro1.h1.enabled = true;
			intro1.h2.enabled = true;
			if(intro1.product.label == "") intro1.product.enabled = true;

			content.filters = [];
			tryAgainButton.visible = false;
			nextButton.visible = false;
		}
		
		override protected function disableAll():void
		{
			intro1.h1.enabled = false;
			intro1.h2.enabled = false;
			intro1.product.enabled = false;

			content.filters = [blur];
			
		}
		
		override protected function productClicked(event:MouseEvent):void
		{
			var button:TableButton = event.currentTarget as TableButton;
			button.enabled = false;
			button.label = "28";
			popupCheckButton(event);
		}
		
		override protected function headerClicked(event:MouseEvent):void
		{
			disableAll();
			populatePickerDataForHeader(event.currentTarget as HeaderButton);
			popupPicker();
		}

		
		override protected function populatePickerDataForHeader(header:HeaderButton):void
		{
			pickerData.headerButton = header;
			pickerData.buttonLabels = new Vector.<String>;
			pickerData.pickerMessage = "Notice that different colour buttons offer different choices. In this case blue choices are not the same as green choices.";
			
			for(var i:int = 2; i <= 12; i++) {
				
				var green:Boolean = header.isGreen;
				
				if(green && i % 2 == 0)
					continue;

				if(i > 1 && !green && i % 2 == 1)
					continue;
				
				pickerData.buttonLabels.push(i.toString());
			}			
		}
		
		// override in subclasses if you need something different
		override protected function handlePickerChoice(header:HeaderButton, pickedLabel:String):void
		{
			var number:int = parseInt(pickedLabel);
			header.label = isNaN(number) ? "?" : pickedLabel;
			popupCheckButton();
		}
		
		override protected function get isComplete():Boolean
		{
			return (intro1.h1.label != "?" && intro1.h2.label != "?" && intro1.product.label != "");
		}
		
		override protected function get isCorrect():Boolean
		{
			return (intro1.h1.label == "7" && intro1.h2.label == "4");
		}
		
		override protected function nextScreen(event:Event):void
		{
			level.navigator.pushView(Intro2);			
		}
		
		override protected function revealAll():void
		{
			intro1.h1.enabled = false;
			intro1.h2.enabled = false;
			intro1.product.enabled = false;
		}
		
	}
}