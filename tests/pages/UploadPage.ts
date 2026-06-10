import { Page, Locator } from '@playwright/test';

export class UploadPage {
  readonly page: Page;
  readonly fileInput: Locator;
  readonly uploadButton: Locator;
  readonly uploadedFiles: Locator;

  constructor(page: Page) {
    this.page = page;
    this.fileInput = page.locator('#file-upload');
    this.uploadButton = page.locator('#file-submit');
    this.uploadedFiles = page.locator('#uploaded-files');
  }

  async goto() {
    await this.page.goto('/upload');
  }

  async uploadFile(filePath: string) {
    await this.fileInput.setInputFiles(filePath);
    await this.uploadButton.click();
  }
}