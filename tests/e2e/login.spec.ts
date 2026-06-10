import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import users from '../fixtures/users.json';

test.describe('Login Page', () => {

  test('TC-LOGIN-001: успешный вход с валидными данными', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.login(users.validUser.username, users.validUser.password);
    await expect(page).toHaveURL(/secure/);
    const message = await loginPage.getFlashMessage();
    expect(message).toContain('You logged into a secure area!');
  });

  test('TC-LOGIN-002: выход после входа', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.login(users.validUser.username, users.validUser.password);
    await page.locator('a[href="/logout"]').click();
    await expect(page).toHaveURL(/login/);
    const message = await loginPage.getFlashMessage();
    expect(message).toContain('You logged out of the secure area!');
  });

  for (const [index, user] of users.invalidUsers.entries()) {
    test(`TC-LOGIN-NEG-${index + 1}: ошибка при входе — ${user.expectedError}`, async ({ page }) => {
      const loginPage = new LoginPage(page);
      await loginPage.goto();
      await loginPage.login(user.username, user.password);
      const message = await loginPage.getFlashMessage();
      expect(message).toContain(user.expectedError);
    });
  }

});