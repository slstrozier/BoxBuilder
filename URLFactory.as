package 
{
	//import ST_Files.CustomEvent
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	//import flash.sampler.Sample;

	public class URLFactory extends MovieClip
	{

		public var loader:URLLoader;
		public var textData:Object;
		public var dataArray:Array;
		public var _url:String;

		/**
		  Constructor. At creation, sets loader and gives it an eventListener
		@param url The address for the url request
		  */
		public function URLFactory(url:String)
		{
			_url = url;
			var rand:String = "&"+(Math.random()*100000000).toString();
			try{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, HandleComplete);
			loader.load(new URLRequest(url + rand));
			//loader.load(new URLRequest("C:/Users/Sedrick L. Strozier/Desktop/StrategyBuilder/TestFiles/MathematicalOperators.txt"));
		      }
			catch(error:Error){
			trace(error);
			}
		}
		/**
		  EventListner. Sets the textData to the data of the URLLoader and calls SetData() to store
		the date into the variable
		  */
		function HandleComplete(e:Event):void
		{
			textData = loader.data;
			//trace(textData);
			dispatchEvent(new CustomEvent(CustomEvent.QUERYREADY, textData));
			//dispatchEvent(new Event("dataReadyE"));
		}

	}
}