<?php

$debug = false;

function DoFileUpload()
{
    // Undefined | Multiple Files | $_FILES Corruption Attack
    // If this request falls under any of them, treat it invalid.
    if ( !isset($_FILES['myFile']['error']) || is_array($_FILES['myFile']['error']) ) {
        throw new RuntimeException('Invalid parameters.');
    }

    // Check $_FILES['myFile']['error'] value.
    switch ( $_FILES['myFile']['error'] ) {
        case UPLOAD_ERR_OK: break;
        case UPLOAD_ERR_NO_FILE: throw new RuntimeException('No file sent.'); break;
        case UPLOAD_ERR_INI_SIZE:
        case UPLOAD_ERR_FORM_SIZE: throw new RuntimeException('Exceeded filesize limit.'); break;
        default: throw new RuntimeException('Unknown errors.'); break;
    }

/*
    // You should also check filesize here. 
    if ( $_FILES['myFile']['size'] > 10000000 ) {
        throw new RuntimeException('Exceeded filesize limit.');
    }
*/

    // DO NOT TRUST $_FILES['myFile']['mime'] VALUE !!
    // Check MIME Type by yourself.
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    if (false === $ext = array_search(
        $finfo->file($_FILES['myFile']['tmp_name']),
        array(
            'jpg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
        ),
        true
    )) {
        throw new RuntimeException('Invalid file format.');
    }

    $md5sum = md5_file($_FILES['myFile']['tmp_name']);
    $filename = $md5sum . "." . $ext;

    if ( $md5sum != "" ) {
        $result = move_uploaded_file($_FILES['myFile']['tmp_name'], "uploads/images/" . $filename);
        if ( $result ) {
            return "$filename";
        }
    }

    return "failed";
}


try {
    $result = DoFileUpload();
    echo $result;
}
catch ( RuntimeException $e ) {
    if ( $debug ) {
        echo $e->getMessage();
    }

    echo "failed with exception";
}

?>
