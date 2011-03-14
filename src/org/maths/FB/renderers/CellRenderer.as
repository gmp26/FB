package org.maths.FB.renderers
{
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	import org.maths.FB.skins.ToggleCellSkin;
	import org.osflash.signals.Signal;
	
	import spark.components.ToggleButton;
	import spark.components.supportClasses.ItemRenderer;
	
	public class CellRenderer extends ItemRenderer
	{
		private var cellButton:ToggleButton;

		public function CellRenderer()
		{
			cellButton = new ToggleButton();
			cellButton.setStyle("skinClass", ToggleCellSkin);
			cellButton.setStyle("fontSize", "40");
			cellButton.horizontalCenter = 0;
			cellButton.verticalCenter = 0;
			cellButton.addEventListener(Event.CHANGE, changed);

			cellButton.selected = true;
			addElement(cellButton);
		}
		
		private function changed(event:Event):void
		{
			if(signal) {
				signal.dispatch();
				sel = true;
				enable = false;
			}
		}
		
		override public function get data():Object{
			return super.data;
		}
		override public function set data(d:Object):void
		{
			super.data = d;
			value = d.value;
			row = d.row;
			col = d.col;
			sel = d.sel;
			enable = d.enable;
			signal = d.signal;
		}
		
		public function get row():int
		{
			return super.data.row;
		}
		public function set row(r:int):void
		{
			super.data.row = r;
		}
		
		public function get col():int
		{
			return super.data.col;
		}
		public function set col(c:int):void
		{
			super.data.col = c;
		}
		
		public function get sel():Boolean
		{
			return super.data.sel;
		}
		public function set sel(b:Boolean):void
		{
			super.data.sel = b;
			cellButton.selected = b;
		}
		
		public function get enable():Boolean
		{
			return super.data.enable;
		}
		public function set enable(b:Boolean):void
		{
			super.data.enable = b;
			cellButton.enabled = b;
		}
		
		public function get signal():Signal
		{
			return super.data.signal;
		}
		public function set signal(s:Signal):void
		{
			super.data.signal = s;
		}
		
		public function get value():Object
		{
			return super.data.value;
		}
		public function set value(v:Object):void
		{
			super.data.value = v;
			cellButton.label = v.toString();;
		}
	}
}