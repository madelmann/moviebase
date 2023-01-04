#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Database.Tables.Download;
import libs.API.Utils;
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		var id = cast<int>( API.retrieve( "id" ) );

		var download = new TDownloadRecord( Database.Handle );
		download.loadByPrimaryKey( id );

		download.Done    = "";
		download.Started = "";
		download.insertOrUpdate();

		return true;
	}
}

