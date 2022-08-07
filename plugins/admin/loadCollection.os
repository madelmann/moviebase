#!/usr/local/bin/webscript

// library imports
import System.Collections.List;
import System.StringIterator;

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet( "collectionID" ) ) {
			throw "missing collectionID";
		}

		int collectionID = cast<int>( mysql_real_escape_string( Database.Handle, get( "collectionID" ) ) );

		string query = "SELECT c.description, c.id, c.identifier, c.is_public, c.name, c.rating_count, c.rating_value, c.tags, c.type, ci.item_id "
						+ "FROM collections c "
						+ "JOIN collection_items ci ON (c.id = ci.collection_id) "
						+ "JOIN items i ON (ci.item_id = i.id) "
						+ "WHERE c.id = " + collectionID;
		mysql_query( Database.Handle, query );

		int result = mysql_store_result( Database.Handle );
		if ( !result ) {
			throw mysql_error( Database.Handle );
		}

		if ( !mysql_fetch_row( result ) ) {
			throw mysql_error( Database.Handle );
		}

		string description = mysql_get_field_value( result, "description" );
		//string id = mysql_get_field_value( result, "id" );
		string identifier = mysql_get_field_value( result, "identifier" );
		string isPublic = mysql_get_field_value( result, "is_public" );
		string name = mysql_get_field_value( result, "name" );
		int rating_count = cast<int>( mysql_get_field_value( result, "rating_count" ) ); rating_count = rating_count ? rating_count : 0;
		int rating_value = cast<int>( mysql_get_field_value( result, "rating_value" ) ); rating_value = rating_value ? rating_value : 0;
		string tags = mysql_get_field_value( result, "tags" );
		string type = mysql_get_field_value( result, "type" );

		Json.AddElement( "collectionID", collectionID );
		Json.AddElement( "description", description );
		Json.AddElement( "identifier", identifier );
		Json.AddElement( "isPublic", isPublic );
		Json.AddElement( "name", name );
		//Json.AddElement( "tags", tags );
		Json.AddElement( "type", type );
		Json.AddElement( "vote", Utils.prepareRating( rating_value, rating_count ) );

		Json.BeginArray( "items" );
		Json.AddValue( cast<int>( mysql_get_field_value( result, "item_id" ) ) );

		while ( mysql_fetch_row( result ) ) {
			Json.AddValue( cast<int>( mysql_get_field_value( result, "item_id" ) ) );
		}

		Json.EndArray();

		AddTags( tags );

		return true;
	}

	private void AddTags( string tags ) {
		Json.BeginArray( "tags" );

		if ( strlen( tags ) > 1 ) {
			StringIterator it = new StringIterator( tags, "|" );

			while ( it.hasNext() ) {
				Json.BeginObject();
				Json.AddElement( "name", it.next() );
				Json.EndObject();
			}
		}

		Json.EndArray();
	}
}

