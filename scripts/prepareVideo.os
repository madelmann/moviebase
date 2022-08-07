#!/usr/local/bin/slang

// library imports
import libParam.ParameterHandler;

// project imports
import libs.Database;


public int Main(int argc, string args) {
	if ( argc < 2 ) {
		print("usage: program <filename>");
			return 0;
	}

	print("args: '" + args + "'");

	if ( !Database.connect() ) {
		cerr("could not connect to database!");
		return -1;
	}

	var params = new ParameterHandler(argc, args, true);
	foreach ( Parameter param : params ) {
		string md5sum = getMD5Sum(param.Key);

		write("\"" + param.Key + "\": ");

		if ( !checkItemExists(md5sum) ) {
			insertItem(md5sum, param.Key);
			writeln("inserted");
		}
		else {
			writeln("already present");
		}
	}

	// disconnect from database
	if ( !Database.disconnect() ) {
		cerr("could not disconnect from database!");
		return -1;
	}

	return 0;
}

private bool checkItemExists(string md5sum) throws {
	string query = "SELECT * FROM items WHERE md5sum = \"" + md5sum + "\"";

	var error = mysql_query(Database.Handle, query);
	if ( error ) {
		throw mysql_error(Database.Handle);
	}

	var result = mysql_store_result(Database.Handle);
	if ( !result ) {
		throw "no result found";
	}

	return mysql_num_rows(Database.Handle) > 0;
}

private void insertItem(string md5sum, string filename) throws {
	string query = "INSERT INTO items (filename, md5sum, title) VALUES (\"" + filename + "\", \"" + md5sum + "\", \"" + filename + "\")";

	var error = mysql_query(Database.Handle, query);
	if ( error ) {
		throw mysql_error(Database.Handle);
	}
}

private string getMD5Sum(string filename) {
	print("md5sum \"" + filename + "\"");

	return substr(system("md5sum \"" + filename + "\""), 1, 32);
}

