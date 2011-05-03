package org.maths.FB.views
{
	import com.tweenman.TweenMan;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.BlurFilter;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.setTimeout;
	
	import mx.events.FlexEvent;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.components.TableButton;
	import org.maths.FB.components.Tick;
	import org.maths.FB.models.Analyser;
	import org.maths.FB.models.PickerData;
	import org.maths.FB.models.Scores;
	import org.maths.FB.skins.HeaderCellSkin;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TileGroup;
	import spark.components.supportClasses.GroupBase;
	import spark.effects.SlideViewTransition;
	import spark.effects.ViewTransition;
	
	public class AbstractLevelMediator extends Mediator
	{
		[Inject]
		public var scores:Scores;
		
		[Inject]
		public var pickerData:PickerData;
		
		[Inject]
		public var analyser:Analyser;
		
		// genereic names for components found in individual screens
		public var blur:BlurFilter = new BlurFilter(4,4,2);
		
		// injected values
		public var level:AbstractLevel;
		public var levelName:String;
		public var content:GroupBase;
		public var rowHeader:Group;		
		public var colHeader:Group;
		public var table:TileGroup;
		public var instruction:Label;
		public var endNavigation:Group;
		public var homeButton:Button
		public var backButton:Button
		public var skipButton:Button
		public var checkButton:Button;
		public var tryAgainButton:Button;
		public var nextButton:Button;
		
		public var min:int = 2;
		public var max:int = 12;
		public var solved:Boolean = false;
		
		
		public function AbstractLevelMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			if(level.destructionPolicy == "auto") {
				if(homeButton) homeButton.addEventListener(MouseEvent.CLICK, home);
				if(backButton) backButton.addEventListener(MouseEvent.CLICK, prevScreen);
				skipButton.addEventListener(MouseEvent.CLICK, nextScreen);
				checkButton.addEventListener(MouseEvent.CLICK, check);
				tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
				nextButton.addEventListener(MouseEvent.CLICK, nextScreen);
				scores.startLevel(levelName);
				trace(levelName + " events registered");
			}
			else {
				level.destructionPolicy = "auto";
			}
			solved = false;
			enableAll();
			
		}
		
		override public function onRemove():void
		{
			if(level.destructionPolicy == "auto") {
				if(homeButton) homeButton.removeEventListener(MouseEvent.CLICK, home);
				if(backButton) backButton.removeEventListener(MouseEvent.CLICK, prevScreen);
				skipButton.removeEventListener(MouseEvent.CLICK, nextScreen);
				checkButton.removeEventListener(MouseEvent.CLICK, check);
				tryAgainButton.removeEventListener(MouseEvent.CLICK, tryAgain);
				nextButton.removeEventListener(MouseEvent.CLICK, nextScreen);
				trace(levelName + " handlers removed");
			}
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
				if(b && b.label=="") b.enabled = false;
			}
			//content.filters = [blur];
			
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
				if(b && b.label=="" && !solved) b.enabled = true;
			}
			
			content.filters = [];
			tryAgainButton.visible = false;
			nextButton.visible = false;
		}
		
/*
		protected function headerClicked(event:MouseEvent):void
		{
			var picker:Picker = new Picker();
			disableAll();
			populatePickerForHeader(picker, event.currentTarget as HeaderButton);
			popupPicker(picker);
		}
*/	
		
		[Embed(source="assets/slider.mp3")]
		public var sndCls:Class;
		
		public var snd:Sound = new sndCls() as Sound; 
		public var sndChannel:SoundChannel;
		
		protected function headerClicked(event:MouseEvent):void
		{
			sndChannel=snd.play();
			disableAll();
			populatePickerDataForHeader(event.currentTarget as HeaderButton);
			popupPicker();
		}
		
		// override in subclasses if you need something different
		protected function populatePickerDataForHeader(header:HeaderButton):void
		{
			pickerData.headerButton = header;
			pickerData.buttonLabels = new Vector.<String>;
			
			for(var i:int = min; i <= max; i++) {
				pickerData.buttonLabels.push(i.toString());
			}			
		}
		
		/*
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
		*/
		
		// override in subclasses if you need something different
		protected function popupPicker():void
		{
			//picker.percentWidth=0;
			//picker.percentHeight=0;
			//TweenMan.addTween(picker, {time:0.3, percentWidth:80, percentHeight:80});
			//picker.horizontalCenter=0;
			//picker.verticalCenter=0;
			//level.addElement(picker);
			level.destructionPolicy="none";
			level.addEventListener(FlexEvent.VIEW_ACTIVATE, viewActivated);
			level.navigator.pushView(PickerView);
			//content.filters = [blur];
		}
		
		protected function viewActivated(event:FlexEvent):void
		{
			trace("Activated:" + event);
			level.removeEventListener(FlexEvent.VIEW_ACTIVATE, viewActivated);
			handlePickerChoice(pickerData.headerButton, pickerData.pickedLabel);
		}
		
		// override in subclasses if you need something different
		protected function handlePickerChoice(header:HeaderButton, pickedLabel:String):void
		{
			var number:int = parseInt(pickedLabel);
			header.label = isNaN(number) ? "?" : pickedLabel;

			// steal the label from anyone else using it
			var parent:Group = header.parent as Group;
			for(var j:int = 0; j < parent.numElements; j++) {
				var h:HeaderButton = parent.getElementAt(j) as HeaderButton;
				if(h != header && h != null && h.label == pickedLabel)
					h.label = "?";
			}
			
			endGame();
		}
		
/*
		protected function closePicker(picker:Picker):void
		{
			TweenMan.addTween(picker, {time:0.3, percentWidth:0, percentHeight:0, onComplete:function():void {
				level.removeElement(picker);
				content.filters = [];
				enableAll();
				endGame();
			}});			
		}
*/		
		protected function closePicker(picker:PickerView):void
		{
			picker.navigator.popView();
			content.filters = [];
			enableAll();
			endGame();
		}
		
		protected function get isComplete():Boolean
		{			
			for(var i:int = 0; i < rows; i++) {
				if((rowHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}
			for(i = 0; i < cols; i++) {
				if((colHeader.getElementAt(i) as HeaderButton).label == "?")
					return false;
			}
			
			return true;
		}
		
		protected function productClicked(event:MouseEvent):void
		{
			sndChannel=snd.play();
			var button:TableButton = event.currentTarget as TableButton;
			button.enabled = false;
			button.label = (rowMultiplier(button.row) * colMultiplier(button.col)).toString();
			endGame(event);
		}
		
		protected function endGame(event:MouseEvent=null):void
		{
			if(event != null) {
				var b:TableButton = event.currentTarget as TableButton;
				var x:int = table.getElementIndex(b);
				var col:int = x % cols;
				var row:int = x / rows;
				analyser.addReveal(row, col, parseInt(b.label));
			}
			
			analyser.solve();
			analyser.solve();
			var unknowns:int = analyser.solve() - rows - cols;
			
			var newSpots:Boolean = false;
			for(var i:int = 0; i < table.numElements; i++) {
				var tb:TableButton = table.getElementAt(i) as TableButton;
				//if(tb == null) continue;
				var rh:HeaderButton = rowHeader.getElementAt(tb.row) as HeaderButton;
				if(analyser.rowPossibles[tb.row].length > 1) continue;
				rh.spot = true;
				var ch:HeaderButton = colHeader.getElementAt(tb.col) as HeaderButton;
				if(analyser.colPossibles[tb.col].length > 1) continue;
				ch.spot = true;
				newSpots = true;
			}
			
			if(newSpots)
				newSpotDetected();
			
			/*
			// trace what can be deduced 
			for(i=0; i < rows; i++) {
			var possibles:Vector.<int> = analyser.rowPossibles[i];
			var s:String = "row["+i+"]=";
			for(var j:int=0; j < possibles.length; j++) {
			s += possibles[j]+" ";
			}
			trace(s);
			}
			
			for(i=0; i < cols; i++) {
			possibles = analyser.colPossibles[i];
			s = "col["+i+"]=";
			for(j=0; j < possibles.length; j++) {
			s += possibles[j]+" ";
			}
			trace(s);
			}
			*/
			
			
			if(unknowns == 0) {
				solved = true;
				endNavigation.visible = true;
				instruction.visible = false;
				for(i = 0; i < table.numElements; i++) {
					var t:TableButton = table.getElementAt(i) as TableButton;
					t.enabled = false;
				}
			}
			
			if(isComplete)
				TweenMan.addTween(checkButton, {time:0.3, bottom:0});
			else
				TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
//			super.endGame(event);
		}

		protected function newSpotDetected():void
		{
			
		}
		
		protected function popupCheckButton(event:MouseEvent = null):void
		{
			if(isComplete)
				TweenMan.addTween(checkButton, {time:0.3, bottom:0});
			else
				TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
		}
		
		protected function get isCorrect():Boolean
		{
			for(var i:int = 0; i < rows; i++) {
				var h:HeaderButton = rowHeader.getElementAt(i) as HeaderButton;
				if(parseInt(h.label) != h.value)
					return false;
			}
			for(i = 0; i < cols; i++) {
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
			// content.filters=[];
			TweenMan.addTween(checkButton, {time:0.3, bottom:-90});
			if(isCorrect) {
				if(nextButton) nextButton.visible = true;
				if(tryAgainButton) tryAgainButton.visible = false;
				if(endNavigation) endNavigation.visible = true;
				revealAll();
			}
			else {
				if(nextButton) nextButton.visible = false;
				if(tryAgainButton) tryAgainButton.visible = true;
			}
			if(instruction) instruction.visible = false;
			if(endNavigation) endNavigation.visible = true;
		}

		protected function revealAll():void
		{
			for(var i:int=0; i < rows; i++) {
				for(var j:int = 0; j < cols; j++) {
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
			level.navigator.popView();//  pushView(CompletedLevels);			
		}
		
		protected function tryAgain(event:MouseEvent):void
		{
			enableAll();
			if(instruction) instruction.visible = true;
			if(endNavigation) endNavigation.visible = false;
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