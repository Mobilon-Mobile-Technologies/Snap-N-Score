import 'package:flutter/material.dart';

int findGCD(int a, int b) {
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

int modExponentiation(int base, int exponent, int modulus) {
    if (modulus == 1) {
        return 0;
    }

    int result = 1;
    base = base % modulus;

    while (exponent > 0) {
        if (exponent % 2 == 1) {
            result = (result * base) % modulus;
        }
        exponent = exponent >> 1; // Right-shift the exponent
        base = (base * base) % modulus;
    }

    return result;
}
void main() {
  int p = 9973;
  int q = 9967;
  int n = p * q;
  int e = 1;
  int d = 2;
  int message=1634802;

  // phi(n)=(p-1)*(q-1)
  int phi = (p - 1) * (q - 1);

  //finding e {public key}
    for (d = 2; d < phi; d++) {
        if (findGCD(d, phi) == 1) {
            break;
        }
    }
    // finding d {private key}
    for (e = 2; e < phi; e++) {
        if ((e * d) % phi == 1) {
            break;
        }
    }
    // Encrypting message
    int c= modExponentiation(message,e,n);

    debugPrint("Encrypted message: $c");

    // Decrypting message
    int m=modExponentiation(c,d,n);

    debugPrint("Decrypted message: $m");
    

  debugPrint("n: $n");
  debugPrint("e (public key): $e");
  debugPrint("d (private key): $d");

}
