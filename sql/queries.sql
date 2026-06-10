-- PostgreSQL

-- 1. Пользователи без бронирований
-- QA: проверяем что новые пользователи не имеют лишних записей в Bookings
SELECT u.id, u.name, u.email
FROM Users u
LEFT JOIN Bookings b ON u.id = b.user_id
WHERE b.id IS NULL;

-- 2. Пересекающиеся бронирования одной комнаты
-- QA: проверяем что система не допускает double-booking одной комнаты
SELECT a.id, a.room_id, a.checkin, a.checkout,
       b.id as conflict_id, b.checkin as conflict_checkin, b.checkout as conflict_checkout
FROM Bookings a
JOIN Bookings b ON a.room_id = b.room_id
  AND a.id < b.id
  AND a.checkin < b.checkout
  AND a.checkout > b.checkin;

-- 3. Топ-3 комнаты по подтверждённым бронированиям за последние 30 дней
-- QA: проверяем корректность подсчёта статистики популярности комнат
SELECT r.id, r.type, COUNT(b.id) as booking_count
FROM Rooms r
JOIN Bookings b ON r.id = b.room_id
WHERE b.status = 'confirmed'
  AND b.created_at >= NOW() - INTERVAL '30 days'
GROUP BY r.id, r.type
ORDER BY booking_count DESC
LIMIT 3;

-- 4. Подтверждённые бронирования созданные >7 дней назад с прошедшим checkin
-- QA: проверяем что просроченные бронирования корректно обрабатываются системой
SELECT b.id, b.user_id, b.room_id, b.checkin, b.checkout, b.created_at
FROM Bookings b
WHERE b.status = 'confirmed'
  AND b.created_at < NOW() - INTERVAL '7 days'
  AND b.checkin < NOW();

-- 5. Количество подтверждённых бронирований по типу комнаты
-- QA: проверяем корректность агрегации данных для отчётности
SELECT r.type, COUNT(b.id) as confirmed_bookings
FROM Rooms r
JOIN Bookings b ON r.id = b.room_id
WHERE b.status = 'confirmed'
GROUP BY r.type
ORDER BY confirmed_bookings DESC;