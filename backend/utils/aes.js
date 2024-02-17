const crypto = require("crypto");

// AES encryption function with ECB mode
function aesEncrypt(text, secretKey) {
  const keyBuffer = Buffer.from(secretKey, "hex"); // Ensure key is treated as a Buffer
  const cipher = crypto.createCipheriv("aes-256-ecb", keyBuffer, null); // Use null as IV for ECB mode
  let encrypted = cipher.update(text, "utf-8", "hex");
  encrypted += cipher.final("hex");
  return encrypted;
}

// AES decryption function with ECB mode
function aesDecrypt(encryptedData, secretKey) {
  const keyBuffer = Buffer.from(secretKey, "hex"); // Ensure key is treated as a Buffer
  const decipher = crypto.createDecipheriv("aes-256-ecb", keyBuffer, null); // Use null as IV for ECB mode
  let decrypted = decipher.update(encryptedData, "hex", "utf-8");
  decrypted += decipher.final("utf-8");
  return decrypted;
}

module.exports = {
  aesEncrypt,
  aesDecrypt,
};
