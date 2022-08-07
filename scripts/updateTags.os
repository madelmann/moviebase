#!/usr/local/bin/slang

// library imports

// project imports
import libs.Database.Utils;
import TagProcessor;


public int Main(int argc, string args) {
	if ( !Database.connect() ) {  // connect to database
		cerr("could not connect to database!");
		return -1;
	}

	try {
		var tagProcessor = new TagProcessor(Database.Handle);
		tagProcessor.process();
	}
	catch ( string e ) {
		print("Exception: " + e);
	}
	catch ( IException e ) {
		print("Exception: " + e.what());
	}

	if ( !Database.disconnect() ) {	// disconnect from database
		cerr("could not disconnect from database!");
		return -2;
	}

	return 0;
}

