# NoSQL — MongoDB: Бронирования

## 1. Структура документа

Для хранения бронирований выбираю **смешанный подход** (embedded + referenced):

```json
{
  "_id": ObjectId("..."),
  "user_id": ObjectId("..."),
  "room": {
    "room_id": ObjectId("..."),
    "type": "double",
    "price_per_night": 150
  },
  "checkin": ISODate("2025-01-01"),
  "checkout": ISODate("2025-01-10"),
  "status": "confirmed",
  "created_at": ISODate("2024-12-01")
}
```

**Почему так:** `user_id` — referenced, потому что данные пользователя меняются и нужны отдельно.
`room` — embedded частично, потому что тип и цена нужны в каждом бронировании для отчётов без JOIN.

## 2. Индексы

```javascript
// Поиск бронирований по пользователю
db.bookings.createIndex({ user_id: 1 })

// Поиск по статусу и дате создания (для отчётов)
db.bookings.createIndex({ status: 1, created_at: -1 })

// Проверка пересечений дат для одной комнаты
db.bookings.createIndex({ "room.room_id": 1, checkin: 1, checkout: 1 })

// Поиск по дате заезда
db.bookings.createIndex({ checkin: 1 })
```

## 3. Проверка данных через MongoDB Compass / mongo shell

```javascript
// Найти бронирования с пересекающимися датами
db.bookings.find({
  "room.room_id": ObjectId("..."),
  checkin: { $lt: ISODate("2025-01-10") },
  checkout: { $gt: ISODate("2025-01-01") }
})

// Проверить что нет бронирований с checkout раньше checkin
db.bookings.find({
  $expr: { $lte: ["$checkout", "$checkin"] }
})

// Подсчёт по статусам
db.bookings.aggregate([
  { $group: { _id: "$status", count: { $sum: 1 } } }
])

// Проверка обязательных полей
db.bookings.find({
  $or: [
    { user_id: { $exists: false } },
    { checkin: { $exists: false } },
    { checkout: { $exists: false } },
    { status: { $exists: false } }
  ]
})
```