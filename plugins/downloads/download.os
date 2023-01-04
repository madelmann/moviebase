#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Database.Tables.Download;
import libs.API.Utils;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var source = API.retrieve( "source" );
		var target = API.retrieve( "target" );

		var download = new TDownloadRecord( Database.Handle );
		download.Source = base64_decode( source );
		download.Target = base64_decode( target );
		download.insert();

		return true;
	}
}

