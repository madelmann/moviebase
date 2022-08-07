#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "itemID" ) ) {
			throw "itemID is missing!";
		}
	
		string itemID = mysql_real_escape_string( Database.Handle, get( "itemID" ) );
		if ( !itemID ) {
			throw "invalid itemID provided!";
		}
	
		Json.AddElement( "id", itemID );
	
		return UnhideVideo( itemID );
	}

	private bool UnhideVideo( string itemID ) throws {
		string query = "UPDATE items SET last_modified = NOW(), deleted = false WHERE id = " + itemID;

		int error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}
}

