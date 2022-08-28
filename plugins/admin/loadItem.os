#!/usr/local/bin/webscript

// library imports
import System.Collections.List;
import System.StringIterator;

// project imports
import libs.Database.Tables.Items;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public void Constructor() {
		if ( isSet( "identifier" ) ) {
			mIdentifier = mysql_real_escape_string( Database.Handle, get( "identifier" ) );
		}
	}

	public bool Execute() throws {
		if ( !isSet( "itemID" ) ) {
			throw "missing itemID";
		}

		string itemID = mysql_real_escape_string( Database.Handle, get( "itemID" ) );

		var item = new TItemsRecord( Database.Handle, "SELECT * FROM items WHERE id = " + itemID );

		Json.AddElement( "filename", "resources/" + item.Filename );
		Json.AddElement( "is_private", cast<int>( item.IsPrivate ) );
		Json.AddElement( "itemID", itemID );
		Json.AddElement( "text", item.Text ?: "Text" );
		Json.AddElement( "title", item.Title ?: "Title" );
		Json.AddElement( "thumbnail", "resources/thumbs/" + item.Md5sum );
		Json.AddElement( "vote", Utils.prepareRating( item.RatingValue, item.RatingCount ) );

		AddActors( item.Actors );
		AddCollections( item.Id );
		AddTags( item.Tags );

		return true;
	}

	private void AddActors( string actors ) {
		Json.BeginArray( "actors" );

		if ( strlen( actors ) > 1 ) {
			StringIterator it = new StringIterator( actors, "|" );

			while ( it.hasNext() ) {
				Json.BeginObject();
				Json.AddElement( "name", it.next() );
				Json.EndObject();
			}
		}

		Json.EndArray();
	}

	private void AddCollections( int id ) throws {
		string query = "SELECT c.name, ci.id, ci.collection_id \
						FROM collection_items ci \
						LEFT JOIN collections c ON (c.id = ci.collection_id) \
						WHERE ci.item_id = " + id + " AND (c.is_public = 1 OR c.identifier = '" + mIdentifier + "') \
						ORDER BY c.name ASC";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		string collections;

		Json.BeginArray( "collections" );

		int result = mysql_store_result( Database.Handle );
		while ( mysql_fetch_row( result ) ) {
			string collectionID = mysql_get_field_value( result, "collection_id" );
			string itemID = mysql_get_field_value( result, "id" );
			string name = mysql_get_field_value( result, "name" );

			Json.BeginObject();
			Json.AddElement( "collectionID", collectionID );
			Json.AddElement( "itemID", itemID );
			Json.AddElement( "name", name );
			Json.EndObject();
		}

		Json.EndArray();
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

	private string mIdentifier;
}

