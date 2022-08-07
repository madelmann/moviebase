
import System.Collections.Vector;

public object TCollectionItemsRecord {
	public int CollectionId;
	public int Id;
	public int ItemId;

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
		var query = "DELETE FROM collection_items WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO collection_items ( `collection_id`, `id`, `item_id` ) VALUES ( '" + CollectionId + "', '" + Id + "', '" + ItemId + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO collection_items ( `collection_id`, `id`, `item_id` ) VALUES ( '" + CollectionId + "', '" + Id + "', '" + ItemId + "' ) ON DUPLICATE KEY UPDATE `collection_id` = '" + CollectionId + "', `item_id` = '" + ItemId + "'";

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

		CollectionId = cast<int>( mysql_get_field_value( result, "collection_id" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		ItemId = cast<int>( mysql_get_field_value( result, "item_id" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM collection_items WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		CollectionId = cast<int>( mysql_get_field_value( result, "collection_id" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		ItemId = cast<int>( mysql_get_field_value( result, "item_id" ) );
	}

	public void loadByResult( int result ) modify {
		CollectionId = cast<int>( mysql_get_field_value( result, "collection_id" ) );
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		ItemId = cast<int>( mysql_get_field_value( result, "item_id" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TCollectionItemsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TCollectionItemsRecord { '" + CollectionId + "', '" + Id + "', '" + ItemId + "' }";
	}

	private int DB const;
}


public object TCollectionItemsCollection implements ICollection { //<TCollectionItemsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TCollectionItemsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TCollectionItemsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TCollectionItemsRecord first() const {
		return Collection.first();
	}

	public Iterator<TCollectionItemsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TCollectionItemsRecord last() const {
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
			var record = new TCollectionItemsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TCollectionItemsRecord( DB );
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

	public void push_back( TCollectionItemsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TCollectionItemsRecord> Collection;
	private int DB const;
}


