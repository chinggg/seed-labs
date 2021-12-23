// Task 5: Verifying a Signature
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
  char *m_str = "Launch a missile.";
  char *m_hex = str2hex(m_str);
  char *s_hex = "643D6F34902D9C7EC90CB0B2BCA36C47FA37165C0005CAB026C0542CBDB6802F";
  printf("hex of msg: %s\n", m_hex);
  BN_CTX *ctx = BN_CTX_new();
  BIGNUM *n = BN_new();
  BIGNUM *e = BN_new();
  BIGNUM *s = BN_new();
  BIGNUM *unsig = BN_new();
  BN_hex2bn(&n, "AE1CD4DC432798D933779FBD46C6E1247F0CF1233595113AA51B450F18116115");
  BN_hex2bn(&e, "010001");
  BN_hex2bn(&s, s_hex);
  BN_mod_exp(unsig, s, e, n, ctx);
  printBN("unsignature:", unsig);
  char *unsig_hex = BN_bn2hex(unsig);
  char cmd[128];
  sprintf(cmd, "python -c 'print(bytes.fromhex(\"%s\").decode())'", unsig_hex);
  printf("%s\n", cmd);
  system(cmd);
  return 0;
}
