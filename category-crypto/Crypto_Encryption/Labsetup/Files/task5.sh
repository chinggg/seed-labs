name=large
mode=$1
if [[ -z $mode ]]; then
   echo "no mode specified, use cbc by default"
   mode='cbc'
fi
head -c 1KB /dev/random > ${name}.in
case ${mode,,} in
  cbc)
  openssl enc -aes-128-cbc -e -in "${name}.in" -out "${name}.$mode" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
  dd if=/dev/random bs=1 count=1 of="${name}.$mode" seek=55 conv=notrunc
  openssl enc -aes-128-cbc -d -in "${name}.$mode" -out "${name}.out" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
  ;;
  ecb)
  openssl enc -aes-128-ecb -e -in "${name}.in" -out "${name}.$mode" -K 00112233445566778889aabbccddeeff
  dd if=/dev/random bs=1 count=1 of="${name}.$mode" seek=55 conv=notrunc
  openssl enc -aes-128-ecb -d -in "${name}.$mode" -out "${name}.out" -K 00112233445566778889aabbccddeeff
  ;;
  ofb)
  openssl enc -aes-128-ofb -e -in "${name}.in" -out "${name}.$mode" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
  dd if=/dev/random bs=1 count=1 of="${name}.$mode" seek=55 conv=notrunc
  openssl enc -aes-128-ofb -d -in "${name}.$mode" -out "${name}.out" -K 00112233445566778889aabbccddeeff -iv 0102030405060708
esac
