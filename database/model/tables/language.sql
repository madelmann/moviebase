-- auto-generated definition
create table language
(
    id          int auto_increment
        primary key,
    token       varchar(80)          not null,
    description varchar(1024)        null,
    name        varchar(80)          not null,
    enabled     tinyint(1) default 0 not null,
    constraint language_token_uindex
        unique (token)
);


