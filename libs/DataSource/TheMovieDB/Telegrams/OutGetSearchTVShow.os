
// Library imports

// Project imports
import libs.Common.ATelegram;
import Consts;
import InAckGetSearchMovie;


public object OutGetSearchTVShow extends OutgoingTelegram {
    public int first_air_date_year;
    public string language = "en-US";
    public bool include_adult = true;
    public int page;
    public string query;

    public void Constructor() {
       base.Constructor( TelegramMethod.GET, OutGetSearchTVShow.getIdentifier() );
    }

    public string finalize() const {
        return "";
    }

    public IncomingTelegram getAckMessage( TelegramFactory factory const ) const {
        return factory.provideIncoming( InAckGetSearchTVShow.getIdentifier() );
    }

    public static string getIdentifier() const {
        return "OutGetSearchTVShow";
    }

    public string getServicePath() const {
        string request;

        if ( include_adult )
            request += "&include_adult=" + include_adult;
        if ( page )
            request += "&page=" + page;
        if ( first_air_date_year )
            request += "&first_air_date_year=" + first_air_date_year;

        return "/3/search/tv?language=" + language + "&query=" + query + request;
    }

    public void reset() modify {
        first_air_date_year = 0;
        language = "en-US";
        include_adult = true;
        page = 0;
        query = "";
    }
}

