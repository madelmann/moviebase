
import System.Collections.Vector;

public object TStatsRecord {
	public int Id;
	public string StatsKey;
	public string StatsValue;

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
		var query = "DELETE FROM stats WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insert() modify throws {
		var query = "INSERT INTO stats ( `id`, `stats_key`, `stats_value` ) VALUES ( '" + Id + "', '" + StatsKey + "', '" + StatsValue + "' )";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}
	}

	public void insertOrUpdate() modify throws {
		var query = "INSERT INTO stats ( `id`, `stats_key`, `stats_value` ) VALUES ( '" + Id + "', '" + StatsKey + "', '" + StatsValue + "' ) ON DUPLICATE KEY UPDATE `stats_key` = '" + StatsKey + "', `stats_value` = '" + StatsValue + "'";

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
		StatsKey = cast<string>( mysql_get_field_value( result, "stats_key" ) );
		StatsValue = cast<string>( mysql_get_field_value( result, "stats_value" ) );
	}

	public void loadByPrimaryKey( int id ) modify throws {
		var query = "SELECT * FROM stats WHERE id = '" + id + "'";

		var error = mysql_query( DB, query );
		if ( error ) {
			throw mysql_error( DB );
		}

		var result = mysql_store_result( DB );
		if ( !mysql_fetch_row( result ) ) {
			throw "no result found";
		}

		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		StatsKey = cast<string>( mysql_get_field_value( result, "stats_key" ) );
		StatsValue = cast<string>( mysql_get_field_value( result, "stats_value" ) );
	}

	public void loadByResult( int result ) modify {
		Id = cast<int>( mysql_get_field_value( result, "id" ) );
		StatsKey = cast<string>( mysql_get_field_value( result, "stats_key" ) );
		StatsValue = cast<string>( mysql_get_field_value( result, "stats_value" ) );
	}

	public void update() modify {
		// UPDATE: not yet implemented
	}

	public bool operator==( TStatsRecord other const ) const {
		return Id == other.Id;
	}

	public string =operator( string ) const {
		return "TStatsRecord { '" + Id + "', '" + StatsKey + "', '" + StatsValue + "' }";
	}

	private int DB const;
}


public object TStatsCollection implements ICollection { //<TStatsRecord> {
	public void Constructor( int databaseHandle, string query = "" ) {
		Collection = new Vector<TStatsRecord>();
		DB = databaseHandle;

		if ( query ) {
			loadByQuery( query );
		}
	}

	public TStatsRecord at( int index ) const throws {
		return Collection.at( index );
	}

	public bool empty() const {
		return Collection.empty();
	}

	public TStatsRecord first() const {
		return Collection.first();
	}

	public Iterator<TStatsRecord> getIterator() const {
		return Collection.getIterator();
	}

	public TStatsRecord last() const {
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
			var record = new TStatsRecord( DB );
			record.loadByResult( result );

			Collection.push_back( record );
		}
	}

	public void loadByResult( int result ) modify throws {
		Collection.clear();

		while ( mysql_fetch_row( result ) ) {
			var record = new TStatsRecord( DB );
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

	public void push_back( TStatsRecord item ) modify {
		Collection.push_back( item );
	}

	private Vector<TStatsRecord> Collection;
	private int DB const;
}


