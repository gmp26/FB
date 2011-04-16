package org.maths.FB.models
{
	import org.maths.FB.components.HeaderButton;
	
	import spark.components.supportClasses.Skin;

	public class PickerData
	{
		public var headerButton:HeaderButton;
		public var buttonLabels:Vector.<String>;
		public var pickedLabel:String;
		public var pickerMessage:String;
	}
}