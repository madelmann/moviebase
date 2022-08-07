#!/usr/local/bin/slang

// library imports

// project imports
import libs.Config.Config;
import libs.Database;


public int Main( int argc, string args ) throws {
	if ( !Database.connect() ) {
		cerr( "could not connect to database!" );
		return -1;
	}

	// TODO: query and delete items
	var query = "SELECT * FROM items WHERE deleted = 1";

	var error = mysql_query( Database.Handle, query );
	if ( error ) {
		throw mysql_error( Database.Handle );
	}

	var result = mysql_store_result( Database.Handle );
	if ( !result ) {
		throw "no result found";
	}

	while ( mysql_fetch_row( result ) ) {
		var filename = mysql_get_field_value( result, "filename" ); 
		var md5sum   = mysql_get_field_value( result, "md5sum" ); 
		var title    = mysql_get_field_value( result, "title" );

		write( "Removing '" + title + "': " );

		write( "Thumbnail, " );
		removeThumbnail( md5sum );

		write( "Video, " );
		removeVideo( filename );

		writeln( "Item" );
		removeItem( md5sum );
	}

	// disconnect from database
	if ( !Database.disconnect() ) {
		cerr( "could not disconnect from database!" );
		return -1;
	}

	return 0;
}

private void removeItem( string md5sum ) throws {
	var query = "DELETE FROM items WHERE md5sum = '" + md5sum + "'";

	var error = mysql_query( Database.Handle, query );
	if ( error ) {
		throw mysql_error( Database.Handle );
	}
}

private void removeThumbnail( string md5sum ) throws {
	string command = "mv '" + Config.BASE_FOLDER + "/resources/thumbs/" + md5sum + "' '" + Config.BASE_FOLDER + "/resources/deleted/" + "'";

	system( command );
}

private void removeVideo( string filename ) throws {
	string command = "mv '" + Config.BASE_FOLDER + "/resources/" + filename + "' '" + Config.BASE_FOLDER + "/resources/deleted/" + "'";

	system( command );
}


