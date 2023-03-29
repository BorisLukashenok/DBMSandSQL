DROP FUNCTION IF EXISTS count_friends;
DELIMITER //
CREATE FUNCTION count_friends (iduser INT)
returns INT READS SQL DATA

BEGIN
declare count1 INT;
declare count2 INT;
set count1 = (SELECT count(*) FROM friend_requests 
WHERE target_user_id = iduser AND status='approved'); 
set count2 = (SELECT count(*) FROM friend_requests 
WHERE initiator_user_id = iduser AND status='approved');
return count1 + count2;
END //
Delimiter ; 
SELECT count_friends (7);
DROP PROCEDURE IF EXISTS show_friends;
DELIMITER //
CREATE PROCEDURE show_friends(for_user_id bigint)

BEGIN
select * from users as U join profiles as P on U.id = P.user_id 
join users_communities as UC on U.id = UC.user_id 
where P.hometown = (select hometown from profiles where user_id = for_user_id) 
or UC.community_id = (select community_id from users_communities where user_id = for_user_id limit 1) 
order by rand() limit 5;
END //
DELIMITER ;

-- Вызов процедуры:
CALL show_friends(6);