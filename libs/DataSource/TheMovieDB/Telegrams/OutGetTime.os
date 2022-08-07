
// Library imports

// Project imports
import libs.Common.ATelegram;
import Consts;
import InAckGetTime;


public object OutGetTime extends OutgoingTelegram {
    public void Constructor() {
       base.Constructor( TelegramMethod.GET, OutGetTime.getIdentifier() );
    }

    public string finalize() const {
        return "";
    }

    public IncomingTelegram getAckMessage( TelegramFactory factory const ) const {
        return factory.provideIncoming( InAckGetTime.getIdentifier() );
    }

    public static string getIdentifier() const {
        return "OutGetTime";
    }

    public string getServicePath() const {
        return "/v1/time/";
    }

    public void reset() modify {
        // nothing to do here
    }
}

