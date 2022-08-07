
// Library imports
import System.IO.File;

// Project imports


public namespace File {

public string loadFile( string filename ) const {
    var file = new System.IO.File( filename, System.IO.File.AccessMode.ReadOnly );

    string text;
    while ( !file.isEOF() ) {
        text += file.readChar();
    }

    return text;
}

}
