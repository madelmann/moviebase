
// Library imports
import libJson;

// Project imports
import TelegramFactory;


public enum TelegramMethod {
    DELETE,
    GET,
    POST,
    PUT;
}


public abstract object BaseTelegram {
    /*
     * Public member to identify a telegram's method
     */
    public TelegramMethod Method const;

    /*
     * Telegram constructor
     */
    public void Constructor( TelegramMethod method, string typename ) {
        Method = method;
        mTypename = typename;
    }

    /*
     * Returns the name of a telegram
     */
    public string getTypename() const {
        return mTypename;
    }

    /*
     * Resets the contents of a telegram object
     */
    public abstract void reset() modify;

    /*
     * Stores the name of a telegram
     */
    protected string mTypename;
}


public abstract object IncomingTelegram extends BaseTelegram {
    /*
     * Parses the received JSON string
     */
    public abstract void parse( JsonValue value const ) modify throws;
}


public abstract object OutgoingTelegram extends BaseTelegram {
    /*
     * Telegram requires authorization
     */
    public bool IsPrivate const;

    /*
     * Build a JSON-formated string from all the telegram data
     */
    public abstract string finalize() const;

    /*
     * Returns the telegram that needs to be used to parse the reply message
     */
    public abstract IncomingTelegram getAckMessage( TelegramFactory factory const ) const;

    /*
     * Returns the service path of a telegram
     */
    public abstract string getServicePath() const;
}

