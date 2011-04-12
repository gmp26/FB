package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.Picker;
	import org.maths.FB.components.TableButton;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.Scores;
	import org.maths.FB.skins.HeaderCellSkin;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.TileGroup;
	import spark.components.supportClasses.GroupBase;
	
	public class AbstractLevelMediator extends Mediator
	{
		[Inject]
		public var scores:Scores;
		
		
		// genereic names for components found in individual screens
		public var blur:BlurFilter = new BlurFilter(4,4,2);
		
		// injected values
		public var level:AbstractLevel;
		public var levelName:String;
		public var content:GroupBase;
		public var rowHeader:Group;		
		public var colHeader:Group;
		public var table:TileGroup;
		public var homeButton:Button
		public var backButton:Button
		public var skipButton:Button
		public var checkButton:Button;
		public var tryAgainButton:Button;
		public var nextButton:Button;
		public var min:int = 2;
		public var max:int = 12;
		
		
		public function AbstractLevelMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			if(homeButton) homeButton.addEventListener(MouseEvent.CLICK, home);
			if(backButton) backButton.addEventListener(MouseEvent.CLICK, prevScreen);
			skipButton.addEventListener(MouseEvent.CLICK, nextScreen);
			checkButton.addEventListener(MouseEvent.CLICK, check);
			tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
			nextButton.addEventListener(MouseEvent.CLICK, nextScreen);

			scores.startLevel(levelName);

			enableAll();
		}
		
		override public function onRemove():void
		{
			if(homeButton) homeButton.removeEventListener(MouseEvent.CLICK, home);
			if(backButton) backButton.removeEventListener(MouseEvent.CLICK, prevScreen);
			skipButton.removeEventListener(MouseEvent.CLICK, nextScreen);
			checkButton.removeEventListener(MouseEvent.CLICK, check);
			tryAgainButton.removeEventListener(MouseEvent.CLICK, tryAgain);
			nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);
			
			disableAll();
		}
	
		protected function disableAll():void
		{
			for(var i:int = 0; i < rowHeader.numElements; i++) {
				var h:HeaderButton = (rowHeader.getElementAt(i) as HeaderButton);
				h.enabled = false;
			}
			for(i = 0; i < colHeader.numElements; i++) {
				h = (colHeader.getElementAt(i) as HeaderButton);
				h.enabled = false;
			}
			for(i = 0; i < table.numElements; i++) {
				var b:TableButton = table.getElementAt(i) as TableButton;
				if(b) b.enabled = false;
			}
			content.filters = [blur];
			
		}
		
		protected function enableAll():void
		{
			for(var i:int = 0; i < rowHeader.numElements; i++) {
				var h:HeaderButton = (rowHeader.getElementAt(i) as HeaderButton);
				h.enabled = true;
			}
			for(i = 0; i < colHeader.numElements; i++) {
				h = (colHeader.getElementAt(i) as HeaderButton);
				h.enabled = true;
			}
			
			for(i = 0; i < table.numElements; i++) {
				var b:TableButton = table.getElementAt(i) as TableButton;
				if(b && b.label=="" && !b.selected) b.enabled = true;
			}
			
			content.filters = [];
			tryAgainButton.visible = false;
			nextButton.visible = false;
		}
		
		protected function headerClicked(event:MouseEvent):void
		{
			var picker:Picker = new Picker();
			disableAll();
			populatePickerForHeader(picker, event.currentTarget as HeaderButton);
			popupPicker(picker);
		}
		
		// override in subclasses if you need something different
		protected function populatePickerForHeader(picker:Picker, header:HeaderButton):void
		{
			for(var i:int = min-1; i <= max; i++) {
				var button:HeaderButton = new HeaderButton();
				if(i == min - 1) 
					button.label = "?"
				else
					button.label = i.toString();
				
				picker.choices.addElement(button);
				var f:Function;
				button.addEventListener(MouseEvent.CLICK, f = function(event:MouseEvent):void {
					button.removeEventListener(MouseEvent.CLICK, f);
					
					handlePickerChoice(picker, header, event.currentTarget as HeaderButton);
					closePicker(picker);
				});
			}			
		}
		
		// override in subclasses if you need something different
		protected function popupPicker(picker:Picker):void
		{
			picker.percentWidth=0;
			picker.percentHeight=0;
			TweenMan.addTween(picker, {time:0.3, percentWidth:80, percentHeight:80});
			picker.horizontalCenter=0;
			picker.verticalCenter=0;
			level.addElement(picker);
			content.filters = [blur];
		}
		
		// override in subclasses if you need something different
		protected function handlePickerChoice(picker:Picker, header:HeaderButton, pickedButton:HeaderButton):void
		{
			var number:int = parseInt(pickedButton.label);
			header.label = isNaN(number) ? "?" : pickedButton.label;

			// steal the label from anyone else using it
			var parent:Group = header.parent as Group;
			for(var j:int = 0; j < parent.numElements; j++) {
				var h:HeaderButton = parent.getElementAt(j) as HeaderButton;
				if(h != header && h != null && h.label == pickedButton.label)
					h.label = "?";
			}
		}
		
		protected function closePicker(picker:Picker):void
		{
			TweenMan.addTween(picker, {time:0.3, percentWidth:0, percentHeight:0, onComplete:function():void {
				level.removeElement(picker);
				content.filters = [];
				enableAll();
				endGame();
			}});			
		}
		
		
		protected function get isComplete():Boolean
		{			
			for(var i:int = 0; i < rowHeader.numElements; i++) {
				if((rowHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}
			for(i = 0; i < colHeader.numElements; i++) {
				if((colHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}
			
			return true;
		}
		
		protected function productClicked(event:MouseEvent):void
		{
			var button:TableButton = event.currentTarget as TableButton;
			button.enabled = false;
			button.label = (rowMultiplier(button.row) * colMultiplier(button.col)).toString();
			endGame(event);
		}
		
		protected function endGame(event:MouseEvent = null):void
		{
			if(isComplete)
				TweenMan.addTween(checkButton, {time:0.3, bottom:0});
			else
				TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
		}
				
		protected function get isCorrect():Boolean
		{
			for(var i:int = 0; i < rowHeader.numElements; i++) {
				var h:HeaderButton = rowHeader.getElementAt(i) as HeaderButton;
				if(parseInt(h.label) != h.value)
					return false;
			}
			for(i = 0; i < colHeader.numElements; i++) {
				h = colHeader.getElementAt(i) as HeaderButton;
				if(parseInt(h.label) != h.value)
					return false;
			}
			
			return true;
		}
		
		protected function check(event:MouseEvent):void
		{
			disableAll();
			// but don't blur this time
			content.filters=[];
			TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
			if(isCorrect) {
				nextButton.visible = true;
				tryAgainButton.visible = false;
				revealAll();
			}
			else {
				nextButton.visible = false;
				tryAgainButton.visible = true;
			}
		}

		protected function revealAll():void
		{
			for(var i:int=0; i < rowHeader.numElements; i++) {
				for(var j:int = 0; j < colHeader.numElements; j++) {
					var t:TableButton = table.getElementAt(i*rows + j) as TableButton;
					t.label = (rowMultiplier(i) * colMultiplier(j)).toString();
				}
			}
		}
		
		protected function home(event:MouseEvent):void
		{
			enableAll();
			level.navigator.popToFirstView();
		}
		
		protected function prevScreen(event:Event):void
		{
			enableAll();
			level.navigator.popView();			
		}
		
		protected function nextScreen(event:Event):void
		{
			enableAll();
			level.navigator.pushView(CompletedLevels);			
		}
		
		protected function tryAgain(event:MouseEvent):void
		{
			enableAll();
		}
		
		protected function rowMultiplier(i:int):int
		{
			var h:HeaderButton = rowHeader.getElementAt(i) as HeaderButton;
			var n:int = h.value;
			return n;
		}
		
		protected function colMultiplier(i:int):int
		{
			var h:HeaderButton = colHeader.getElementAt(i) as HeaderButton;
			var n:int = h.value;
			return n;
		}
		
		protected function get rows():int
		{
			return table.rowCount;
		}
		
		protected function get cols():int
		{
			return table.columnCount;
		}
	
		protected function get isPortrait():Boolean
		{
			return (stageHeight > stageWidth) ? true : false;
		}
		
		protected function get stageHeight():int
		{
			return level.stage.stageHeight;
		}
		
		protected function get stageWidth():int
		{
			return level.stage.stageWidth;
		}

	}
}