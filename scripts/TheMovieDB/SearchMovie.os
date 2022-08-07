#!/usr/local/bin/slang

// Library imports
import libParam;

// Project imports
import libs.DataSource.TheMovieDB;
import libs.MainProcessDB;


public void Process( int argc, string args ) modify {
	var params = new ParameterHandler( argc, args );

	string query;
	if ( params.contains( "query" ) ) {
		query = params[ "query" ].Value;
	}
	else {
		write( "Query: " );
		query = cin();
	}

	int page;
	if ( params.contains( "page" ) ) {
		page = cast<int>( params[ "page" ].Value );
	}

	var provider = new Provider();
	var result = provider.searchMovie( query, page );

	foreach ( SearchItem item : result ) {
		print( "Possible title: " + item.title );
	}
}

