
import System.Collections.Vector;

public object VUserSessionRecord {
	public string Created;
	public string Expires;
	public string Id;
	public string Identifier;
	public string IpAddress;
	public int IsAdmin;
	public string Language;
	public string Username;

	public void Constructor( int databaseHandle ) {
		DB = databaseHandle;
	}

	public void Constructor( int databaseHandle, string query ) {
		DB = databaseHandle;

		loadByQuery( query );
	}

	public void Constructor( int databaseHandle, int result ) {
		DB = databaseHandle;

		loadByResult( result );
	}

	public void loadByQuery( string query ) modify throws {
		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Expires = cast<string>( mysql_get_field_value( result, "expires" ) );
		Id = cast<string>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IpAddress = cast<string>( mysql_get_field_value( result, "ip_address" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		Language = cast<string>( mysql_get_field_value( result, "language" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public void loadByPrimaryKey( string id ) modify throws {
		var query = "SELECT * FROM v_user_session WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Expires = cast<string>( mysql_get_field_value( result, "expires" ) );
		Id = cast<string>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IpAddress = cast<string>( mysql_get_field_value( result, "ip_address" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		Language = cast<string>( mysql_get_field_value( result, "language" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public void loadByResult( int result ) modify {
		Created = cast<string>( mysql_get_field_value( result, "created" ) );
		Expires = cast<string>( mysql_get_field_value( result, "expires" ) );
		Id = cast<string>( mysql_get_field_value( result, "id" ) );
		Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
		IpAddress = cast<string>( mysql_get_field_value( result, "ip_address" ) );
		IsAdmin = cast<int>( mysql_get_field_value( result, "is_admin" ) );
		Language = cast<string>( mysql_get_field_value( result, "language" ) );
		Username = cast<string>( mysql_get_field_value( result, "username" ) );
	}

	public bool operator==( VUserSessionRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "VUserSessionRecord { NULLIF('" + Created + "', ''), NULLIF('" + Expires + "', ''), '" + Id + "', '" + Identifier + "', '" + IpAddress + "', '" + IsAdmin + "', '" + Language + "', '" + Username + "' }";
	}

	private int DB const;
}


public object VUserSessionCollection implements ICollection /*<VUserSessionRecord>*/ {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<VUserSessionRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public VUserSessionRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public VUserSessionRecord first() const {
		return Collection.first();
	}

	public Iterator<VUserSessionRecord> getIterator() const {
		return Collection.getIterator();
	}

	public VUserSessionRecord last() const {
		return Collection.last();
	}

	public void loadByQuery( string query ) modify throws {
		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		Collection.clear();

		var result = mysql_store_result( DB );
		while ( mysql_fetch_row( result ) ) {
			var record = new VUserSessionRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new VUserSessionRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void pop_back() modify {
		Collection.pop_back();
	}

	public void pop_front() modify {
		Collection.pop_front();
	}

	public int size() const {
		return Collection.size();
	}

	public void push_back( VUserSessionRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<VUserSessionRecord> Collection;
	private int DB const;
}

