﻿/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.3
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.libra.utils.ui {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	
	/**
	 * <p>Games often need to get the current state of various keys in order to respond to user input.
	 * This is not the same as responding to key down and key up events, but is rather a case of discovering
	 * if a particular key is currently pressed.</p>
	 *
	 * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code.
	 * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard
	 * is via the keyUp and keyDown events.</p>
	 *
	 * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a
	 * parameter and returning a Boolean.</p>
	 */
	public class KeyPoll extends EventDispatcher {
		
		private static var _instance:KeyPoll;
		
		private var states:ByteArray;
		
		/**
		 * Constructor
		 *
		 * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
		 */
		public function KeyPoll(stage:Stage){
			states = new ByteArray();
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			states.writeUnsignedInt(0);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener, false, 0, true);
			stage.addEventListener(Event.ACTIVATE, activateListener, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, deactivateListener, false, 0, true);
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			return hasEventListener(event.type) ? super.dispatchEvent(event) : false;
		}
		
		private function keyDownListener(ev:KeyboardEvent):void {
			states[ev.keyCode >>> 3] |= 1 << (ev.keyCode & 7);
			dispatchEvent(ev);
		}
		
		private function keyUpListener(ev:KeyboardEvent):void {
			states[ev.keyCode >>> 3] &= ~(1 << (ev.keyCode & 7));
			dispatchEvent(ev);
		}
		
		private function activateListener(ev:Event):void {
			for (var i:int = 0; i < 32; ++i){
				states[i] = 0;
			}
		}
		
		private function deactivateListener(ev:Event):void {
			for (var i:int = 0; i < 32; ++i){
				states[i] = 0;
			}
		}
		
		/**
		 * To test whether a key is down.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is down, false otherwise.
		 *
		 * @see isUp
		 */
		public function isDown(keyCode:uint):Boolean {
			return (states[keyCode >>> 3] & (1 << (keyCode & 7))) != 0;
		}
		
		/**
		 * To test whether a key is up.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is up, false otherwise.
		 *
		 * @see isDown
		 */
		public function isUp(keyCode:uint):Boolean {
			return (states[keyCode >>> 3] & (1 << (keyCode & 7))) == 0;
		}
		
		public static function getInstance(stage:Stage):KeyPoll{
			if(!_instance){
				_instance = new KeyPoll(stage);
			}
			return _instance;
		}
	}
}