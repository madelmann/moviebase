
private void showDeletedFiles() throws {
	string query = "SELECT * FROM items WHERE deleted = TRUE";

	int error = mysql_query(Database.Handle, query);
	if ( error ) {
		throw mysql_error(Database.Handle);
	}

	int result = mysql_store_result(Database.Handle);

	print("<h4>Deleted items:</h4>");
	print("<table>");

	while ( mysql_fetch_row(result) ) {
		string filename = mysql_get_field_value(result, "filename");
		string id = mysql_get_field_value(result, "id");
		string title = mysql_get_field_value(result, "title");

		print("<tr>");
		print("<td><button onclick='mPlugin.UnhideVideo(" + id + ");'>U</button>");
		print("<td><button onclick='mPlugin.DeleteVideo(" + id + ");'>X</button></td>");
		print("<td onclick='mPlugin.ShowVideo(" + id + ");'>\"" + filename + "\"</td>");
		print("</tr>");
	}

	print("</table>");
}

