# QA Testing Portfolio

## Описание проекта
Тестовое задание на позицию QA инженер-тестировщик. Проект покрывает:
- REST API тестирование (Postman + Newman)
- UI тест-кейсы (ручное тестирование)
- E2E автотесты (Playwright + Page Object Model)
- SQL запросы и MongoDB ответы
- Диаграммы (BPMN, Sequence, State Transition)

## Структура проекта
/postman        — коллекция и environment для Postman
/test-cases     — UI тест-кейсы в Markdown
/tests
/e2e          — Playwright автотесты
/features     — Gherkin .feature файлы
/pages        — Page Object Model классы
/fixtures     — тестовые данные (users.json)
/sql            — SQL запросы (PostgreSQL)
/nosql          — ответ по MongoDB
/diagrams       — BPMN, Sequence, State Transition диаграммы

## Запуск автотестов

```bash
npm install
npx playwright test
```

## Запуск Postman коллекции через Newman

```bash
npm install
npx newman run postman/collection.json -e postman/environment.json
```

## Найденные баги и наблюдения

1. **POST /booking с неполными полями возвращает 500** — при отправке неполных данных API возвращает 500 Internal Server Error вместо 400 Bad Request
2. **Фильтрация GET /booking по firstname/lastname не работает** — запрос возвращает пустой массив [] вместо отфильтрованных бронирований
3. **API принимает бронирование где checkout раньше checkin** — должен возвращать 400, но возвращает 200 и создаёт бронирование
4. **File Upload принимает пустой файл** — при нажатии Upload без выбора файла показывает "File Uploaded!" с пустым именем

## Что бы улучшил при наличии дополнительного времени

- Подключить Allure Report для более детальных HTML отчётов
- Добавить больше негативных сценариев для API
- Добавить автотесты для Dynamic Loading страницы
- Расширить параметризацию тестов
- Добавить тесты для Drag and Drop страницы

## Окружение

- Node.js 18+
- Playwright 1.x
- Newman (входит в npm install)
- SQL совместим с PostgreSQL