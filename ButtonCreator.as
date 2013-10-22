package  {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	import fl.controls.Label;
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObject;

	//import BoxCreator.*
	
	
	
	public class ButtonCreator extends MovieClip{
		private var buttons:Array;
		private var buttonData:Array;
		private var commodities:Array;
		private var currencies:Array;
		private var bonds:Array;
		private var indices:Array;
		private var commoditiesButton:MovieClip;
		private var currenciesButton:MovieClip;
		private var bondsButton:MovieClip;
		private var indicesButton:MovieClip;
		private var subCatagoriesDisplayList:Array;
		private var dropShawdow:DropShadowFilter;
		
		
		
		public function ButtonCreator() {
			commodities = new Array();
			currencies = new Array();
			bonds = new Array();
			indices = new Array();
			subCatagoriesDisplayList = new Array();
			
			addEventListener("dataReady", setAllData);
			getBoxInfo();
			init();
		}
		function init():void{
			addMainButtons();
		}
		function clearDisplayList(displayList:Array):void{
			for(var index:Number = 0; index < displayList.length; index ++)
			{
				removeChild(displayList[index]);
			}
			displayList.splice(0);
		}
		function addMainButtons():void{
			addChild(createMainButton("Indices", indicesButton = new MovieClip()));
			addChild(createMainButton("Commodities", commoditiesButton = new MovieClip(), 100));
			addChild(createMainButton("Currencies", currenciesButton = new MovieClip(), 300));
			addChild(createMainButton("Bonds", bondsButton = new MovieClip(), 200));			
		}
		function createMainButton(catagory:String, mc:MovieClip, xLoca:Number = 0, yLoca:Number = 0):MovieClip{
			mc.addChild(createTextFields(catagory))
			mc.addEventListener(MouseEvent.CLICK, mainButtonHandler)
			mc.Catagory = new String(catagory)
			mc.mouseChildren = false;
			mc.buttonMode = true;
			mc.x = xLoca;
			mc.y = yLoca;
			return mc;
		}
		function mainButtonHandler(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			switch(mc.Catagory)
			{
				case "Indices":
				placeClips(indices, 300, subCatagoriesDisplayList);
				break;
				case "Commodities":
				placeClips(commodities, 300, subCatagoriesDisplayList);
				break;
				case "Bonds":
				placeClips(bonds, 300, subCatagoriesDisplayList);
				break;
				case "Currencies":
				placeClips(currencies, 300, subCatagoriesDisplayList);
				break;
			}
		}
		function createButtonsList(numButtons:Number):Array{
			buttons = new Array();
			for(var index:Number = 0; index < numButtons; index++){
				var mcText:TextButton = new TextButton();
				
				buttons.push(buttonPropertyGetter(mcText,index));
				var label:String = removeSpaces(mcText.ButtonData[0].Label)
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				setDropShadow(mcText);
				mcText.buttonText.text = label;
				//mcText.Label.text = "hello";
				
				
			}
			splitCatagories(buttons)
			
			return buttons;
		}
		function setDropShadow(obj:DisplayObject):void{
			
			
			obj.filters = [new DropShadowFilter(16,45,20,0.5, 20.0, 20.0,1.0)]
			
		}
		//splits the buttons in the buttons array into the subCatagories (Adds the buttons to the specified arrays). 
		function splitCatagories(buttons:Array):void{
			for each(var button:MovieClip in buttons)
			{
				switch(button.ButtonData[0].SubCatagory)
				{
					case "Commodity":
					commodities.push(button);
					break;
					case "Currency":
					currencies.push(button);
					break;
					case "Bond":
					bonds.push(button);
					break;
					case "Index":
					indices.push(button);
					break;
				}

			}
			
		}
		/*Create the text fields to be placed on top of the movie clip. Returns a textfield*/
		function createTextFields(displayName:String):Label{
			var butName:Label = new Label;
			displayName = removeSpaces(displayName)
			//butName.background = true;
			//butName.backgroundColor = 0xFF99FF
			butName.text = displayName
			butName.autoSize = "center"
			return butName;
		}
		/*Takes a movie clip and adds its propetites. The Index is the index of the main array that holds all of the information from the query.
		* Pass this function a movie clip and an index for its properties and its adds an array of properties for the movie clip
		*/
		function buttonPropertyGetter(mc:MovieClip, index:Number):Object{
			
			//trace(buttonData[index]);
			mc.addEventListener(MouseEvent.CLICK, buttonHandler);
			
			mc.ButtonData = new Array(buttonData[index]);
			//mc.name = mc.ButtonData[0].Label
			return mc;
		}
		/*Pass this function an array of movie clips and the clips are added to the stage.
		*/
		function placeClips(buttonArray:Array, width:Number, displayList:Array):void{
			clearDisplayList(displayList);
			var yLoca:Number = 50;
			buttonArray[0].x = 0;
			buttonArray[0].y = yLoca;
			addChild(buttonArray[0])
			subCatagoriesDisplayList.push(buttonArray[0]);
			
			for(var index:Number = 1; index < buttonArray.length; index++){
				
				buttonArray[index].x = buttonArray[index - 1].x + (buttonArray[index].width + 10)
				
				if(buttonArray[index].x > width){
					buttonArray[index].x = 0;
					yLoca += 75;
				}
				buttonArray[index].y = yLoca;
				subCatagoriesDisplayList.push(buttonArray[index]);
				addChild(buttonArray[index])
			}
		}
		/*
		*The eventListener for the movie clips;
		*/
		function buttonHandler(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
				trace(mc.ButtonData[0].QueryString);
			
		}
		/*
		*Queries the database for the data used to create the properties for the movie clips
		*/
		public function getBoxInfo():void
		{
			var urlDriver:URLFactory = new URLFactory("http://192.168.1.103:8080/sample/buttongetter?USER=test");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, buttonGetter);
		}
		/*
		*Listener for the urlFactory, on complete sets the buttonData array to the data retrieved. And then calls
		*the setDataProvider method on the list
		*/
		function buttonGetter(event:CustomEvent)
		{
			buttonData = event.data.split("\n");
			buttonData = setDataProvider(buttonData);
			//splitCatagories();
			dispatchEvent(new Event("dataReady"));			
		}
		
		/*
		*This method takes an array of data, splits and returns an object array containing the data needed for the movie clips.
		*
		*/
		function setDataProvider(data:Array):Array{
			var dataProvider:Array = new Array();
			for(var index:Number = 0; index < data.length; index++){
				//trace
				var tArray:Array = data[index].split('","');
				dataProvider.push({Box: tArray[0], SubCatagory: tArray[1], Label: tArray[2], ButtonInfo: tArray[3], QueryString: tArray[4], Destination: tArray[5], IsSignal: tArray[6], SignalOnOff: tArray[7], IsScan: tArray[8], ScanList: tArray[9]})
			}
			
			return dataProvider;
			
		}
		//Listens for the query to the database to complete and calls the createButtonsList and placeClips methods
		function setAllData(event:Event):void{
			createButtonsList(buttonData.length);
			//placeClips(buttons);
		}
		function removeSpaces(string:String):String{
			var pattern:RegExp = /^\s+|\s+$/g;
			string = string.replace(pattern, "")
			return string;
		}

	}
	
}
