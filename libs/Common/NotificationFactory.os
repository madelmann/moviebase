
// Library imports
import System.Collections.Vector;

// Project imports
import ANotification;


public object NotificationFactory {
    public void Constructor() {
        mNotifications = new Vector<BaseNotification>();
    }

    public void addNotification( BaseNotification notification ) modify {
        mNotifications.push_back( notification );
    }

    public BaseNotification provide( string notificationType ) const throws {
        foreach ( BaseNotification notification : mNotifications ) {
            if ( notification.NotificationType == notificationType ) {
                return notification;
            }
        }

        print( "Error: did not find notification type '" + notificationType + "'!" );
        throw new Exception( "notification type '" + notificationType + "' not found!" );
    }

    private Vector<BaseNotification> mNotifications;
}

