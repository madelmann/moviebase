
// Library imports
import System.Collections.Vector;

// Project imports
import ATelegram;


public object TelegramFactory {
    public void Constructor() {
        mIncomingTelegrams = new Vector<IncomingTelegram>();
        mOutgoingTelegrams = new Vector<OutgoingTelegram>();
        mTelegrams = new Vector<BaseTelegram>();
    }

    public void addIncomingTelegram( IncomingTelegram telegram ) modify {
        mIncomingTelegrams.push_back( telegram );
        mTelegrams.push_back( BaseTelegram telegram );
    }

    public void addOutgoingTelegram( OutgoingTelegram telegram ) modify {
        mOutgoingTelegrams.push_back( telegram );
        mTelegrams.push_back( BaseTelegram telegram );
    }

    public IncomingTelegram provideIncoming( string telegram ) const throws {
        foreach ( IncomingTelegram t : mIncomingTelegrams ) {
            if ( t.getTypename() == telegram ) {
                return t;
            }
        }

        print( "Error: did not find incoming telegram '" + telegram + "'!" );
        throw new Exception( "Incoming telegram '" + telegram + "' not found!" );
    }

    public OutgoingTelegram provideOutgoing( string telegram ) const throws {
        foreach ( OutgoingTelegram t : mOutgoingTelegrams ) {
            if ( t.getTypename() == telegram ) {
                return t;
            }
        }

        print( "Error: did not find outgoing telegram '" + telegram + "'!" );
        throw new Exception( "Outgoing telegram '" + telegram + "' not found!" );
    }

    public BaseTelegram provide( string telegram ) const throws {
        foreach ( BaseTelegram t : mTelegrams ) {
            if ( t.getTypename() == telegram ) {
                return t;
            }
        }

        print( "Error: did not find telegram '" + telegram + "'!" );
        throw new Exception( "Telegram '" + telegram + "' not found!" );
    }

    private Vector<IncomingTelegram> mIncomingTelegrams;
    private Vector<OutgoingTelegram> mOutgoingTelegrams;
    private Vector<BaseTelegram> mTelegrams;
}

