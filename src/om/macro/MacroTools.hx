package om.macro;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;

class MacroTools {

	public static inline function getCurrentModulePath() : String
		return Context.getPosInfos( (macro null).pos ).file;

	public static function getFileInClassPath( file : String ) : String {
		for( p in Context.getClassPath() ) {
			var path = p + file;
			if( FileSystem.exists( path ) && !FileSystem.isDirectory( path ) )
				return path;
		}
		return null;
	}

	public static function getFullClassName( cls : ClassType ) : String
		return ((cls.pack.length > 0) ? cls.pack.join(".") + "." : "") + cls.name;

	public static inline function getLocalClass() : ClassType
		return Context.getLocalClass().get();

	public static inline function getLocalClassName() : String
		return Context.getLocalClass().toString();

	public static function getMainClass() : String {
		var args = Sys.args();
		return switch [args.indexOf('-main'), args.indexOf('-x')] {
			case [-1, -1]: null;
			case [v, -1] | [_, v]: args[v+1];
		}
	}

	public static function getModuleDirectory( type : String ) : String
		return getModulePath( type ).split( "/" ).slice( 0, -1 ).join( "/" );

	public static function getModulePath( type : String) : String {
    	return switch Context.getType( type ) {
			case TInst(t,_): Context.getPosInfos( t.get().pos ).file;
			case _: throw 'invalid type $type';
		};
	}

	public static inline function here() : Position
		return Context.currentPos();

	public static inline function position( ?pos : Position ) : Position
		return (pos == null) ? Context.currentPos() : pos;

	public static inline function toExpr( v : Dynamic ) : Expr
		return Context.makeExpr( v, Context.currentPos() );

}

#end
