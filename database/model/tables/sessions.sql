-- auto-generated definition
create table sessions
(
    id         varchar(256)                            not null,
    identifier varchar(80)                             not null,
    is_admin   int       default 0                     not null,
    created    timestamp default current_timestamp()   not null on update current_timestamp(),
    expires    timestamp default '0000-00-00 00:00:00' not null
)
    charset = latin1;


