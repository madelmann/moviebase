
import System.Collections.Vector;

public object TCollectionTypeRecord {
	public int Id;
	public string Text;

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

	public void deleteByPrimaryKey( int id ) modify throws {
		var query = "DELETE FROM collection_type WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO collection_type ( `id`, `text` ) VALUES ( '" + Id + "', '" + Text + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO collection_type ( `id`, `text` ) VALUES ( '" + Id + "', '" + Text + "' ) ON DUPLICATE KEY UPDATE `text` = '" + Text + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
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

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM collection_type WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
	}

	public void loadByResult( int result ) modify {
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		Text = cast<string>( mysql_get_field_value( result, "text" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TCollectionTypeRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TCollectionTypeRecord { '" + Id + "', '" + Text + "' }";
	}

	private int DB const;
}


public object TCollectionTypeCollection implements ICollection { //<TCollectionTypeRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TCollectionTypeRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TCollectionTypeRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TCollectionTypeRecord first() const {
		return Collection.first();
	}

	public Iterator<TCollectionTypeRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TCollectionTypeRecord last() const {
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
			var record = new TCollectionTypeRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TCollectionTypeRecord( DB );
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

	public void push_back( TCollectionTypeRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TCollectionTypeRecord> Collection;
	private int DB const;
}


