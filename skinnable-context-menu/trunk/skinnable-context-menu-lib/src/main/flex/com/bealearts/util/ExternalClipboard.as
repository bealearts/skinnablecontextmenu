/**
 *
 * Copywrite (c) 2011, David Beale
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package com.bealearts.util
{
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;

/**
	 * External Clipboard, with no security restrictions on paste (text only)
	 * 
	 * <p>Deligates to System Clipboard when possible, i.e. all but paste operation,
	 * and use's the browsers clicpboard for paste</p>
	 */
	public class ExternalClipboard
	{
		
		/**
		 * Return Clipboard instance
		 */
		public static function get generalClipboard():ExternalClipboard
		{
			if (!instance)
				instance = new ExternalClipboard(new Guard);
			
			return instance;
		}
		
		
		
		/**
		 * Private Constructor
		 */
		public function ExternalClipboard(guard:Guard)
		{

		}
		
		
		
		/**
		 * @inheritDoc
		 */
		public function setData(format:String, data:Object, serializable:Boolean=true):Boolean
		{
			if (format != ClipboardFormats.TEXT_FORMAT)
				return false;
			
			currentText = String(data);
			Clipboard.generalClipboard.setData(format, data, serializable);
			
			return true;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function getData(format:String, transferMode:String="originalPreferred"):Object
		{
			if (format != ClipboardFormats.TEXT_FORMAT)
				return null;
			
			const browserText:String = getBrowserClipboardData();
			
			if (browserText)
				return browserText;
			else
				return currentText;
		}
		
		
		/**
		 * @inheritDoc 
		 */
		public function clear():void
		{
			currentText = "";
			Clipboard.generalClipboard.clear();
		}

		
		
		/**
		 * @inheritDoc 
		 */
		public function clearData(format:String):void
		{
			currentText = "";
			Clipboard.generalClipboard.clearData(format);
		}
		
		

		/**
		 * @inheritDoc
		 */
		public function hasFormat(format:String):Boolean
		{
			if (format != ClipboardFormats.TEXT_FORMAT)
				return false;
			
			const browserText:String = getBrowserClipboardData();
			
			return (browserText && (browserText != "")) || (currentText != "");				
		}
		
		
		
		/* PRIVATE */
		
		private static var instance:ExternalClipboard;
		
		private var currentText:String = "";
		
		
		/**
		 * Get the text in the browser's clipboard
		 */
		private function getBrowserClipboardData():String
		{
			return null;
		}
	}
}



class Guard
{
	
}