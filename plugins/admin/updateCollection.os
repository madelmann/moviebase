#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "collectionID" ) ) {
			throw "collectionID is missing!";
		}

		string collectionID = mysql_real_escape_string( Database.Handle, get( "collectionID" ) );
		if ( !collectionID ) {
			throw "invalid collectionID provided!";
		}

		Json.AddElement( "collectionID", collectionID );

		if ( isSet( "description" ) ) {
			return Database.updateField( TABLE, "description", collectionID, mysql_real_escape_string( Database.Handle, get( "description" ) ) );
		}
		if ( isSet( "name" ) ) {
			return Database.updateField( TABLE, "name", collectionID, mysql_real_escape_string( Database.Handle, get( "name" ) ) );
		}
		if ( isSet( "rating" ) ) {
			return SetRating( collectionID, get( "rating" ) );
		}
		if ( isSet( "tags" ) ) {
			return Database.updateField( TABLE, "tags", collectionID, mysql_real_escape_string( Database.Handle, get( "tags" ) ) );
		}

		return false;
	}

	private bool SetRating( string id, string value ) throws {
		string query = "UPDATE items SET rating_count = rating_count + 1, rating_value = rating_value + " + value + " WHERE id = " + id;

		int error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

	private string TABLE const = "collections";
}

