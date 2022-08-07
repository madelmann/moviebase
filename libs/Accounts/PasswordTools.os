
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
import libs.Database;
import libs.Session;


public namespace Accounts {

	public bool ChangePassword( string identifier, string password ) throws {
		Database.begin();

		Database.Execute(
			"UPDATE users SET password = " + Database.prepareEncrypt( password ) + " WHERE identifier = '" + identifier + "' AND deleted = FALSE"
		);

		if ( !Database.AffectedRows() ) {
			throw "nothing updated!";
		}

		Database.commit();

		return true;
	}

	public bool ResetPassword( string username ) throws {
		// create random password
		srand( time() );
		string password = rand();

		Database.begin();

		Database.Execute(
			"UPDATE users SET password = " + Database.prepareEncrypt( password ) + " WHERE username = '" + username + "' AND deleted = FALSE"
		);

		if ( !Database.AffectedRows() ) {
			throw "nothing updated!";
		}

		// we need the user's identifier to send him a notification
		Database.Query( "SELECT identifier FROM users where username = '" + username + "'" );
		if ( !Database.FetchRow() ) {
			throw Database.GetError();
		}

		Database.commit();

		return true;
	}

}
