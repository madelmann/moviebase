
import Database;

public namespace Database {

	////////////////////////////////////////////////////////////////////////////////
	// Query utils

	public int QueryResult;

	public int AffectedRows() throws {
		return mysql_affected_rows( Database.Handle );
	}

	public bool Execute( string query ) throws {
		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

	public bool FetchRow() throws {
		if ( !mysql_fetch_row( QueryResult ) ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

	public string GetError() throws {
		return mysql_error( Database.Handle );
	}

	public string GetFieldValue( string field ) throws {
		return mysql_get_field_value( QueryResult, field );
	}

	public int Query( string query ) throws {
		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		QueryResult = mysql_store_result( Database.Handle );
		if ( !QueryResult ) {
			throw mysql_error( Database.Handle );
		}

		return QueryResult;
	}

	// Query utils
	////////////////////////////////////////////////////////////////////////////////

	public int getLastInsertId() const throws {
		var query = "SELECT LAST_INSERT_ID() AS id;";

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		if ( !result ) {
			throw mysql_error( Database.Handle );
		}

		if ( !mysql_fetch_row( result ) ) {
			throw mysql_error( Database.Handle );
		}

		return cast<int>( mysql_get_field_value( result, "id" ) );
	}

	public string prepareEncrypt( string text, string salt = "", int strength = 256 ) const {
		return "SHA2( '" + text + salt + "', " + strength + " )";
	}

	public string retrieveField( string table, string field, string id ) throws {
		if ( !field || !id || !table ) {
			throw "invalid query data provided!";
		}

		var query = "SELECT " + field + " FROM " + table + " WHERE id = " + id;

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		var result = mysql_store_result( Database.Handle );
		if ( !mysql_fetch_row( result ) ) {
			throw mysql_error( Database.Handle );
		}

		return mysql_get_field_value( result, field );
	}

	public bool updateField( string table, string field, string id, string value ) throws {
		if ( !field || !id || !table ) {
			return false;
		}

		var query = "UPDATE " + table + " SET " + field + " = '" + value + "' WHERE id = " + id;

		var error = mysql_query( Database.Handle, query );
		if ( error ) {
			throw mysql_error( Database.Handle );
		}

		return true;
	}

}

