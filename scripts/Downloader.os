#!/usr/local/bin/slang

// library imports
import libParam;

// project imports
import libs.Database.Tables.Download;
import libs.Database.Utils;


public string DOWNLOADS = "downloads/";

public int Main( int argc, string args ) {
    var params = new ParameterHandler( argc, args );

    /*
    if ( params.size() != 2 ) {
        print( "invalid number of arguments" );
        return -1;
    }
    */
	if ( !Database.connect() ) {
		cerr( "could not connect to database!" );
		return -2;
	}

    DOWNLOADS = params[ 0 ].Key;
    print( "DOWNLOADS: " + DOWNLOADS );

    var collection = new TDownloadCollection( Database.Handle );
    var query = "SELECT *
                   FROM download
                  WHERE (done IS NULL OR done = 0)
                  ORDER BY created";

    try {
        int count;
        while ( count < 1440 ) {
            print( "Finding open downloads (Iteration " + count++ + ")..." );

            var startTime = time();

            collection.loadByQuery( query );

            foreach ( TDownloadRecord record : collection ) {
                // run download
                process( record );
            }

            var seconds = ( time() - startTime ) / 60;

            print( "Spend " + seconds + " seconds for " + collection.size() + " download(s)" );

            sleep( ( seconds >= 60 ) ? 0 : ( 60000 - seconds * 1000 ) );
        }
    }
	catch ( string e ) {
		print( "Exception: " + e );
	}
	catch ( IException e ) {
		print( "Exception: " + e.what() );
	}

	if ( !Database.disconnect() ) {
		cerr( "could not disconnect from database!" );
		return -3;
	}

    return 0;
}

private void process( TDownloadRecord record ) {
    print( cast<string>( record ) );

    var command = "ffmpeg \\
                        -y \\
                        -user_agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36' \\
                        -i '" + record.Source + "' \\
                        -c copy -bsf:a aac_adtstoasc \\
                        '" + DOWNLOADS + record.Target + ".mp4'";

    record.Started = strftime( "%Y-%m-%dT%H:%M:%S" );
    record.insertOrUpdate();

    system( command );

    record.Done = strftime( "%Y-%m-%dT%H:%M:%S" );
    record.insertOrUpdate();
}
