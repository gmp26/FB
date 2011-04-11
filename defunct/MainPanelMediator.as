package org.maths.FB.views
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.maths.FB.components.HeaderButton;
	import org.maths.FB.models.AppState;
	import org.maths.FB.signals.GreyNumberSignal;
	import org.maths.FB.signals.HideAllSignal;
	import org.maths.FB.signals.NewProblemSignal;
	import org.maths.FB.signals.NewTableSignal;
	import org.maths.FB.signals.RevealAllSignal;
	import org.maths.FB.skins.CellSkin;
	import org.maths.FB.skins.HeaderCellSkin;
	import org.maths.FB.skins.ToggleCellSkin;
	import org.osmf.events.TimeEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Group;
	import spark.components.Label;
	
	public class MainPanelMediator extends Mediator
	{
		
		[Inject]
		public var mainPanel:MainPanel;
		
		[Inject]
		public var appState:AppState;
		
		[Inject]
		public var newProblemSignal:NewProblemSignal;
		
		[Inject]
		public var newTableSignal:NewTableSignal;
		
		[Inject]
		public var revealAllSignal:RevealAllSignal;
		
		[Inject]
		public var hideAllSignal:HideAllSignal;
		
		[Inject]
		public var greyNumberSignal:GreyNumberSignal;
		
		override public function onRegister():void
		{
			newProblemSignal.add(newProblem);
			revealAllSignal.add(revealAll);

			// create row headers
			var rh:Group = mainPanel.rowHeader;
			for(var i:int = 0; i < appState.size; i++) {
				var header:HeaderButton = new HeaderButton();
				header.label="?"; 
				rh.addElement(header);
			}
			
			// create column headers
			var ch:Group = mainPanel.columnHeader;
			var pad:int = 5;
			for(i = 0; i < appState.size; i++) {
				var spacer:Group = new Group();
				spacer.height = pad;
				pad = 12;
				header = new HeaderButton();
				header.label="?";
				ch.addElement(spacer);
				ch.addElement(header);
			}
			
			newProblem(1);
		}
		
		override public function onRemove():void
		{
			newProblemSignal.remove(newProblem);
			revealAllSignal.remove(revealAll);
			removeEventListeners();
		}
		
		private function newProblem(level:int):void
		{
			mainPanel.visible = false;
						
			resetHeaders(true);
			hideAllSignal.dispatch();

			var timer:Timer = new Timer(500,1);
			timer.start();
			var thisCall:Function;
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, thisCall = function(event:TimerEvent):void {
				appState.gameLevel = level;

				do {
					appState.rowHeadings = [];
					appState.colHeadings = [];
					var val:int;
					
					for(var i:int = 0; i < appState.size; i++) {
						while(appState.rowHeadings.indexOf(val = appState.min + Math.floor((appState.max-appState.min + 1)*Math.random())) >= 0) {};
						appState.rowHeadings[i] = val;
						//trace("r"+val);
					}
					for(var j:int = 0; j < appState.size; j++) {
						while(appState.colHeadings.indexOf(val = appState.min + Math.floor((appState.max-appState.min + 1)*Math.random())) >= 0) {};
						appState.colHeadings[j] = val;
						//trace("c"+val);
					}
				} while (symmetric());
				
				removeEventListeners();
				drawHeaders();

				// redraw lines after we're sure tables are populated
				var box:Group = mainPanel.rowHeader.parent as Group;
				mainPanel.topLine.width = box.x + mainPanel.rowHeader.width;
				mainPanel.sideLine.height =box.y + box.height;
				
				addEventListeners();
				
				newTableSignal.dispatch();

				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, thisCall);
				
				mainPanel.visible = true;
			})
		}
		
		private function unique():Boolean
		{
			for(var i:int = 0; i < appState.colHeadings.length - 1; i++) {
				var h:int = appState.colHeadings[i];
				if(appState.colHeadings.indexOf(-h, i+1) >= 0) {
					return false;
				}
			}
			for(i = 0; i < appState.rowHeadings.length - 1; i++) {
				h = appState.rowHeadings[i];
				if(appState.rowHeadings.indexOf(-h, i+1) >= 0) {
					return false;
				}
			}

			return true;
		}
		
		private function removables():Object
		{
			var removables:Object = {rows:[], cols:[]};
			var symmetries:Object = {rows:[], cols:[]};
			for(var i:int = 0; i < appState.colHeadings.length; i++) {
				var h:int = appState.colHeadings[i];
				if((-h >= appState.min) && (-h <= appState.max)) {
					if(h != 0 && appState.colHeadings.indexOf(-h) < 0 && (-h >= appState.min) && (-h <= appState.max)) {
						removables.cols.push(-h);
					}
					else {
						symmetries.cols.push(-h);
					}
				}
				else {
					trace("rows ok")
					return {};
				}
			}

			for(i = 0; i < appState.rowHeadings.length; i++) {
				h = appState.rowHeadings[i];
				if((-h >= appState.min) && (-h <= appState.max)) {
					if(h != 0 && appState.rowHeadings.indexOf(-h) < 0 && (-h >= appState.min) && (-h <= appState.max)) {
						removables.rows.push(-h);
					}
					else {
						symmetries.rows.push(-h);
					}
				}
				else {
					trace("cols ok")
					return {};
				}
			}

			trace("removable rows: ", removables.rows);
			trace("removable cols: ", removables.cols);
			trace("sym rows: ", symmetries.rows);
			trace("sym cols: ", symmetries.cols);
			
			if(removables.rows.length + symmetries.rows.length < appState.rowHeadings.length) {
				trace("rows asymmetric");
				return {};
			}
			else {
				// remove a row heading
				if(removables.rows.length > 0) { 
					var rh:int = removables.rows.pop();
					trace("remove",rh,"from row");
					return {row:rh};
				}
			}
			
			if(removables.cols.length + symmetries.cols.length < appState.rowHeadings.length) {
				trace("cols asymmetric");
				return {};
			}
			else {
				// remove a col heading
				if(removables.cols.length > 0) { 
					var ch:int = removables.cols.pop();
					trace("remove",ch,"from col");
					return {col:ch};
				}
			}
			trace("still symmetric");
			return null;
		}
		
		/**
		 * 
		 * @return true if symmetric. False if not.
		 * 
		 */
		private function symmetric():Boolean
		{
			var removableDraggers:Object = removables();
			
			return false;
			
			// in this case we failed to uniquify
			if (removableDraggers == null)
				return true;

			if(removableDraggers.row) {
				var remove:int = removableDraggers.row;
				/*
				for(var i:int = 0; i < mainPanel.rowDraggers.numElements; i++) {
					var dragger:Dragger = mainPanel.rowDraggers.getElementAt(i) as Dragger;
					if(dragger.label.text == remove.toString()) {
						dragger.currentState = "disabled";
						trace("removing row "+remove);
					}
				}
				*/
				greyNumberSignal.dispatch(true);
				return false;
			}
			
			if(removableDraggers.col) {
				remove = removableDraggers.col;
				/*
				for(i = 0; i < mainPanel.columnDraggers.numElements; i++) {
					dragger = mainPanel.columnDraggers.getElementAt(i) as Dragger;
					if(dragger.label.text == remove.toString()) {
						dragger.currentState = "disabled";
						trace("removing col "+remove);
					}
				}
				*/
				greyNumberSignal.dispatch(true);
				return false;
			}

			// It was already unique
			greyNumberSignal.dispatch(false);
			return false;
		}

		private function drawHeaders():void
		{
			var index:int = 0;
			for(var i:int = 0; i < mainPanel.rowHeader.numElements; i++) {
				var header:HeaderButton = mainPanel.rowHeader.getElementAt(i) as HeaderButton;
				if(header) {
					var label:String = "?"; //appState.rowHeadings[index++];
					header.label = label;
					header.enabled = true; 
					header.selected = false;
					header.currentState = "up";
				}
			}
			
			index = 0;
			for(var j:int = 0; j < mainPanel.columnHeader.numElements; j++) {
				header = mainPanel.columnHeader.getElementAt(j) as HeaderButton;
				if(header) {
					header.label = "?"; //appState.colHeadings[index++];
					header.enabled = true;
					header.selected = false;
					header.currentState = "up";
				}
			}
		}
			
		private function addEventListeners():void
		{
			// click handlers for row header buttons
			for(var i:int = 0; i < mainPanel.rowHeader.numElements; i++) {
				var header:HeaderButton = mainPanel.rowHeader.getElementAt(i) as HeaderButton;
				if(header) {
					header.addEventListener(Event.CHANGE, changed);
				}
			}
			
			// click handlers for column header buttons
			for(var j:int = 0; j < mainPanel.columnHeader.numElements; j++) {
				header = mainPanel.columnHeader.getElementAt(j) as HeaderButton;
				if(header) {
					header.addEventListener(Event.CHANGE, changed);
				}
			}

		}
		
		
		private function removeEventListeners():void
		{
			for(var i:int = 0; i < appState.rowHeadings.numElements; i++) {
				var header:HeaderButton = mainPanel.rowHeader.getElementAt(i) as HeaderButton;
				if(header && header.hasEventListener(Event.CHANGE))
					header.removeEventListener(Event.CHANGE, changed);
			}
			
			for(var j:int = 0; j < appState.colHeadings.numElements; j++) {
				header = mainPanel.columnHeader.getElementAt(j) as HeaderButton;
				if(header && header.hasEventListener(Event.CHANGE))
					header.removeEventListener(Event.CHANGE, changed);
			}
			

		}
		
		private function changed(event:Event):void
		{
			var tb:HeaderButton = event.target as HeaderButton;
		}
		
		
		private function revealAll():void
		{
			resetHeaders(false);
		}
		
		private function resetHeaders(selected:Boolean):void
		{
			
			for(var i:int = 0; i < mainPanel.rowHeader.numElements; i++) {
				var header:HeaderButton = mainPanel.rowHeader.getElementAt(i) as HeaderButton;
				if(header)
					header.label = "?";
			}
			for(var j:int = 0; j < mainPanel.columnHeader.numElements; j++) {
				header = mainPanel.columnHeader.getElementAt(j) as HeaderButton;
				if(header)
					header.label = "?";
			}
		}
		
	}
}