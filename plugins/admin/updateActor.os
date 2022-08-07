#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "actorID" ) ) {
			throw "actorID is missing!";
		}

		string actorID = mysql_real_escape_string( Database.Handle, get( "actorID" ) );
		if ( !actorID ) {
			throw "invalid actorID provided!";
		}

		Json.AddElement( "actorID", actorID );

		if ( isSet( "description" ) ) {
			return Database.updateField( TABLE, "description", actorID, mysql_real_escape_string( Database.Handle, get( "description" ) ) );
		}
		if ( isSet( "name" ) ) {
			return Database.updateField( TABLE, "name", actorID, mysql_real_escape_string( Database.Handle, get( "name" ) ) );
		}
		if ( isSet( "tags" ) ) {
			return Database.updateField( TABLE, "tags", actorID, mysql_real_escape_string( Database.Handle, get( "tags" ) ) );
		}

		return false;
	}

	private string TABLE const = "actors";
}

