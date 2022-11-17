#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Database.Tables.Items;
import libs.Database.Utils;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
	var collection = new TItemsCollection( Database.Handle, "SELECT * FROM items WHERE deleted = FALSE AND is_private = FALSE ORDER BY title ASC" );

	Json.BeginArray( "items" );
	foreach ( TItemsRecord record : collection ) {
		Json.BeginObject();
		Json.AddElement( "actors", record.Actors );
		Json.AddElement( "id", record.Id );
		Json.AddElement( "title", record.Title );
		Json.AddElement( "tags", record.Tags );
		Json.EndObject();
	}
	Json.EndArray();
}

