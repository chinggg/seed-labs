echo -n "12345" > f5.in
echo -n "1234567890" > f10.in
echo -n "1234567890123456" > f16.in
mode=$1
if [[ -z $mode ]]; then
   echo "no mode specified, use cbc by default"
   mode='cbc'
fi
for fn in f5 f10 f16; do
  case ${mode,,} in
    cbc)
    openssl enc -aes-128-cbc -e -in "${fn}.in" -out "${fn}.bin" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
    openssl enc -aes-128-cbc -d -in "${fn}.bin" -out "${fn}.out" -K 00112233445566778889aabbccddeeff -iv 0102030405060708 -nopad
    ;;
    ecb)
    openssl enc -aes-128-ecb -e -in "${fn}.in" -out "${fn}.bin" -K 00112233445566778889aabbccddeeff
    openssl enc -aes-128-ecb -d -in "${fn}.bin" -out "${fn}.out" -K 00112233445566778889aabbccddeeff -nopad
    ;;
    cfb)
    openssl enc -aes-128-cfb -e -in "${fn}.in" -out "${fn}.bin" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
    openssl enc -aes-128-cfb -d -in "${fn}.bin" -out "${fn}.out" -K 00112233445566778889aabbccddeeff -iv 0102030405060708 -nopad
    ;;
    ofb)
    openssl enc -aes-128-ofb -e -in "${fn}.in" -out "${fn}.bin" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
    openssl enc -aes-128-ofb -d -in "${fn}.bin" -out "${fn}.out" -K 00112233445566778889aabbccddeeff -iv 0102030405060708 -nopad
    ;;
  esac
done
