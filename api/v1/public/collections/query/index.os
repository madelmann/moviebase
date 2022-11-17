#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Database.Tables.Collections;
import libs.Database.Utils;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
	var collection = new TCollectionsCollection( Database.Handle, "SELECT * FROM collections WHERE is_public = TRUE ORDER BY name ASC" );

	Json.BeginArray( "collections" );
	foreach ( TCollectionsRecord record : collection ) {
		Json.BeginObject();
		Json.AddElement( "id", record.Id );
		Json.AddElement( "name", record.Name );
		Json.AddElement( "tags", record.Tags );
		Json.EndObject();
	}
	Json.EndArray();
}

