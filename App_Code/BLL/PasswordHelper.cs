using System;
using System.Security.Cryptography;
using System.Text;

namespace CodeFusion.BLL
{
    /// <summary>
    /// Hashes passwords with a random per-user salt + SHA-256 so plaintext
    /// passwords are never stored or compared directly.
    /// Stored format: "{base64Salt}:{base64Hash}"
    /// </summary>
    public static class PasswordHelper
    {
        public static string Hash(string plainPassword)
        {
            byte[] salt = new byte[16];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            byte[] hash = ComputeHash(plainPassword, salt);
            return Convert.ToBase64String(salt) + ":" + Convert.ToBase64String(hash);
        }

        public static bool Verify(string plainPassword, string storedHash)
        {
            if (string.IsNullOrEmpty(storedHash) || storedHash.IndexOf(':') < 0)
                return false;

            string[] parts = storedHash.Split(':');
            byte[] salt = Convert.FromBase64String(parts[0]);
            byte[] expectedHash = Convert.FromBase64String(parts[1]);

            byte[] actualHash = ComputeHash(plainPassword, salt);
            return SlowEquals(expectedHash, actualHash);
        }

        private static byte[] ComputeHash(string plainPassword, byte[] salt)
        {
            using (var sha = SHA256.Create())
            {
                byte[] passwordBytes = Encoding.UTF8.GetBytes(plainPassword);
                byte[] combined = new byte[salt.Length + passwordBytes.Length];
                Buffer.BlockCopy(salt, 0, combined, 0, salt.Length);
                Buffer.BlockCopy(passwordBytes, 0, combined, salt.Length, passwordBytes.Length);
                return sha.ComputeHash(combined);
            }
        }

        private static bool SlowEquals(byte[] a, byte[] b)
        {
            if (a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++)
                diff |= a[i] ^ b[i];
            return diff == 0;
        }
    }
}
