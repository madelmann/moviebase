CREATE DEFINER=`root`@`localhost` FUNCTION `CreateSessionId`(identifier text) RETURNS varchar(256) CHARSET utf8mb4
begin
    return sha2(COALESCE(identifier, NOW()), 256);
end;