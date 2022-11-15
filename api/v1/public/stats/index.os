#!/usr/local/bin/webscript

// library imports
import System.Collections.Set;
import System.StringIterator;

// project imports
import libs.API;
import libs.Database.Tables.Stats;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
	var query = "SELECT * FROM stats ORDER BY stats_key ASC";

	var error = mysql_query( Database.Handle, query );
	if ( error ) {
		throw mysql_error( Database.Handle );
	}

	var result = mysql_store_result( Database.Handle );

	while ( mysql_fetch_row( result ) ) {
		Json.AddElement(
			mysql_get_field_value( result, "stats_key" ),
			mysql_get_field_value( result, "stats_value" )
		);
	}
}

