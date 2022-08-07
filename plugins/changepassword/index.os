#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.Plugins.RenderPlugin;

public object RenderPlugin implements IRenderPlugin {
	public void Render() {
		pre("
<table class='login_table'>
	<tr>
		<td class='td_right'>Neues Passwort</td>
		<td class='td_left'><input type='password' id='password1' placeholder='Passwort' required /></td>
	</tr>
	<tr>
		<td class='td_right'>Passwort verifizieren</td>
		<td class='td_left'><input type='password' id='password2' placeholder='Passwort' required /></td>
	</tr>
	<tr>
		<td colspan='2' style='text-align: center;'>
			<label class='button' onclick='mPlugin.ChangePassword();'>&Aumlndern</label>
		</td>
	</tr>
	<tr>
		<td colspan='2'>
			<div id='message'></div>
		</td>
	</tr>
</table>
		");
	}
}

