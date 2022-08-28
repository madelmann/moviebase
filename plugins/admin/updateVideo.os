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

		if ( isSet( "filename" ) ) {
			return SetFilename( itemID, mysql_real_escape_string( Database.Handle, get( "filename" ) ) );
		}
		else if ( isSet( "is_private" ) ) {
			return SetPrivate( itemID, mysql_real_escape_string( Database.Handle, get( "is_private" ) ) );
		}
		else if ( isSet( "rating" ) ) {
			return SetRating( itemID, mysql_real_escape_string( Database.Handle, get( "rating" ) ) );
		}
		else if ( isSet( "text" ) ) {
			return SetText( itemID, mysql_real_escape_string( Database.Handle, get( "text" ) ) );
		}
		else if ( isSet( "title" ) ) {
			return SetTitle( itemID, mysql_real_escape_string( Database.Handle, get( "title" ) ) );
		}

		return false;
	}

	private bool SetFilename( string id, string value ) {
		return Database.updateField( TABLE, "filename", id, value );
	}

	private bool SetPrivate( string id, string value ) {
		return Database.updateField( TABLE, "is_private", id, value );
	}

	private bool SetRating( string id, string value ) throws {
		var query = "UPDATE items SET rating_count = rating_count + 1, rating_value = rating_value + " + value + " WHERE id = " + id;

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

	private bool SetTags( string id, string value ) {
		return Database.updateField( TABLE, "tags", id, value );
	}

	private bool SetText( string id, string value ) {
		return Database.updateField( TABLE, "text", id, value );
	}

	private bool SetTitle( string id, string value ) {
		return Database.updateField( TABLE, "title", id, value );
	}

	private string TABLE const = "items";
}

";
}

