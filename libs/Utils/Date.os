
// Library imports

// Project imports


public namespace Date {

// convert MySQL format to datetime-local
public string dateTimeToLocalTime( string time ) {
	return time ? substr( time, 0, 10 ) + "T" + substr( time, 11, 12 ) : "";
}

// convert datetime-local to MySQL format
public string localTimeToDateTime( string time ) {
	return time ? substr( time, 0, 10 ) + " " + substr( time, 11, 12 ) : "";
}

}
