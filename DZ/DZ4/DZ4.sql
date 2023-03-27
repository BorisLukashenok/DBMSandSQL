use lesson_4;
-- ЗАДАЧА 1 Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
select sum(d.al) as All_like
from profiles as p
    join media as m on p.user_id = m.user_id
    join (
        select media_id,
            count(user_id) as al
        from likes
        group by media_id
    ) d on m.id = d.media_id
where TIMESTAMPDIFF(year, p.birthday, now()) < 12;
-- ЗАДАЧА 2 Определить кто больше поставил лайков (всего): мужчины или женщины. 
select p.gender,
    count(p.gender) as All_like
from profiles as p
    join likes as l on l.user_id = p.user_id
group by p.gender;
select case
        when p.gender = 'f' then 'Женщины'
        else 'Мужчины'
    end as 'Кто поставил больше лайков?',
    count(p.gender) as All_like
from profiles as p
    join likes as l on l.user_id = p.user_id
group by p.gender
order by All_like desc
limit 1;
-- ЗАДАЧА 3 Вывести всех пользователей, которые не отправляли сообщения.
select CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь'
from users as u
    left join messages m on u.id = m.from_user_id
where m.from_user_id is null;
-- ЗАДАЧА 4 (по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.
select CONCAT(u.firstname, ' ', u.lastname) as fullname, d.Alls
from (
        select m.from_user_id,
            count(*) as Alls
        from users u
            right join friend_requests f on u.id = initiator_user_id
            join messages m on u.id = to_user_id
        where f.status = 'approved'
            and firstname = 'Reuben'
        group by m.from_user_id
    ) as d
    left join users as u on d.from_user_id = u.id
order by Alls desc
limit 1;