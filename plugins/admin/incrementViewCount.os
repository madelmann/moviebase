#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "itemID" ) ) {
			throw "itemID is missing!";
		}
	
		var itemID = mysql_real_escape_string( Database.Handle, get( "itemID" ) );
		if ( !itemID ) {
			throw "invalid itemID provided!";
		}
	
		Json.AddElement( "id", itemID );
	
		return IncrementViewCount( itemID );
	}
	
	private bool IncrementViewCount( string itemID ) throws {
		var query = "UPDATE items SET views = views + 1 WHERE id = " + itemID;

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}
}
