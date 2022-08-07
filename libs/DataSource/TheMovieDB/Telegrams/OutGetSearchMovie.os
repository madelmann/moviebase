
// Library imports

// Project imports
import libs.Common.ATelegram;
import Consts;
import InAckGetSearchMovie;


public object OutGetSearchMovie extends OutgoingTelegram {
    public string language = "en-US";
    public bool include_adult = true;
    public int page;
    public int primary_release_year;
    public string query;
    public string region;
    public int year;

    public void Constructor() {
       base.Constructor( TelegramMethod.GET, OutGetSearchMovie.getIdentifier() );
    }

    public string finalize() const {
        return "";
    }

    public IncomingTelegram getAckMessage( TelegramFactory factory const ) const {
        return factory.provideIncoming( InAckGetSearchMovie.getIdentifier() );
    }

    public static string getIdentifier() const {
        return "OutGetSearchMovie";
    }

    public string getServicePath() const {
        string request;

        if ( include_adult )
            request += "&include_adult=" + include_adult;
        if ( page )
            request += "&page=" + page;
        if ( primary_release_year )
            request += "&primary_release_year=" + primary_release_year;
        if ( region )
            request += "&region=" + region;
        if ( year )
            request += "&year=" + year;

        return "/3/search/movie?language=" + language + "&query=" + query + request;
    }

    public void reset() modify {
        language = "en-US";
        include_adult = true;
        page = 0;
        primary_release_year = 0;
        query = "";
        region = "";
        year = 0;
    }
}

