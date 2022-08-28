
import libs.Config;
import Utils;

private namespace Database {

	public int Handle;

	public bool connect() throws {
		// initializing MySQL handle
		Handle = mysql_init();

		// connecting to MySQL database
		Handle = mysql_real_connect( Handle, Config.Database.Host, Config.Database.Port, Config.Database.User, Config.Database.Password, Config.Database.Database );
		if (  !Handle ) {
			throw "failed to initialize mysql connection!";
		}

		return true;
	}

	public bool disconnect() throws {
		if ( !Handle ) {
			throw "invalid mysql handle!";
		}

		// disconnect from MySQL database
		mysql_close( Handle );

		return true;
	}

	public void printSettings() const {
		print( "Host = " + Config.Database.Host );
		print( "User = " + Config.Database.User );
		print( "Database = " + Config.Database.Database );
	}

	////////////////////////////////////////////////////////////////////////////////
	// Transactions

	public void begin() throws {
		string query = "begin";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}
	}

	public void commit() throws {
		string query = "commit";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}
	}

	public void rollback() throws {
		string query = "rollback";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}
	}

	// Transactions
	////////////////////////////////////////////////////////////////////////////////

}

