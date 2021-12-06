head -c 54 pic_original.bmp > header
mode=$1
if [[ -z $mode ]]; then
   echo "no mode specified, use cbc by default"
   mode='cbc'
fi
case ${mode,,} in
  ecb)
    openssl enc -aes-128-ecb -e -in pic_original.bmp -out ecb.bin -K 00112233445566778889aabbccddeeff
    tail -c +55 ecb.bin > body_ecb
    cat header body_ecb > new_ecb.bmp
    ;;
  cbc)
    openssl enc -aes-128-cbc -e -in pic_original.bmp -out cbc.bin -K 00112233445566778889aabbccddeeff -iv 0102030405060708 
    tail -c +55 cbc.bin > body_cbc
    cat header body_cbc > new_cbc.bmp
    ;;
esac

#if [[ "${mode,,}" == 'ecb' ]]; then
   #openssl enc -aes-128-ecb -e -in pic_original.bmp -out ecb.bin -K 00112233445566778889aabbccddeeff
   #tail -c +55 ecb.bin > body_ecb
   #cat header body_ecb > new_ecb.bmp
#elif [[ "${mode,,}" == 'cbc' ]]; then
   #openssl enc -aes-128-cbc -e -in pic_original.bmp -out cbc.bin -K 00112233445566778889aabbccddeeff -iv 0102030405060708 
   #tail -c +55 cbc.bin > body_cbc
   #cat header body_cbc > new_cbc.bmp
#fi
