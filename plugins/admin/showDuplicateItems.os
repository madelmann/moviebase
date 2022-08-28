
private void showDuplicateItems() throws {
	var query = "SELECT itm1.* FROM items itm1 JOIN items itm2 ON (itm1.md5sum = itm2.md5sum AND itm1.id != itm2.id) ORDER BY itm1.md5sum ASC";

	var error = mysql_query(Database.Handle, query);
	if ( error ) {
		throw mysql_error(Database.Handle);
	}

	var result = mysql_store_result(Database.Handle);

	print("<h4>Duplicate items:</h4>");
	print("<table>");

	while ( mysql_fetch_row(result) ) {
		string filename = mysql_get_field_value(result, "filename");
		string id = mysql_get_field_value(result, "id");
		string md5sum = mysql_get_field_value(result, "md5sum");

		print("<tr>");
		print("<td onclick='mPlugin.ShowVideo(" + id + ");'>" + md5sum + ": \"" + filename + "\"</td>");
		print("</tr>");
	}

	print("</table>");
}

