-- auto-generated definition
create table news
(
    id      int auto_increment
        primary key,
    created timestamp default current_timestamp() not null on update current_timestamp(),
    title   varchar(256)                          not null,
    message text                                  null
);


