CREATE TABLE database (
    database_id    RAW(16) DEFAULT sys_guid() PRIMARY KEY,
    database       VARCHAR2(1000) NOT NULL,
    CONSTRAINT unique_database UNIQUE ( database ),

    -- Additional columns for note and dates
    note                    VARCHAR2(4000),  -- General-purpose note field
    date_created            TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9) NOT NULL,
    date_updated            TIMESTAMP(9) WITH TIME ZONE,
        date_created_or_updated TIMESTAMP(9) WITH TIME ZONE GENERATED ALWAYS AS ( coalesce(date_updated, date_created) ) VIRTUAL
);

-- Trigger to update date_updated for operating_system
CREATE OR REPLACE TRIGGER trigger_set_date_updated_database BEFORE
    UPDATE ON database
    FOR EACH ROW
BEGIN
    :new.date_updated := systimestamp;
END;
/

-- 1. Create the database table
CREATE TABLE database_information (
    database_information_id           RAW(16) DEFAULT sys_guid() PRIMARY KEY,
    database_information                   VARCHAR2(1000) NOT NULL,
    database_id    RAW(16) NOT NULL,
    CONSTRAINT unique_database_information UNIQUE ( database_information ),

    -- Additional columns for note and dates
    note                    VARCHAR2(4000),  -- General-purpose note field
    date_created            TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9) NOT NULL,
    date_updated            TIMESTAMP(9) WITH TIME ZONE,
        date_created_or_updated TIMESTAMP(9) WITH TIME ZONE GENERATED ALWAYS AS ( coalesce(date_updated, date_created) ) VIRTUAL,
    CONSTRAINT foreign_key_database_information_references_database FOREIGN KEY ( database_id )
        REFERENCES database ( database_id )
);



CREATE OR REPLACE TRIGGER trigger_set_date_updated_database_information BEFORE
    UPDATE ON database_information
    FOR EACH ROW
BEGIN
    :new.date_updated := systimestamp;
END;
/