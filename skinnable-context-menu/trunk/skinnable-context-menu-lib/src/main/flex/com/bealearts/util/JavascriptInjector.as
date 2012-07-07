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
/**
	 * Injects Javascript into the container browser
	 */
	public class JavascriptInjector
	{
		public function JavascriptInjector()
		{
			throw new Error("Static class, do not instantiate");
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
	}
}