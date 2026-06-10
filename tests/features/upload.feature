Feature: File Upload

  Scenario: Успешная загрузка файла
    Given я нахожусь на странице /upload
    When я выбираю файл "test-file.txt"
    And нажимаю кнопку Upload
    Then вижу сообщение "File Uploaded!"
    And вижу имя файла "test-file.txt"

  Scenario: Загрузка без выбора файла
    Given я нахожусь на странице /upload
    When я нажимаю Upload без выбора файла
    Then страница не показывает успешную загрузку