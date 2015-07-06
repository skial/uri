# uri

A little library which adds the `Uri` abstract type.

## Installation

You need to install the following libraries from GitHub.

1. hxparser - `haxelib git hxparse https://github.com/Simn/hxparse development src`
2. mo - `haxelib git mo https://github.com/skial/mo master src`
3. uri - `haxelib git uri https://github.com/skial/uri master src`
	
Then in your `.hxml` file, add `-lib uri` and you're set.

## Usage

```Haxe
package ;

import uhx.types.Uri;

class Main {
	
	public static function main() {
		var uri:Uri = 'http://haxe.io/roundups/326/';
	}
	
}
```

## Notes on parsing

- `Uri::path` and `Uri::directory` will never return beginning with a slash `/`.

## Api

```Haxe
abstract Uri {
	
	public var scheme(get, set):String;
	public var auth(get, never):String;
	public var username(get, set):String;
	public var password(get, set):String;
	public var hostname(get, set):String;
	public var port(get, set):Int;
	public var path(get, never):String;
	public var directory(get, set):String;
	public var directories(get, never):Array<String>;
	public var file(get, never):String;
	public var filename(get, set):String;
	public var extension(get, set):String;
	public var queries(get, never):StringMap<String>;
	public var fragment(get, set):String;
	
}
```