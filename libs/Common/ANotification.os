
// Library imports
import libJson;

// Project imports
import libs.Utils.File;


public abstract object BaseNotification {
    /*
     * Basic notification data
     */
    public string NotificationType const;
    public String Template const;

    /*
     * Notification constructor
     */
    public void Constructor( string notificationType, bool loadTemplate = true ) {
        NotificationType = notificationType;

        if ( loadTemplate ) {
            Template = new String(
                File.loadFile( "Templates/" + NotificationType + ".txt" )
            );
        }
    }

    /*
     * Produces a formated string based on the notification data
     */
    public abstract string finalize() const;

    /*
     * Parses the received JSON data
     */
    public abstract void parse( JsonValue value const ) modify throws;

    /*
     * Prepares the JSON data for storage
     */
    public abstract JsonValue prepare();

    /*
     * Resets the contents of a notification object
     */
    public abstract void reset() modify;
}


public abstract object UserNotification extends BaseNotification {
    /*
     * User notification data
     */
    public string Identifier;
    public bool   SendAsMail = true;
    public bool   SendAsSMS  = false;
    public string Subject const;
    public string Username;
}

