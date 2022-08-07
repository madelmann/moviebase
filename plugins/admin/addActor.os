#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "id" ) ) {
			throw "id is missing!";
		}

		string id = mysql_real_escape_string( Database.Handle, get( "id" ) );
		if ( !id ) {
			throw "invalid id provided!";
		}

		Json.AddElement( "id", id );

		if ( isSet("actor") ) {
			string original = GetActors( id );
			string actor = get( "actor" );

			string newValue = !original ? actor : original + "|" + actor;

			return SetActors( id, mysql_real_escape_string( Database.Handle, newValue ) );
		}

		throw "actor is missing!";
	}

	private string GetActors( string id ) {
		return Database.retrieveField( TABLE, "actors", id );
	}

	private bool SetActors( string id, string value ) {
		return Database.updateField( TABLE, "actors", id, value );
	}

	private string TABLE const = "items";
}

