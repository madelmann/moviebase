
Translations = {

    currentLanguage: "EN",
    data: null,

    Constructor: function() {
        this.loadLanguage( this.currentLanguage );
    },

    Destructor: function() {
        // nothing to do here atm
    },

    loadLanguage: function( language ) {
        fetch( "lang/" + language + "/language.json" )
            .then( response => {
                if ( !response.ok ) {
                    throw new Error( "HTTP error " + response.status );
                }

                return response.json();
            } )
            .then( json => {
                this.currentLanguage = json.language;
                this.data = json.tokens;

                this.translate( document.getElementById( "container" ) );
            } )
            .catch( function () {
                Translations.currentLanguage = language;
                Translations.data = [];
            } );
    },

    token: function( token ) {
        if ( !token || !this.data ) {
            return token;
        }

        for ( var idx = 0; idx < this.data.length; ++idx ) {
            if ( this.data[ idx ].key == token ) {
                return this.data[ idx ].value;
            }
        }

        return this.currentLanguage + ":" + token;
    },

   translate: function( element ) {
      // translate values
      var list = element.getElementsByClassName( "translation" );

      for ( var idx = 0; idx < list.length; idx++ ) {
            // token-based translation
            list.item( idx ).innerText = Translations.token( list.item( idx ).getAttribute( "token" ) );
      }

      // translate placeholders
      var list = element.getElementsByClassName( "translation-placeholder" );

      for ( var idx = 0; idx < list.length; idx++ ) {
            // token-based translation
            list.item( idx ).placeholder = Translations.token( list.item( idx ).getAttribute( "token" ) );
      }
   }

};
