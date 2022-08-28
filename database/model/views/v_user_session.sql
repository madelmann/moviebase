create definer = root@localhost view v_user_session as
select `s`.`id`                       AS `id`,
       `s`.`created`                  AS `created`,
       `s`.`expires`                  AS `expires`,
       `u`.`username`                 AS `username`,
       `u`.`identifier`               AS `identifier`,
       `s`.`ip_address`               AS `ip_address`,
       `u`.`language`                 AS `language`,
       if(`u`.`is_admin` = '1', 1, 0) AS `is_admin`
from (`moviebase`.`sessions` `s` left join `moviebase`.`users` `u`
      on (`s`.`identifier` = `u`.`identifier` and `u`.`deleted` = 0))
where `s`.`expires` = 0
   or `s`.`expires` > current_timestamp();

