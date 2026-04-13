package com.password.manager.utils

import java.security.SecureRandom

data class PasswordOptions(
    val length: Int = 16,
    val useUppercase: Boolean = true,
    val useLowercase: Boolean = true,
    val useDigits: Boolean = true,
    val useSymbols: Boolean = true
)

object PasswordGenerator {

    private const val UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private const val LOWERCASE = "abcdefghijklmnopqrstuvwxyz"
    private const val DIGITS = "0123456789"
    private const val SYMBOLS = "!@#\$%^&*()-_=+[]{}|;:,.<>?"

    fun generate(options: PasswordOptions = PasswordOptions()): String {
        val charPool = buildString {
            if (options.useUppercase) append(UPPERCASE)
            if (options.useLowercase) append(LOWERCASE)
            if (options.useDigits) append(DIGITS)
            if (options.useSymbols) append(SYMBOLS)
        }
        if (charPool.isEmpty()) return ""

        val random = SecureRandom()
        val password = StringBuilder(options.length)

        // Guarantee at least one char from each selected category
        val required = mutableListOf<Char>()
        if (options.useUppercase) required.add(UPPERCASE[random.nextInt(UPPERCASE.length)])
        if (options.useLowercase) required.add(LOWERCASE[random.nextInt(LOWERCASE.length)])
        if (options.useDigits) required.add(DIGITS[random.nextInt(DIGITS.length)])
        if (options.useSymbols) required.add(SYMBOLS[random.nextInt(SYMBOLS.length)])

        // Fill remaining length
        val remaining = options.length - required.size
        for (i in 0 until remaining.coerceAtLeast(0)) {
            password.append(charPool[random.nextInt(charPool.length)])
        }

        // Insert required chars at random positions
        for (c in required) {
            val pos = random.nextInt(password.length + 1)
            password.insert(pos, c)
        }

        return password.toString()
    }
}
