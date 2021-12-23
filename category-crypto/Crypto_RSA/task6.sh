# openssl s_client -connect www.shu.edu.cn:443 -showcerts

# Extract the public key (e, n) from the issuer’s certificate
#openssl x509 -in c1.pem -noout -modulus
#openssl x509 -in c1.pem -text -noout

# Extract the signature from the server’s certificate
#openssl x509 -in c0.pem -text -noout
#cat signature | tr -d '[:space:]:'

# Extract the body of the server’s certificate
#openssl asn1parse -i -in c0.pem
openssl asn1parse -i -in c0.pem -strparse 4 -out c0_body.bin -noout
sha256sum c0_body.bin
