
// library import
import libJsonBuilder.StructuredBuilder;
import System.Exception;

// project imports
import Database;
import Utils;


public void Main( int argc, string args ) modify {
	try {
		Utils.parseParameters();

		Database.connect();

		Process( argc, args );

		Database.disconnect();
	}
	catch ( string e ) {
		Json.AddElement( "message", e );
	}
	catch ( IException e ) {
		Json.AddElement( "message", e.what() );
	}

	print( Json.GetString() );
}

