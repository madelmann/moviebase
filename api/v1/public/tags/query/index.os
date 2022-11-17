#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Database.Tables.Tags;
import libs.Database.Utils;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
	var collection = new TTagsCollection( Database.Handle, "SELECT * FROM tags ORDER BY name ASC" );

	Json.BeginArray( "tags" );
	foreach ( TTagsRecord record : collection ) {
		Json.BeginObject();
		Json.AddElement( "id", record.Id );
		Json.AddElement( "name", record.Name );
		Json.EndObject();
	}
	Json.EndArray();
}

