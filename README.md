# Fortran Lucifer Cipher

#### Contained in this folder are two programs:
* luc.f95
* luchex.f95 + hex.f95

## How to Use luc.f95:

1. Compile with `gfortran luc.f95`
2. Run with ./a.out
3. Input a 32 byte key
4. Input a 32 byte ASCII message
5. Program will encrypt the message and output ciphertext, then decrypt it and display the original message

#### Example:
```
Key: 0123456789ABCDEFFEDCBA9876543210
Message: AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB

Ciphertext: 7C790EFDE03679E4BF28FE2D199E41A0
Original Message: AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB
```

## How to Use luchex.f95:

1. Compile with `gfortran hex.f95 luchex.f95`
2. Run with ./a.out
3. Input a 32 byte key
4. Input any ASCII message up to 32 bytes
5. Program will encrypt the message and output ciphertext, then decrypt it and display the message in hexadecimal

#### Example:
```
Key: 0123456789ABCDEFFEDCBA9876543210
Message: hello

Ciphertext: FA6B0BD120FB28D5829BF9813A3ECD63
Hex Message: 68656C6C6F0000000000000000000000
```

