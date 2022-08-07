
// Library imports

// Project imports
import libs.Common.ATelegram;
import Consts;


public object InAckGetTime extends IncomingTelegram {
    public int Epoch;
    public string Iso;

    public void Constructor() {
       base.Constructor( TelegramMethod.GET, InAckGetTime.getIdentifier() );
    }

    public static string getIdentifier() const {
        return "InAckGetTime";
    }

    public void parse( JsonValue value ) modify throws {
        print( value.toString() );

        var data = JsonObject value;
        if ( data.isMember( C_EPOCH ) ) {
            Epoch = data[ C_EPOCH ].asInt();
        }
        if ( data.isMember( C_ISO ) ) {
            Iso = data[ C_ISO ].asString();
        }
    }

    public void reset() modify {
        Epoch = 0;
        Iso = "";
    }
}

