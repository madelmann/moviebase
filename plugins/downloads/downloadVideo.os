#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Plugins.ExecutePlugin;


public object ExecutePlugin implements IExecutePlugin {
	public bool Execute() throws {
		if ( !isSet("source") ) {
			throw "source missing!";
		}

		string source = get("source");
		if ( !source ) {
			throw "invalid source set!";
		}

		if ( !isSet("target") ) {
			throw "target missing!";
		}

		string target = get("target");
		if ( !target ) {
			throw "invalid target set!";
		}

		//string command = "screen -d -m /home/pi/projects/moviebase/scripts/hlsdownload.sh '" + source + "' '/home/pi/projects/moviebase/resources/downloads/" + target + "'";
		string command = "screen -d -m ./hlsdownload.sh '" + source + "' 'downloads/" + target + "'";
		//print( command );

		var result = system( command );
		print( result );

		return true;
	}
}

