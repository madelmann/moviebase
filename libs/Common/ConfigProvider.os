
// Library imports
import System.Collections.Map;

// Project imports
import libs.Database.Lookups.ParameterKey;
import libs.Database.Tables.Parameter;


public namespace ConfigProvider {

    public Map<ParameterKey, string> retrieveDomain( string domain ) const throws {
        var collection = new TParameterCollection( Database.Handle );
        collection.loadByQuery(
            "SELECT * FROM parameter WHERE domain = '" + domain + "'"
        );

        var result = new Map<ParameterKey, string>();

        foreach ( TParameterRecord record : collection ) {
            result.insert( ParameterKey record.ParameterKeyId, record.Value );
        }

        return result;
    }

    public string retrieve( string domain, ParameterKey key ) const throws {
        var record = new TParameterRecord( Database.Handle );
        record.loadByQuery(
            "SELECT * FROM parameter WHERE domain = '" + domain + "' AND parameter_key_id = " + cast<string>( key ) + " LIMIT 1"
        );

        return record.Value;
    }

    public bool retrieve( string domain, ParameterKey key, bool defaultValue ) const {
        try {
            return cast<bool>( retrieve( domain, key ) );
        }

        return defaultValue;
    }

    public double retrieve( string domain, ParameterKey key, double defaultValue ) const {
        try {
            return cast<double>( retrieve( domain, key ) );
        }

        return defaultValue;
    }

    public float retrieve( string domain, ParameterKey key, float defaultValue ) const {
        try {
            return cast<float>( retrieve( domain, key ) );
        }

        return defaultValue;
    }

    public int retrieve( string domain, ParameterKey key, int defaultValue ) const {
        try {
            return cast<int>( retrieve( domain, key ) );
        }

        return defaultValue;
    }

    public string retrieve( string domain, ParameterKey key, string defaultValue ) const {
        try {
            return retrieve( domain, key );
        }

        return defaultValue;
    }

    public void store( string domain, ParameterKey key, bool value ) modify {
        try {
            store( domain, key, cast<string>( value ) );
        }
    }

    public void store( string domain, ParameterKey key, double value ) modify {
        try {
            store( domain, key, cast<string>( value ) );
        }
    }

    public void store( string domain, ParameterKey key, float value ) modify {
        try {
            store( domain, key, cast<string>( value ) );
        }
    }

    public void store( string domain, ParameterKey key, int value ) modify {
        try {
            store( domain, key, cast<string>( value ) );
        }
    }

    public void store( string domain, ParameterKey key, string value ) modify throws {
        var parameter = new TParameterRecord( Database.Handle );
        {
            parameter.Domain         = domain;
            parameter.ParameterKeyId = key;
            parameter.Value          = value;
        }
        parameter.insertOrUpdate();
    }

}
