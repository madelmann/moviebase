-- auto-generated definition
create table users
(
    id            int auto_increment
        primary key,
    last_modified timestamp default current_timestamp() not null,
    username      varchar(128)                          not null,
    password      varchar(80)                           not null,
    identifier    varchar(80)                           not null,
    is_admin      int       default 0                   not null,
    surname       varchar(80)                           null,
    prename       varchar(80)                           null,
    constraint identifier
        unique (identifier),
    constraint username
        unique (username)
);


