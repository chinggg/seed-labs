// Task 3: Decrypting a Message
#include <openssl/bn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void printBN(char *msg, BIGNUM *a) {
  char *number_str = BN_bn2hex(a);
  printf("%s %s\n", msg, number_str);
  OPENSSL_free(number_str);
}

int main() {
  BN_CTX *ctx = BN_CTX_new();
  BIGNUM *n = BN_new();
  BIGNUM *e = BN_new();
  BIGNUM *d = BN_new();
  BIGNUM *m = BN_new();
  BIGNUM *c = BN_new();
  BIGNUM *dec = BN_new();
  BN_hex2bn(&n, "DCBFFE3E51F62E09CE7032E2677A78946A849DC4CDDE3A4D0CB81629242FB1A5");
  BN_hex2bn(&e, "010001");
  BN_hex2bn(&d, "74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");
  BN_hex2bn(&c, "8C0F971DF2F3672B28811407E2DABBE1DA0FEBBBDFC7DCB67396567EA1E2493F");
  BN_mod_exp(dec, c, d, n, ctx);
  printBN("decrypted:", dec);
  char *m_hex = BN_bn2hex(dec);
  printf("hex of msg: %s\n", m_hex);
  char cmd[128];
  sprintf(cmd, "python -c 'print(bytes.fromhex(\"%s\").decode())'", m_hex);
  printf("%s\n", cmd);
  system(cmd);
  return 0;
}
