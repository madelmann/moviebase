
// Library imports
import System.Exception;

// Project imports
import Database;
import Utils;


public void Main(int argc, string args) modify {
	try {
		Utils.parseParameters();

		Database.connect();

		Render();

		Database.disconnect();
	}
	catch ( string e ) {
		print("Exception: " + e);
	}
	catch ( Exception e ) {
		print("Exception: " + e.what());
	}
}

