Feature: Form Authentication

  Scenario: Успешный вход с валидными данными
    Given я нахожусь на странице /login
    When я ввожу username "tomsmith" и password "SuperSecretPassword!"
    And нажимаю кнопку Login
    Then я должен быть перенаправлен на /secure
    And вижу сообщение "You logged into a secure area!"

  Scenario: Неверный пароль
    Given я нахожусь на странице /login
    When я ввожу username "tomsmith" и password "wrongpassword"
    And нажимаю кнопку Login
    Then я вижу сообщение об ошибке "Your password is invalid!"

  Scenario: Пустые поля
    Given я нахожусь на странице /login
    When я не заполняю поля и нажимаю Login
    Then я вижу сообщение об ошибке "Your username is invalid!"