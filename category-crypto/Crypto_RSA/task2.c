// Task 2: Encrypting a Message
#include <openssl/bn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void printBN(char *msg, BIGNUM *a) {
  char *number_str = BN_bn2hex(a);
  printf("%s %s\n", msg, number_str);
  OPENSSL_free(number_str);
}

char* str2hex(const char *in) {
  int len = strlen(in);
  char *buf = (char *)malloc(2*len+1);
  for (int i = 0; i < len; i++) {
    sprintf(buf+i*2, "%02X", in[i]);
  }
  return buf;
}

int main() {
  char *m_str = "A top secret!";
  char *m_hex = str2hex(m_str);
  printf("hex of msg: %s\n", m_hex);
  BN_CTX *ctx = BN_CTX_new();
  BIGNUM *n = BN_new();
  BIGNUM *e = BN_new();
  BIGNUM *d = BN_new();
  BIGNUM *m = BN_new();
  BIGNUM *enc = BN_new();
  BIGNUM *dec = BN_new();
  BN_hex2bn(&n, "DCBFFE3E51F62E09CE7032E2677A78946A849DC4CDDE3A4D0CB81629242FB1A5");
  BN_hex2bn(&e, "010001");
  BN_hex2bn(&d, "74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");
  BN_hex2bn(&m, m_hex);
  BN_mod_exp(enc, m, e, n, ctx);
  printBN("encrypted:", enc);
  BN_mod_exp(dec, enc, d, n, ctx);
  printBN("decrypted:", dec);
  return 0;
}
