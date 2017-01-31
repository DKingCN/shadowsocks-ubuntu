#include
/bin/mkdir -p '/usr/local/include/sodium'
/usr/bin/install -c -m 644  sodium/core.h sodium/crypto_aead_aes256gcm.h sodium/crypto_aead_chacha20poly1305.h sodium/crypto_auth.h sodium/crypto_auth_hmacsha256.h sodium/crypto_auth_hmacsha512.h sodium/crypto_auth_hmacsha512256.h sodium/crypto_box.h sodium/crypto_box_curve25519xsalsa20poly1305.h sodium/crypto_core_hchacha20.h sodium/crypto_core_hsalsa20.h sodium/crypto_core_salsa20.h sodium/crypto_core_salsa2012.h sodium/crypto_core_salsa208.h sodium/crypto_generichash.h sodium/crypto_generichash_blake2b.h sodium/crypto_hash.h sodium/crypto_hash_sha256.h sodium/crypto_hash_sha512.h sodium/crypto_onetimeauth.h sodium/crypto_onetimeauth_poly1305.h sodium/crypto_pwhash.h sodium/crypto_pwhash_argon2i.h sodium/crypto_pwhash_scryptsalsa208sha256.h sodium/crypto_scalarmult.h sodium/crypto_scalarmult_curve25519.h sodium/crypto_secretbox.h sodium/crypto_secretbox_xsalsa20poly1305.h sodium/crypto_shorthash.h sodium/crypto_shorthash_siphash24.h sodium/crypto_sign.h sodium/crypto_sign_ed25519.h sodium/crypto_sign_edwards25519sha512batch.h sodium/crypto_stream.h sodium/crypto_stream_aes128ctr.h sodium/crypto_stream_chacha20.h sodium/crypto_stream_salsa20.h sodium/crypto_stream_salsa2012.h sodium/crypto_stream_salsa208.h sodium/crypto_stream_xsalsa20.h sodium/crypto_int32.h sodium/crypto_int64.h sodium/crypto_uint16.h sodium/crypto_uint32.h sodium/crypto_uint64.h sodium/crypto_uint8.h sodium/crypto_verify_16.h sodium/crypto_verify_32.h sodium/crypto_verify_64.h sodium/export.h sodium/randombytes.h sodium/randombytes_salsa20_random.h sodium/randombytes_sysrandom.h sodium/runtime.h sodium/utils.h sodium/version.h '/usr/local/include/sodium'

/usr/bin/install -c -m 644  sodium.h '/usr/local/include/.'

/bin/mkdir -p '/usr/local/lib'
/usr/bin/install -c   libsodium.la '/usr/local/lib'
/usr/bin/install -c .libs/libsodium.so /usr/local/lib/libsodium.so.18.1.0
cd /usr/local/lib && { ln -s -f libsodium.so.18.1.0 libsodium.so.18 || { rm -f libsodium.so.18 && ln -s libsodium.so.18.1.0 libsodium.so.18; }; }
cd /usr/local/lib && { ln -s -f libsodium.so.18.1.0 libsodium.so || { rm -f libsodium.so && ln -s libsodium.so.18.1.0 libsodium.so; }; }
/usr/bin/install -c .libs/libsodium.lai /usr/local/lib/libsodium.la
/usr/bin/install -c .libs/libsodium.a /usr/local/lib/libsodium.a
chmod 644 /usr/local/lib/libsodium.a
ranlib /usr/local/lib/libsodium.a
ldconfig -n /usr/local/lib

/bin/mkdir -p '/usr/local/lib/pkgconfig'
/usr/bin/install -c -m 644 libsodium.pc '/usr/local/lib/pkgconfig'

