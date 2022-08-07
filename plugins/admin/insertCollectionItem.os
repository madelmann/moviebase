#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "collectionID" ) ) {
			return false;
		}
		if ( !isSet( "itemID" ) ) {
			return false;
		}

		string collectionID = mysql_real_escape_string( Database.Handle, get( "collectionID" ) );
		string itemID = mysql_real_escape_string( Database.Handle, get( "itemID" ) );

		Json.AddElement( "id", itemID );

		return AddCollectionItem( collectionID, itemID );
	}

	private bool AddCollectionItem( string collectionID, string itemID ) throws {
		string query = "INSERT INTO collection_items (collection_id, item_id) VALUES (" + collectionID + ", " + itemID + ")";

		int error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}
}
