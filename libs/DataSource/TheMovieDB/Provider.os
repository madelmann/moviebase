
// Library imports
import libCurl;

// Project imports
import libs.Utils.Date;
import Telegrams.InAckGetTime;
import Telegrams.InAckGetSearchMovie;
import Telegrams.InAckGetSearchPerson;
import Telegrams.InAckGetSearchTVShow;
import Telegrams.OutGetTime;
import Telegrams.OutGetSearchMovie;
import Telegrams.OutGetSearchPerson;
import Telegrams.OutGetSearchTVShow;
import SearchItem;


public object Provider {
	public static string NAME const = "TheMovieDB";
	public static string URL const = "https://api.themoviedb.org";

	public void Constructor() {
		mApiKey = "28c897cb1a668a296f0e7b9361ff95e3";
		mFactory = new TelegramFactory();

		// add incoming telegrams
		mFactory.addIncomingTelegram( IncomingTelegram new InAckGetSearchMovie() );
		mFactory.addIncomingTelegram( IncomingTelegram new InAckGetSearchPerson() );
		mFactory.addIncomingTelegram( IncomingTelegram new InAckGetSearchTVShow() );
		mFactory.addIncomingTelegram( IncomingTelegram new InAckGetTime() );

		// add outgoing telegrams
		mFactory.addOutgoingTelegram( OutgoingTelegram new OutGetSearchMovie() );
		mFactory.addOutgoingTelegram( OutgoingTelegram new OutGetSearchPerson() );
		mFactory.addOutgoingTelegram( OutgoingTelegram new OutGetSearchTVShow() );
		mFactory.addOutgoingTelegram( OutgoingTelegram new OutGetTime() );
	}

	public string getTime() const {
		var telegram = OutGetTime mFactory.provideOutgoing( OutGetTime.getIdentifier() );

		var response = InAckGetTime sendTelegram( OutgoingTelegram telegram );
		return Date.localTimeToDateTime( response.Iso );
	}

	public Vector<SearchItem> searchMovie( string query, int page = 0 ) const {
		var telegram = OutGetSearchMovie mFactory.provideOutgoing( OutGetSearchMovie.getIdentifier() );
		telegram.page = page;
		telegram.query = query;

		var response = InAckGetSearchMovie sendTelegram( OutgoingTelegram telegram );
		return response.Items;
	}

	public Vector<SearchItem> searchPerson( string query, int page = 0 ) const {
		var telegram = OutGetSearchPerson mFactory.provideOutgoing( OutGetSearchPerson.getIdentifier() );
		telegram.page = page;
		telegram.query = query;

		var response = InAckGetSearchPerson sendTelegram( OutgoingTelegram telegram );
		return response.Items;
	}

	public Vector<SearchItem> searchTVShow( string query, int page = 0 ) const {
		var telegram = OutGetSearchTVShow mFactory.provideOutgoing( OutGetSearchTVShow.getIdentifier() );
		telegram.page = page;
		telegram.query = query;

		var response = InAckGetSearchTVShow sendTelegram( OutgoingTelegram telegram );
		return response.Items;
	}

	private IncomingTelegram sendTelegram( OutgoingTelegram request ) const {
		var response = IncomingTelegram request.getAckMessage( mFactory );
		var servicePath = request.getServicePath() + "&api_key=" + mApiKey;

		print( "Sending request to '" + Provider.URL + servicePath + "'" );

		var curl = new CurlRequest( Provider.URL + servicePath );
		curl.setBearer( mApiKey );
		if ( request.Method == TelegramMethod.POST ) {
			var data = request.finalize();
			print( data );

			curl.setData( data );
		}
		curl.setHeader( "Accept: application/json" );
		curl.setHeader( "Content-Type: application/json" );

		//var settings = curl.settings();
		//settings.VerboseOutput = true;

		var reply = curl.execute();
		//print( "Received reply: " + reply );

		try {
			var reader = new JsonReader();
			var result = reader.parse( reply );
			print( "Received reply: " + result.toString() );

			response.parse( result );
		}
		catch ( IException e ) {
			print( "Exception: " + e.what() );
			print( "==> " + reply );
		}

		return response;
	}

	private string mApiKey;
	private TelegramFactory mFactory;
}

