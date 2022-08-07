
// Library imports
import libJson.Writer;
import System.Collections.Vector;

// Project imports
import libs.Common.ATelegram;
import libs.DataSource.TheMovieDB.SearchItem;
import Consts;


public object InAckGetSearchMovie extends IncomingTelegram {
	public Vector<SearchItem> Items;

	public string status_code;
	public string status_message;
	public bool success;

	public int page;
	public int total_pages;
	public int total_results;

	public void Constructor() {
		base.Constructor( TelegramMethod.GET, InAckGetSearchMovie.getIdentifier() );

		Items = new Vector<SearchItem>();
	}

	public static string getIdentifier() const {
		return "InAckGetSearchMovie";
	}

	public void parse( JsonValue value ) modify throws {
		//print( value.toString() );

		var data = JsonObject value;
		if ( data.isMember( "page" ) ) {
			page = data[ "page" ].asInt();
		}
		if ( data.isMember( "results" ) ) {
			parseResults( JsonArray data[ "results" ] );
		}
		if ( data.isMember( "total_pages" ) ) {
			total_pages = data[ "total_pages" ].asInt();
		}
		if ( data.isMember( "total_results" ) ) {
			total_results = data[ "total_results" ].asInt();
		}
		if ( data.isMember( "status_code" ) ) {
			status_code = data[ "status_code" ].asInt();
		}
		if ( data.isMember( "status_message" ) ) {
			status_message = data[ "status_message" ].asString();
		}
		if ( data.isMember( "success" ) ) {
			success = data[ "success" ].asBool();
		}
	}

	public void reset() modify {
		Items = new Vector<SearchItem>();

		page = 0;
		success = false;
		status_code = 0;
		status_message = "";
		total_pages = 0;
		total_results = 0;
	}

	private void parseResults( JsonArray results ) modify {
		foreach ( JsonObject movie : results ) {
			//print( movie.toString() );

			var item = new SearchItem();
			Items.push_back( item );

			FromJson( item, movie.toString() );
		}
	}
}

