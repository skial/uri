package ;

import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.Uri;
import haxe.ds.StringMap;
import uhx.lexer.Uri.UriKeywords;

typedef Tokens = Array<Token<UriKeywords>>;

/**
 * ...
 * @author Skial Bainn
 */
abstract Uri(Tokens) from Tokens to Tokens {
	
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
	public var queries(get, never):StringMap<String>;	// TODO
	public var fragment(get, set):String;
	
	public inline function new(v:Tokens) {
		this = v;
		trace( v );
	}
	
	@:noCompletion @:from public static inline function fromString(v:String):Uri {
		return new Uri( new uhx.parser.Uri().toTokens( ByteData.ofString( v ), 'uri-abstract' ) );
	}
	
	@:to public function toString():String {
		var directories = 0;
		var queries = 0;
		return [for (token in this) switch(token) {
			case Keyword(Scheme(v)): '$v:\\';
			case Keyword(Auth(u, p)): '$u:$p@';
			case Keyword(Host(v)): v;
			case Keyword(Port(v)): ':$v';
			case Keyword(Directory(v)): 
				(switch (directories) {
					case 0: 
						directories++;
						'';
					case _: 
						directories++;
						'/';
				}) + v;
			case Keyword(File(v)): '/v';
			case Keyword(Extension(v)): '.$v';
			case Keyword(Query(n, v)):
				(switch (queries) {
					case 0: 
						queries++;
						'?';
					case _: 
						queries++;
						'&';
				}) + '$n=$v';
			case Keyword(Fragment(v)): '#$v';
			case _: '';
		}].join('');
	}
	
	private inline function get_scheme():String {
		return this[0].match( Keyword(Scheme(_)) ) ? switch (this[0]) {
			case Keyword(Scheme(v)): v;
			case _: '';
		} : '';
	}
	
	private inline function set_scheme(v:String):String {
		if (this[0].match( Keyword(Scheme(_)) )) {
			this[0] = Keyword(Scheme(v));
			
		} else {
			this.unshift( Keyword(Scheme(v)) );
			
		}
		return v;
	}
	
	private inline function get_auth():String {
		var result = '';
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Auth(u, p)): 
				result = '$u:$p';
				break;
				
			case _: 
				if (i > 2) break;
				
		}
		
		return result;
	}
	
	private inline function get_username():String {
		var result = '';
		
		for (i in 0...this.length) switch(this[i]) {
			case Keyword(Auth(u, _)): 
				result = u;
				break;
				
			case _:
				if (i > 2) break;
				
		}
		
		return result;
	}
	
	private inline function set_username(v:String):String {
		var index = -1;
		var previous = null;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Auth(_, p)):
				previous = p;
				index = i;
				break;
				
			case _:
				if (i > 2) break;
				
		}
		
		if (this[index].match( Keyword(Auth(_, _)) )) {
			this[index] = Keyword(Auth(v, previous));
			
		} else {
			this.insert( index + 1, Keyword(Auth(v, '')) );
			
		}
		
		return v;
	}
	
	private inline function get_password():String {
		var result = '';
		
		for (i in 0...this.length) switch(this[i]) {
			case Keyword(Auth(_, p)): 
				result = p;
				break;
				
			case _:
				if (i > 2) break;
				
		}
		
		return result;
	}
	
	private inline function set_password(v:String):String {
		var index = -1;
		var previous = null;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Auth(u, _)):
				previous = u;
				index = i;
				break;
				
			case _:
				if (i > 2) break;
				
		}
		
		if (this[index].match( Keyword(Auth(_, _)) )) {
			this[index] = Keyword(Auth(previous, v));
			
		} else {
			this.insert( index + 1, Keyword(Auth('', v)) );
			
		}
		
		return v;
	}
	
	private inline function get_hostname():String {
		var result = '';
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Host(v)):
				result = v;
				break;
				
			case _:
				if (i > 3) break;
				
		}
		
		return result;
	}
	
	private inline function set_hostname(v:String):String {
		var index = -1;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Host(_)):
				index = i;
				break;
				
			case _:
				if (i > 3) break;
				
		}
		
		if (this[index].match( Keyword(Host(_)) )) {
			this[index] = Keyword(Host(v));
			
		} else {
			this.insert( index + 1, Keyword(Host(v)) );
			
		}
		
		return v;
	}
	
	private inline function get_port():Int {
		var result = 80;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Port(v)):
				result = Std.parseInt( v );
				break;
				
			case _:
				if (i > 4) break;
				
		}
		
		return result;
	}
	
	private inline function set_port(v:Int):Int {
		var index = -1;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Port(_)):
				index = i;
				break;
				
			case _:
				if (i > 4) break;
				
		}
		
		if (this[index].match( Keyword(Port(_)) )) {
			this[index] = Keyword(Port('$v'));
			
		} else {
			this.insert( index + 1, Keyword(Port('$v')) );
			
		}
		
		return v;
	}
	
	private inline function get_path():String {
		return [for (token in this) switch (token) {
			case Keyword(Directory(v)): '/$v';
			case Keyword(File(v)): '/$v';
			case Keyword(Extension(v)): '.$v';
			case _: '';
		}].join('');
	}
	
	private inline function get_directory():String {
		return [for (token in this) switch (token) {
			case Keyword(Directory(v)): v;
			case _: '';
		}].join('/');
	}
	
	private inline function set_directory(v:String):String {
		var start = -1;
		var end = -1;
		
		for (i in 0...this.length) switch (this[i]) {
			case Keyword(Directory(_)) if(start == -1):
				start = i;
				
			case Keyword(Directory(_)) if(end == -1):
				end = i;
				
			case _:
				
		}
		
		if (start > -1) {
			var directories = [for (part in v.split('/')) Keyword(Directory(part))];
			var head = this.slice(0, start);
			var tail = end > -1 ? this.slice(end) : [];
			this = head.concat( directories.concat( tail ) );
			
		}
		
		return v;
	}
	
	private inline function get_directories():Array<String> {
		return [for (token in this) switch (token) {
			case Keyword(Directory(v)): v;
			case _: '';
		}];
	}
	
	private inline function get_file():String {
		var result = '';
		
		for (token in this) switch(token) {
			case Keyword(File(v)): result += v;
			case Keyword(Extension(v)): result += '.$v';
			case _:
		}
		
		return result;
	}
	
	private inline function get_filename():String {
		var result = '';
		
		for (token in this) switch (token) {
			case Keyword(File(v)):
				result = v;
				break;
				
			case _:
				
		}
		
		return result;
	}
	
	private inline function set_filename(v:String):String {
		var index = this.length - 1;
		
		while (index > 0) {
			switch (this[index]) {
				case Keyword(File(_)):
					break;
					
				case _:
					
			}
			
			index--;
		}
		
		if (index > -1) {
			this[index] = Keyword(File(v));
			
		} else {
			this.push( Keyword(File(v)) );
			
		}
		
		return v;
	}
	
	private inline function get_extension():String {
		var result = '';
		
		for (token in this) switch (token) {
			case Keyword(Extension(v)):
				result = v;
				break;
				
			case _:
				
		}
		
		return result;
	}
	
	private inline function set_extension(v:String):String {
		var index = this.length - 1;
		
		while (index > 0) {
			switch (this[index]) {
				case Keyword(Extension(_)):
					break;
					
				case _:
					
			}
			
			index--;
		}
		
		if (index > -1) {
			this[index] = Keyword(Extension(v));
			
		} else {
			this.push( Keyword(Extension(v)) );
			
		}
		
		return v;
	}
	
	private inline function get_queries():StringMap<String> {
		var results = new StringMap<String>();
		
		for (token in this) switch (token) {
			case Keyword(Query(n, v)):
				results.set(n, v);
				
			case _:
				
		}
		
		return results;
	}
	
	private inline function get_fragment():String {
		var result = '';
		
		for (token in this) switch (token) {
			case Keyword(Fragment(v)):
				result = v;
				break;
				
			case _:
				
		}
		
		return result;
	}
	
	private inline function set_fragment(v:String):String {
		var index = this.length - 1;
		
		while (index > 0) {
			switch (this[index]) {
				case Keyword(Fragment(_)):
					break;
					
				case _:
					
			}
			
			index--;
		}
		
		if (index > -1) {
			this[index] = Keyword(Fragment(v));
			
		} else {
			this.push( Keyword(Fragment(v)) );
			
		}
		
		return v;
	}
	
}