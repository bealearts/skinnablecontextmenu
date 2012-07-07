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
import flash.external.ExternalInterface;

import mx.core.ByteArrayAsset;

/**
	 * Javascript Container Utilities
	 */
	public class JavascriptContainer
	{
		public function JavascriptContainer()
		{
			throw new Error("Static class, do not instantiate");
		}


        /**
        * Containers objectID for the flash player
        */
        public static function get objectID():String
        {
            if (ExternalInterface.available)
                return ExternalInterface.objectID
            else
                return null;
        }

		
		/**
		 * Inject Javascript
		 */
		public static function inject(assetClass:Class):Boolean
		{
			// Can't do anything if there is not a browser!
			if ( !ExternalInterface.available )
				return false;
			

			const asset:ByteArrayAsset = new assetClass();
			
			// Read the javascript
			const jsCode:String = asset.readUTFBytes(asset.bytesAvailable);
			
			// Inject
			ExternalInterface.call('eval', jsCode);

			return true;
		}


        /**
         * Execute Javascript
         */
        public static function execute(code:String):Boolean
        {
            // Can't do anything if there is not a browser!
            if ( !ExternalInterface.available )
                return false;

            ExternalInterface.call('eval', code);

            return true;
        }



	}
}