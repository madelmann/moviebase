#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Database.Tables.Actors;
import libs.Database.Utils;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
	var collection = new TActorsCollection( Database.Handle, "SELECT * FROM actors ORDER BY name ASC" );

	Json.BeginArray( "actors" );
	foreach ( TActorsRecord record : collection ) {
		Json.BeginObject();
		Json.AddElement( "id", record.Id );
		Json.AddElement( "name", record.Name );
		Json.AddElement( "tags", record.Tags );
		Json.EndObject();
	}
	Json.EndArray();
}

