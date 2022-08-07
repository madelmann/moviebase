create
    definer = root@`%` function CreateSessionId(identifier text) returns varchar(256)
begin
    return sha2(COALESCE(identifier, NOW()), 256);
end;


