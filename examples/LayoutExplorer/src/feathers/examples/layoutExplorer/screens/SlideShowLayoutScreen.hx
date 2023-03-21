package feathers.examples.layoutExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;
import feathers.examples.layoutExplorer.data.SlideShowLayoutSettings;
import feathers.layout.SlideShowLayout;
import feathers.system.DeviceCapabilities;
import starling.core.Starling;
import starling.display.Quad;
import starling.events.Event;

class SlideShowLayoutScreen extends PanelScreen 
{
	public static inline var SHOW_SETTINGS:String = "showSettings";
	
	public function new() 
	{
		super();
	}
	
	public var settings:SlideShowLayoutSettings;
	
	override function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();
		
		this.title = "Slide Show Layout";
		
		this.layout = new SlideShowLayout();
		//with this layout, you should always snap to pages
		this.snapToPages = true;
		
		var layout:SlideShowLayout = new SlideShowLayout();
		layout.paddingTop = this.settings.paddingTop;
		layout.paddingRight = this.settings.paddingRight;
		layout.paddingBottom = this.settings.paddingBottom;
		layout.paddingLeft = this.settings.paddingLeft;
		layout.horizontalAlign = this.settings.horizontalAlign;
		layout.verticalAlign = this.settings.verticalAlign;
		
		var minQuadSize:Float = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) / 2;
		var size:Float;
		var quad:Quad;
		for (i in 0...this.settings.itemCount)
		{
			size = (minQuadSize + minQuadSize * 0.5 * Math.random());
			quad = new Quad(size, size, 0xff8800);
			this.addChild(quad);
		}
		
		this.layout = layout;
		
		this.headerFactory = this.customHeaderFactory;
		
		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if (!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this.backButtonHandler = this.onBackButton;
		}
		
		this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
	}
	
	private function customHeaderFactory():Header
	{
		var header:Header = new Header();
		//this screen doesn't use a back button on tablets because the main
		//app's uses a split layout
		if (!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			var backButton:Button = new Button();
			backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
			header.leftItems = 
			[
				backButton
			];
		}
		var settingsButton:Button = new Button();
		settingsButton.label = "Settings";
		settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
		header.rightItems = 
		[
			settingsButton
		];
		return header;
	}
	
	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function transitionInCompleteHandler(event:Event):Void
	{
		this.revealScrollBars();
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		this.dispatchEventWith(SHOW_SETTINGS);
	}
}