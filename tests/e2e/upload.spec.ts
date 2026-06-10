import { test, expect } from '@playwright/test';
import { UploadPage } from '../pages/UploadPage';
import path from 'path';
import fs from 'fs';

test.describe('File Upload Page', () => {

  test('TC-UPLOAD-001: успешная загрузка файла', async ({ page }) => {
    const uploadPage = new UploadPage(page);
    await uploadPage.goto();
    const testFile = path.join(__dirname, '../../tests/fixtures/test-file.txt');
    fs.writeFileSync(testFile, 'test content');
    await uploadPage.uploadFile(testFile);
    await expect(page.locator('h3')).toHaveText('File Uploaded!');
    await expect(page.locator('#uploaded-files')).toContainText('test-file.txt');
  });

  test('TC-UPLOAD-002: загрузка без файла показывает ошибку', async ({ page }) => {
    const uploadPage = new UploadPage(page);
    await uploadPage.goto();
    await uploadPage.uploadButton.click();
    await expect(page).not.toHaveURL(/secure/);
  });

});