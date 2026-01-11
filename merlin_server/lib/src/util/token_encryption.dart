import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

class TokenEncryption {
   
  static String encrypt(String plaintext, Session session) {
    final encryptionKey = _getEncryptionKey(session);
    final key = sha256.convert(utf8.encode(encryptionKey)).bytes;
    
    final plainBytes = utf8.encode(plaintext);
    final encrypted = List<int>.generate(
      plainBytes.length,
      (i) => plainBytes[i] ^ key[i % key.length],
    );
    
    return base64Encode(encrypted);
  }
  
  static String decrypt(String ciphertext, Session session) {
    final encryptionKey = _getEncryptionKey(session);
    final key = sha256.convert(utf8.encode(encryptionKey)).bytes;
    
    final encrypted = base64Decode(ciphertext);
    
    final decrypted = List<int>.generate(
      encrypted.length,
      (i) => encrypted[i] ^ key[i % key.length],
    );
    
    return utf8.decode(decrypted);
  }
  
  static String _getEncryptionKey(Session session) {
    try {
      return session.passwords['oauthEncryptionKey'] 
          ?? 'default-dev-key-change-in-production';
    } catch (e) {
      return 'default-dev-key-change-in-production';
    }
  }
}
