
// Library imports

// Project imports
import libs.Common.ATelegram;
import Consts;
import InAckGetSearchPerson;


public object OutGetSearchPerson extends OutgoingTelegram {
    public string language = "en-US";
    public bool include_adult = true;
    public int page;
    public string query;
    public string region;

    public void Constructor() {
       base.Constructor( TelegramMethod.GET, OutGetSearchPerson.getIdentifier() );
    }

    public string finalize() const {
        return "";
    }

    public IncomingTelegram getAckMessage( TelegramFactory factory const ) const {
        return factory.provideIncoming( InAckGetSearchPerson.getIdentifier() );
    }

    public static string getIdentifier() const {
        return "OutGetSearchPerson";
    }

    public string getServicePath() const {
        string request;

        if ( include_adult )
            request += "&include_adult=" + include_adult;
        if ( page )
            request += "&page=" + page;
        if ( region )
            request += "&region=" + region;

        return "/3/search/person?language=" + language + "&query=" + query + request;
    }

    public void reset() modify {
        language = "en-US";
        include_adult = true;
        page = 0;
        query = "";
        region = "";
    }
}

