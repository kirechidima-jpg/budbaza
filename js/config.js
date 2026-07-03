// ════════════════════════════════════════
//  БУДБАЗА — конфіг інтеграцій
//  Заповни токени і збережи файл
// ════════════════════════════════════════

// 1. TELEGRAM
//    Крок 1: напиши @BotFather → /newbot → отримай токен
//    Крок 2: напиши своєму боту /start, потім відкрий:
//            https://api.telegram.org/bot{TOKEN}/getUpdates
//            → знайди "chat":{"id": XXXX} — це і є CHAT_ID
var TG_TOKEN = "";   // приклад: "7123456789:AAFxxxxxxxxxxxxxxxxxxxxxx"
var TG_CHAT  = "";   // приклад: "123456789"  або "-100123456789" для групи

// 2. GOOGLE ANALYTICS 4
//    analytics.google.com → Адмін → Потоки даних → ID вимірювання
var GA_ID = "";      // приклад: "G-XXXXXXXXXX"

// 3. TAWK.TO (безкоштовний чат)
//    tawk.to → реєстрація → Administration → Channels → Chat Widget → Direct Chat Link
//    скопіюй два значення з коду віджету: s1 і s2
var TAWK_S1 = "";    // приклад: "64f1a2b3c4d5e6f7a8b9c0d1"
var TAWK_S2 = "";    // приклад: "1h9abcdef"
