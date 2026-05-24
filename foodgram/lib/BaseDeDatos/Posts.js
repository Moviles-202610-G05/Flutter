/**
 * 🍽️ FoodGram Firebase Seeder
 * 
 * Pobla Firestore con posts reales de comida usando imágenes de Unsplash.
 * 
 * INSTRUCCIONES:
 * 1. npm install firebase-admin node-fetch
 * 2. Descarga tu serviceAccountKey.json desde Firebase Console:
 *    → Project Settings → Service Accounts → Generate new private key
 * 3. Coloca serviceAccountKey.json en la misma carpeta que este script
 * 4. node seed_firebase.js
 */

const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  // ⬇️ Reemplaza con el nombre de tu proyecto Firebase
  storageBucket: `${serviceAccount.project_id}.appspot.com`,
});

const db = admin.firestore();

// ─────────────────────────────────────────────
//  IMÁGENES REALES de Unsplash (sin API key)
//  Formato: https://images.unsplash.com/photo-{ID}?w=800&q=80
// ─────────────────────────────────────────────
const FOOD_IMAGES = {
  pizza:       "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80",
  burger:      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80",
  sushi:       "https://images.unsplash.com/photo-1553621042-f6e147245754?w=800&q=80",
  pasta:       "https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=800&q=80",
  tacos:       "https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800&q=80",
  ramen:       "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80",
  ensalada:    "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80",
  cheesecake:  "https://images.unsplash.com/photo-1567171466295-4afa63d45416?w=800&q=80",
  pancakes:    "https://images.unsplash.com/photo-1554520735-0a6b8b6ce8b7?w=800&q=80",
  steak:       "https://images.unsplash.com/photo-1546964124-0cce460f38ef?w=800&q=80",
  ceviche:     "https://images.unsplash.com/photo-1535399831218-d5bd36d1a6b3?w=800&q=80",
  brownie:     "https://images.unsplash.com/photo-1542124948-dc391252a940?w=800&q=80",
  waffles:     "https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=800&q=80",
  bowl:        "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=80",
  sandwich:    "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800&q=80",
};

// ─────────────────────────────────────────────
//  DATOS DE SEED
// ─────────────────────────────────────────────
const POSTS_DATA = [
  {
    userName: "carlos_gourmet",
    email: "carlos@foodgram.com",
    image: FOOD_IMAGES.pizza,
    color: "#FF6B35",
    description: "🍕 Pizza Margherita clásica recién salida del horno de leña. La masa perfectamente crocante y el queso mozzarella fundido son irresistibles. ¡Una noche italiana perfecta!",
    tags: ["#pizza", "#italiana", "#margarita", "#hornodeleña"],
    likes: 284,
    comments: 37,
    restaurantName: "La Trattoria Napolitana",
    towComents: [
      { userName: "maria_foodie", description: "¡Se ve increíble! ¿Cuál es la dirección?" },
      { userName: "chef_andres", description: "Esa masa tiene una textura perfecta 🤌" },
    ],
  },
  {
    userName: "luisa_eats",
    email: "luisa@foodgram.com",
    image: FOOD_IMAGES.burger,
    color: "#E63946",
    description: "🍔 La mejor burger doble que he probado en mi vida. Carne Angus, queso americano derretido, pepinillos artesanales y salsa secreta de la casa. ¡Absolutamente brutal!",
    tags: ["#burger", "#americanfood", "#smashburger", "#foodporn"],
    likes: 512,
    comments: 64,
    restaurantName: "Smash Bros Burgers",
    towComents: [
      { userName: "pedro_hungry", description: "Necesito ir AHORA mismo 😤🍔" },
      { userName: "foodlover_co", description: "¿Cuánto cuesta? Se ve premium" },
    ],
  },
  {
    userName: "kenji_japan",
    email: "kenji@foodgram.com",
    image: FOOD_IMAGES.sushi,
    color: "#264653",
    description: "🍣 Omakase de 12 tiempos con salmón de Noruega, atún bluefin y erizo de mar fresco. El chef Hiroshi lleva 20 años perfeccionando cada pieza. Una experiencia única.",
    tags: ["#sushi", "#omakase", "#japanese", "#bluefin"],
    likes: 731,
    comments: 89,
    restaurantName: "Sakura Omakase",
    towComents: [
      { userName: "anita_travels", description: "El mejor sushi de la ciudad sin duda" },
      { userName: "sushi_lover99", description: "Ese atún bluefin 😭❤️" },
    ],
  },
  {
    userName: "sofia_pasta",
    email: "sofia@foodgram.com",
    image: FOOD_IMAGES.pasta,
    color: "#F4A261",
    description: "🍝 Linguine al vongole hecho con almejas frescas traídas esta mañana del mercado. Ajo, vino blanco y perejil fresco. La receta de la nonna, tal como debe ser.",
    tags: ["#pasta", "#italiana", "#vongole", "#seafood"],
    likes: 198,
    comments: 28,
    restaurantName: "Osteria del Mare",
    towComents: [
      { userName: "marcos_italy", description: "Así se hace la pasta, respeto total 👏" },
      { userName: "cocina_real", description: "¡Quiero la receta!" },
    ],
  },
  {
    userName: "diego_mx",
    email: "diego@foodgram.com",
    image: FOOD_IMAGES.tacos,
    color: "#2A9D8F",
    description: "🌮 Tacos al pastor con carnita jugosa, piña asada, cebolla y cilantro. Tortilla de maíz azul recién hecha a mano. El trompo que nunca para. ¡Viva México!",
    tags: ["#tacos", "#alpastor", "#mexicanfood", "#streetfood"],
    likes: 445,
    comments: 53,
    restaurantName: "El Trompo de Don Memo",
    towComents: [
      { userName: "laura_mx", description: "¡Esos tacos son vida! 🇲🇽❤️" },
      { userName: "foodie_bogota", description: "¿Dónde queda esto?" },
    ],
  },
  {
    userName: "hiroshi_noodles",
    email: "hiroshi@foodgram.com",
    image: FOOD_IMAGES.ramen,
    color: "#E76F51",
    description: "🍜 Tonkotsu ramen con 18 horas de caldo de hueso de cerdo. Chashu pork, huevo marinado, nori y cebollín. El frío de Bogotá pide este tazón a gritos.",
    tags: ["#ramen", "#tonkotsu", "#japanese", "#noodles"],
    likes: 367,
    comments: 41,
    restaurantName: "Ramen Shiro",
    towComents: [
      { userName: "noodle_life", description: "18 horas de caldo... se nota en cada sorbo 🙏" },
      { userName: "camila_eats", description: "Perfecto para este frío bogotano!" },
    ],
  },
  {
    userName: "valentina_healthy",
    email: "vale@foodgram.com",
    image: FOOD_IMAGES.ensalada,
    color: "#52B788",
    description: "🥗 Buddha bowl de quinoa con aguacate colombiano, remolacha asada, edamame y aderezo de tahini. Colorido, nutritivo y absolutamente delicioso. ¡Comer sano nunca fue tan rico!",
    tags: ["#healthy", "#bowls", "#vegan", "#quinoa"],
    likes: 156,
    comments: 19,
    restaurantName: "Green Bowl Co.",
    towComents: [
      { userName: "fit_foodie", description: "¡Esos colores! Comida que entra por los ojos 😍" },
      { userName: "plantbased_co", description: "¿Tienen opción sin gluten?" },
    ],
  },
  {
    userName: "ana_sweets",
    email: "ana@foodgram.com",
    image: FOOD_IMAGES.cheesecake,
    color: "#CDB4DB",
    description: "🍰 Cheesecake de frutos rojos con base de galleta de mantequilla belga. La textura cremosa y el coulis de frambuesa son un pecado que vale la pena cometer.",
    tags: ["#cheesecake", "#dessert", "#bakery", "#sweet"],
    likes: 892,
    comments: 102,
    restaurantName: "Patisserie Céleste",
    towComents: [
      { userName: "sweet_tooth_co", description: "¡El mejor cheesecake de la ciudad! 🍰" },
      { userName: "reposteria_art", description: "La presentación es de otro nivel" },
    ],
  },
  {
    userName: "juan_brunch",
    email: "juan@foodgram.com",
    image: FOOD_IMAGES.pancakes,
    color: "#FFBE0B",
    description: "🥞 Stack de pancakes americanos con maple syrup puro de Vermont, mantequilla clarificada y fresas frescas. El brunch del domingo que todos merecemos.",
    tags: ["#pancakes", "#brunch", "#breakfast", "#weekend"],
    likes: 324,
    comments: 45,
    restaurantName: "Sunday Morning Café",
    towComents: [
      { userName: "brunch_lovers", description: "¡Esto es el domingo perfecto! 🌞" },
      { userName: "maple_addict", description: "Maple syrup de Vermont, eso lo dice todo 🍁" },
    ],
  },
  {
    userName: "rodrigo_asado",
    email: "rodrigo@foodgram.com",
    image: FOOD_IMAGES.steak,
    color: "#6D4C41",
    description: "🥩 Ribeye de 500g madurado 45 días en seco. Cocinado a 54°C sous vide por 2 horas y terminado en parrilla de carbón. La carne perfecta no existe... hasta hoy.",
    tags: ["#steak", "#ribeye", "#dryaged", "#bbq"],
    likes: 678,
    comments: 77,
    restaurantName: "Corte & Fuego",
    towComents: [
      { userName: "carnivore_bta", description: "Esa cocción... 45 días madurado 🥩🔥" },
      { userName: "grill_master", description: "¿Cuánto cuesta ese corte?" },
    ],
  },
  {
    userName: "patricia_peru",
    email: "patricia@foodgram.com",
    image: FOOD_IMAGES.ceviche,
    color: "#0096C7",
    description: "🐟 Ceviche clásico peruano con corvina fresca, leche de tigre casera, ají amarillo y cancha serrana. La acidez perfecta que despierta los sentidos. ¡Viva el Perú!",
    tags: ["#ceviche", "#peruanfood", "#seafood", "#latinamerica"],
    likes: 543,
    comments: 61,
    restaurantName: "Maido Bogotá",
    towComents: [
      { userName: "lima_en_bogota", description: "¡Exactamente como en Lima! Respeto 🇵🇪" },
      { userName: "seafood_lover", description: "Esa leche de tigre se ve brutal" },
    ],
  },
  {
    userName: "sara_chocolate",
    email: "sara@foodgram.com",
    image: FOOD_IMAGES.brownie,
    color: "#3D1C02",
    description: "🍫 Brownie triple chocolate con chispas de cacao 70%, nueces pecanas caramelizadas y helado de vainilla de Madagascar. El postre definitivo para los amantes del chocolate.",
    tags: ["#brownie", "#chocolate", "#dessert", "#indulgence"],
    likes: 489,
    comments: 58,
    restaurantName: "Cacao & Co.",
    towComents: [
      { userName: "chocoholic_co", description: "Triple chocolate... ya necesito ir 😩🍫" },
      { userName: "bakery_vibes", description: "Esas nueces pecanas son el toque perfecto" },
    ],
  },
  {
    userName: "martin_cafe",
    email: "martin@foodgram.com",
    image: FOOD_IMAGES.waffles,
    color: "#F3722C",
    description: "🧇 Waffles belgas con crema chantilly, compota de durazno y coulis de maracuyá colombiano. La combinación ácido-dulce que no esperabas pero que necesitabas.",
    tags: ["#waffles", "#brunch", "#maracuya", "#colombia"],
    likes: 267,
    comments: 34,
    restaurantName: "Waffle House Bogotá",
    towComents: [
      { userName: "fruta_pasion", description: "¡Maracuyá colombiano! Eso es creatividad 🇨🇴" },
      { userName: "domingo_rico", description: "Perfecto para el brunch del domingo" },
    ],
  },
  {
    userName: "claudia_bowls",
    email: "claudia@foodgram.com",
    image: FOOD_IMAGES.bowl,
    color: "#80B918",
    description: "🥙 Grain bowl con farro italiano, pollo al limón, pepinos persas, hummus casero y chips de pita. Simple, balanceado y lleno de sabor mediterráneo.",
    tags: ["#grainbowl", "#mediterranean", "#healthy", "#lunch"],
    likes: 134,
    comments: 16,
    restaurantName: "The Grain Station",
    towComents: [
      { userName: "meal_prep_co", description: "¡Esto es lo que necesito cada día!" },
      { userName: "hummus_lover", description: "El hummus casero lo cambia todo 🧆" },
    ],
  },
  {
    userName: "esteban_deli",
    email: "esteban@foodgram.com",
    image: FOOD_IMAGES.sandwich,
    color: "#4CC9F0",
    description: "🥪 Sándwich pastrami de 200g con mostaza Dijon, pepinillos alemanes, queso gruyère y pan de centeno horneado en casa. El clásico de Nueva York en Bogotá.",
    tags: ["#sandwich", "#pastrami", "#deli", "#newyorkstyle"],
    likes: 201,
    comments: 23,
    restaurantName: "Katz's Deli Bogotá",
    towComents: [
      { userName: "sandwich_world", description: "¡200g de pastrami! Sueño hecho realidad 🥪" },
      { userName: "ny_vibes", description: "El pan de centeno casero... ¡chef's kiss!" },
    ],
  },
];

// ─────────────────────────────────────────────
//  FUNCIÓN PRINCIPAL
// ─────────────────────────────────────────────
async function seedFirebase() {
  console.log("\n🍽️  FoodGram Firebase Seeder");
  console.log("═══════════════════════════════════════\n");

  const collectionRef = db.collection("postss"); // ← Cambia "posts" si tu colección tiene otro nombre

  let successCount = 0;
  let errorCount = 0;

  for (const [index, postData] of POSTS_DATA.entries()) {
    const { towComents, ...postFields } = postData;

    const docData = {
      ...postFields,
      towComents: towComents.map((c) => ({
        userName: c.userName,
        description: c.description,
      })),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    try {
      const docRef = await collectionRef.add(docData);
      console.log(`✅ [${index + 1}/${POSTS_DATA.length}] "${postData.restaurantName}" → ID: ${docRef.id}`);
      successCount++;

      // Pequeña pausa para no saturar Firestore
      await new Promise((r) => setTimeout(r, 300));
    } catch (error) {
      console.error(`❌ [${index + 1}] Error en "${postData.restaurantName}": ${error.message}`);
      errorCount++;
    }
  }

  console.log("\n═══════════════════════════════════════");
  console.log(`✅ Posts creados: ${successCount}`);
  if (errorCount > 0) console.log(`❌ Errores: ${errorCount}`);
  console.log(`📦 Colección: "posts"`);
  console.log("🎉 ¡Seed completado!\n");

  process.exit(0);
}

// ─────────────────────────────────────────────
//  EJECUTAR
// ─────────────────────────────────────────────
seedFirebase().catch((err) => {
  console.error("💥 Error fatal:", err);
  process.exit(1);
});