const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedRestaurants() {
  const restaurants = [
   {
    "restaurantName": "La Pizzería",
    "restaurantImage": "https://example.com/pizza.jpg",
    "rating": 4.5,
    "price": "$$",
    "cuisine": "Italiana",
    "time": "30-40 min",
    "distance": "2 km",
    "long": -74.08175,
    "lat": 4.60971,
    'badge': 'TOP RATED',
    'badge2': 'FREE DELIVERY',
    "reviews": [
      {
        "name": "Carlos",
        "rating": "5",
        "date": "2026-03-02",
        "comment": "Excelente pizza, muy auténtica.",
        "avatar": "C",
        "avatarColor": "red"
      }
    ],
    "menu": [
      {
        "name": "Pizza Margarita",
        "price": "25.0",
        "description": "Pizza clásica con tomate y albahaca fresca.",
        "image": "https://example.com/margarita.jpg"
      },
      {
        "name": "Lasagna",
        "price": "30.0",
        "description": "Lasagna casera con carne y salsa bechamel.",
        "image": "https://example.com/lasagna.jpg"
      }
    ]
  },
  {
    "restaurantName": "Sushi House",
    "restaurantImage": "https://example.com/sushi.jpg",
    "rating": 4.7,
    "price": "$$$",
    "cuisine": "Japonesa",
    "time": "20-30 min",
    "distance": "3.5 km",
    "long": -74.08200,
    "lat": 4.61000,
    'badge': 'TOP RATED',
    'badge2': '',
    "reviews": [
      {
        "name": "Ana",
        "rating": "4",
        "date": "2026-03-01",
        "comment": "Muy fresco y delicioso.",
        "avatar": "A",
        "avatarColor": "blue"
      }
    ],
    "menu": [
      {
        "name": "Sushi Roll",
        "price": "40.0",
        "description": "Roll de sushi con salmón y aguacate.",
        "image": "https://example.com/sushiroll.jpg"
      },
      {
        "name": "Ramen",
        "price": "35.0",
        "description": "Sopa ramen con huevo y cerdo.",
        "image": "https://example.com/ramen.jpg"
      }
    ]
  },
  {
    "restaurantName": "Burger Palace",
    "restaurantImage": "https://example.com/burger.jpg",
    "rating": 4.3,
    "price": "$$",
    "cuisine": "Americana",
    "time": "25-35 min",
    "distance": "1.2 km",
    "long": -74.083,
    "lat": 4.612,
    'badge': 'GOOD',
    'badge2': '',
    "reviews": [
      {
        "name": "Miguel",
        "rating": "5",
        "date": "2026-03-02",
        "comment": "Las mejores hamburguesas que he probado.",
        "avatar": "M",
        "avatarColor": "orange"
      }
    ],
    "menu": [
      {
        "name": "Cheeseburger",
        "price": "20.0",
        "description": "Hamburguesa clásica con queso cheddar.",
        "image": "https://example.com/cheeseburger.jpg"
      },
      {
        "name": "BBQ Burger",
        "price": "25.0",
        "description": "Hamburguesa con salsa BBQ y cebolla caramelizada.",
        "image": "https://example.com/bbqburger.jpg"
      }
    ]
  }
  ];

  for (const r of restaurants) {
    await db.collection("restaurants").add(r);
  }

  console.log("Datos insertados en Firestore");
}

seedRestaurants();