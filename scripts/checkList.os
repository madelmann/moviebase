#!/usr/local/bin/slang

// library imports
import libParam.ParameterHandler;
import System.Exception;
import System.IO.File;

// project imports
import libs.Database.Utils;
import FileProcessor;


private string DEFAULT_MODE const = "filename";
private string DEFAULT_PATH const = "/home/pi/projects/moviebase/resources/thumbs/";
private int DEFAULT_RESOLUTION const = 512;


public int Main(int argc, string args) {
	if ( argc < 2 ) {
		help();
		return -1;
	}

	if ( !Database.connect() ) {
		cerr( "could not connect to database!" );
		return -2;
	}

	try {
		var settings = new FileProcessor.Settings();
		settings.FilePath = DEFAULT_PATH;
		settings.Mode = OperationMode.Filename;
		settings.OutputResolution = DEFAULT_RESOLUTION;

		var params = new ParameterHandler( argc, args );

		while ( params.contains( "folder" ) ) {
			var folder const = params[ "folder" ];

			settings.addFolder( folder.Value );

			params.remove( folder );
		}

		if ( params.contains( "mode" ) ) {
			var mode const = params[ "mode" ];

			switch ( mode.Value ) {
				case "filename":           { settings.Mode = OperationMode.Filename; break; }
				case "md5sum":             { settings.Mode = OperationMode.MD5sum; break; }
				case "refreshThumbnails":  { settings.Mode = OperationMode.RefreshThumbnails; break; }
				case "size":               { settings.Mode = OperationMode.Size; break; }
			}

			params.remove( mode );
		}

		if ( params.contains( "path" ) ) {
			var path const = params[ "path" ];

			settings.FilePath = path.Value;

			params.remove( path );
		}

		if ( params.contains( "resolution" ) ) {
			var resolution const = params[ "resolution" ];

			settings.OutputResolution = cast<int>( resolution.Value );

			params.remove( resolution );
		}

		print( "Settings: { " + settings.toString() + " }" );

		foreach ( Parameter param : params ) {
			print( "Started processing file \"" + param.Key + "\"..." );

			var fileProcessor = new FileProcessor( param.Key, Database.Handle, settings );
			fileProcessor.process();
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

private void help() {
	print( "usage: program [options] <filename>" );
	print( "" );
	print( "--folder	process folder, multiple usages allowed (default: all)" );
	print( "--mode		set processing mode to filename, md5sum, refreshThumbnails or size (default: '" + DEFAULT_MODE + "')" );
	print( "--path		base folder path (default: '" + DEFAULT_PATH + "')" );
	print( "--resolution	resolution of generated thumb nails (default: " + DEFAULT_RESOLUTION + ")" );
}

