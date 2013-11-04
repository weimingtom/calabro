/**
 * Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 *
 *	addChild( new Stats() );
 *
 *	or
 *
 *	addChild( new Stats( { bg: 0xffffff } );
 *
 * version log:
 *
 *	09.10.22		2.2		Mr.doob			+ FlipX of graph to be more logic.
 *											+ Destroy on Event.REMOVED_FROM_STAGE (thx joshtynjala)
 *	09.03.28		2.1		Mr.doob			+ Theme support.
 *	09.02.21		2.0		Mr.doob			+ Removed Player version, until I know if it's really needed.
 *											+ Added MAX value (shows Max memory used, useful to spot memory leaks)
 *											+ Reworked text system / no memory leak (original reason unknown)
 *											+ Simplified
 *	09.02.07		1.5		Mr.doob			+ onRemovedFromStage() (thx huihuicn.xu)
 *	08.12.14		1.4		Mr.doob			+ Code optimisations and version info on MOUSE_OVER
 *	08.07.12		1.3		Mr.doob			+ Some speed and code optimisations
 *	08.02.15		1.2		Mr.doob			+ Class renamed to Stats (previously FPS)
 *	08.01.05		1.2		Mr.doob			+ Click changes the fps of flash (half up increases, half down decreases)
 *	08.01.04		1.1		Mr.doob			+ Shameless ripoff of Alternativa's FPS look :P
 *							Theo			+ Log shape for MEM
 *											+ More room for MS
 * 	07.12.13		1.0		Mr.doob			+ First version
 **/

package com.qzone.qfa.debug
{
	import com.snsapp.starling.texture.implement.TextureBase;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class Stats extends Sprite
	{
		protected const WIDTH:uint = 70;
		protected const HEIGHT:uint = 100;

		protected var xml:XML;

		protected var text:TextField;
		protected var style:StyleSheet;

		protected var timer:uint;
		protected var fps:uint;
		protected var ms:uint;
		protected var ms_prev:uint;
		protected var mem:Number;
		protected var mem_max:Number;

		protected var graph:Bitmap;
		protected var rectangle:Rectangle;

		protected var fps_graph:uint;
		protected var mem_graph:uint;
		protected var mem_max_graph:uint;

		protected static var theme:Object = { //
				bg: 0x000033, // 
				fps: 0xffff00, //
				ms: 0x00ff00, //
				mem: 0x00ffff, //
				memmax: 0xff0070, //
				texture: 0x333fff};

		/**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 *
		 * @param _theme         Example: { bg: 0x202020, fps: 0xC0C0C0, ms: 0x505050, mem: 0x707070, memmax: 0xA0A0A0 }
		 */
		private var _stage:Stage;

		public function Stats(_theme:Object = null):void
		{
			if (_theme)
			{
				if (_theme.bg != null)
					theme.bg = _theme.bg;
				if (_theme.fps != null)
					theme.fps = _theme.fps;
				if (_theme.ms != null)
					theme.ms = _theme.ms;
				if (_theme.mem != null)
					theme.mem = _theme.mem;
				if (_theme.memmax != null)
					theme.memmax = _theme.memmax;
				if (_theme.stage != null)
					_stage = _theme.stage;
			}

			mem_max = 0;
			xml = <xml>
					<fps>FPS:</fps>
					<freemem>FREE:</freemem>
					<mem>MEM:</mem>
					<memMax>MAX:</memMax>
					<tex>TEX:</tex>
				 </xml>;

			style = new StyleSheet();
			style.setStyle("xml", {fontSize: '10px', fontFamily: '_sans', leading: '-2px'});
			style.setStyle("fps", {color: hex2css(theme.fps)});
			style.setStyle("freemem", {color: hex2css(theme.ms)});
			style.setStyle("mem", {color: hex2css(theme.mem)});
			style.setStyle("tex", {color: hex2css(theme.texture)});
			style.setStyle("memMax", {color: hex2css(theme.memmax)});

			text = new TextField();
			text.width = WIDTH;
			text.height = 100;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;

			graph = new Bitmap();
			graph.y = 50;

			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);

			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}

		private function init(e:Event):void
		{
			graphics.beginFill(theme.bg);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();

			addChild(text);

			graph.bitmapData = new BitmapData(WIDTH, HEIGHT - 50, false, theme.bg);
			addChild(graph);

			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function destroy(e:Event):void
		{
			graphics.clear();

			while (numChildren > 0)
				removeChildAt(0);

			graph.bitmapData.dispose();

			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ENTER_FRAME, update);
		}

		private function update(e:Event):void
		{
			timer = getTimer();

			if (timer - 1000 > ms_prev)
			{
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;

				fps_graph = Math.min(graph.height, (fps / _stage.frameRate) * graph.height);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;

				graph.bitmapData.scroll(-1, 0);

				graph.bitmapData.fillRect(rectangle, theme.bg);
				graph.bitmapData.setPixel(graph.width - 1, graph.height - fps_graph, theme.fps);
				graph.bitmapData.setPixel(graph.width - 1, graph.height - ((timer - ms) >> 1), theme.ms);
				graph.bitmapData.setPixel(graph.width - 1, graph.height - mem_graph, theme.mem);
				graph.bitmapData.setPixel(graph.width - 1, graph.height - mem_max_graph, theme.memmax);
				graph.bitmapData.setPixel(graph.width - 1, graph.height - mem_max_graph, theme.memmax);

				xml.fps = "FPS: " + fps + " / " + _stage.frameRate;
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;
				xml.tex = "TEX: " + Number((TextureBase.SIZE * 0.000000954).toFixed(3));
				xml.freemem = "TOTAL: " + Number((System.privateMemory * 0.000000954).toFixed(3));

				fps = 0;
			}

			fps++;

			ms = timer;

			text.htmlText = xml;
		}

		private function onClick(e:MouseEvent):void
		{
			mouseY / height > .5 ? _stage.frameRate-- : _stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + _stage.frameRate;
			text.htmlText = xml;
		}

		// .. Utils

		private function hex2css(color:int):String
		{
			return "#" + color.toString(16);
		}
	}
}
