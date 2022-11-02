
// library imports

// project imports
import libs.Accounts.SessionTools;


public interface IPlugin {
}


public interface IExecutePlugin implements IPlugin {
	public bool Execute( int argc = 0, string args = "" ) modify;
}


public interface IRawPlugin implements IPlugin {
	public void Process() modify;
}


public interface IRenderPlugin implements IPlugin {
	public void Render() modify;
}


public object ASessionPlugin {
	public void Constructor() {
		mSession = Accounts.GetSession();
	}

	public void RenderLogin() {
		print( "
<div class='text-center form-signin'>
	<h1 class='h3 mb-3 fw-normal translation' token='PLEASE_SIGN_IN'>PLEASE_SIGN_IN</h1>
	<div class='form-floating'>
		<input type='email' class='form-control' id='username' />
		<label for='username' class='translation' token='EMAIL'>Email address</label>
	</div>
	<div class='form-floating'>
		<input type='password' class='form-control' id='password' />
		<label for='password' class='translation' token='PASSWORD'>PASSWORD</label>
	</div>
	<div class='checkbox mb-3'>
		<input class='form-check-input' type='checkbox' id='stay_logged_in' checked />
		<label class='form-check-label translation' for='stay_logged_in' token='STAY_LOGGED_IN'>STAY_LOGGED_IN</label>
	</div>
	<button class='w-100 btn btn-lg btn-primary translation' token='SIGN_IN' onclick='Login();'>SIGN_IN</button>
</div>

</br>
</br>
<span style='float:left;font-weight:bold;'>
	<label class='translation' token='NOT_YET_REGISTERED'>Not registered yet?</label>
	<a href='#' class='translation' token='DO_IT_NOW' onclick='Register();'>DO_IT_NOW</a>
</span>
<span style='float:right;font-weight:bold;'>
	<label class='translation' token='FORGOT_YOUR_PASSWORD'>Forgot your password?</label>
	<a href='#' class='translation' token='RESET_PASSWORD' onclick='ResetPassword();'>RESET_PASSWORD</a>
</span>
		" );
	}

	protected bool isAdmin() const {
		return mSession && mSession.isAdmin();
	}

	protected Session mSession;
}

