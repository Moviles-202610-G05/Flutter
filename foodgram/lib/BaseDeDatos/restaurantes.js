const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedRestaurants() {
  const restaurants = [
    {
      "name": "Uniandes Pizzeria",
      "image": "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200",
      "rating": 4.5,
      "price": "$$",
      "cuisine": "Italian",
      "time": "10-15 min",
      "distance": "0.2 km",
      "direction": "Carrera 1 # 18a-12, Bogotá", // Cerca de la U
      "lat": 4.6018, 
      "long": -74.0665,
      "position": {
        "geohash": "d2g6qz3", 
        "geopoint": new admin.firestore.GeoPoint(4.6018, -74.0665)
      },
      "badge": "TOP RATED",
      "badge2": "FREE DELIVERY",
      "description": "Artisan pizzas ideal for lunch between classes.",
      "nuberReviews": 10,
      "spots": 340,
      "spotsA": 230,
      "tags": ["Vegetarian", "Fast Food"]
    },
    {
      "name": "Candelaria Sushi House",
      "image": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=1200",
      "rating": 4.7,
      "price": "$$$",
      "cuisine": "Japanese",
      "time": "15-20 min",
      "distance": "0.5 km",
      "direction": "Calle 12b # 3-45, La Candelaria", // Zona histórica
      "lat": 4.6005, 
      "long": -74.0675,
      "position": {
        "geohash": "d2g6qz1",
        "geopoint": new admin.firestore.GeoPoint(4.6005, -74.0675)
      },
      "badge": "TOP RATED",
      "badge2": "",
      "description": "Fresh rolls and bento boxes for students and teachers.",
      "nuberReviews": 100,
      "spots": 100,
      "spotsA": 100,
      "tags": ["Healthy", "Gluten-Free", "Dairy-Free"]
    },
    {
      "name": "CityU Burger Palace",
      "image": "https://images.unsplash.com/photo-1544025162-d76694265947?w=1200",
      "rating": 4.3,
      "price": "$$",
      "cuisine": "American",
      "time": "5-10 min",
      "distance": "0.1 km",
      "direction": "Calle 19 # 2-40, CityU Rooftop", // Ubicación CityU
      "lat": 4.6025, 
      "long": -74.0655,
      "position": {
        "geohash": "d2g6qz6",
        "geopoint": new admin.firestore.GeoPoint(4.6025, -74.0655)
      },
      "badge": "GOOD",
      "badge2": "",
      "description": "The best burgers for after a tough midterm exam.",
      "nuberReviews": 234,
      "spots": 150,
      "spotsA": 10,
      "tags": ["Fast Food", "Halal"]
    },
    {
      "name": "Suba Steak House",
      "image": "https://images.unsplash.com/photo-1544025162-d76694265947?w=1200",
      "rating": 4.6,
      "price": "$$$",
      "cuisine": "Grill",
      "time": "20-30 min",
      "distance": "0.3 km",
      "direction": "Avenida Suba # 115-50", // Sector Suba/Colina
      "lat": 4.7315, 
      "long": -74.0725,
      "position": {
        "geohash": "d2g6vsh", 
        "geopoint": new admin.firestore.GeoPoint(4.7315, -74.0725)
      },
      "badge": "PREMIUM",
      "badge2": "FREE DELIVERY",
      "description": "Aged cuts grilled over charcoal in a family atmosphere near your home.",
      "nuberReviews": 45,
      "spots": 120,
      "spotsA": 45,
      "tags": ["Keto", "Gluten-Free"]
    },
    {
      "name": "Wok & Roll Colina",
      "image": "https://images.unsplash.com/photo-1553621042-f6e147245754?w=1200",
      "rating": 4.8,
      "price": "$$",
      "cuisine": "Asian",
      "time": "15-25 min",
      "distance": "0.6 km",
      "direction": "Calle 138 # 58-10, Colina Campestre",
      "lat": 4.7335,
      "long": -74.0705,
      "position": {
        "geohash": "d2g6vsk",
        "geopoint": new admin.firestore.GeoPoint(4.7335, -74.0705)
      },
      "badge": "TOP RATED",
      "badge2": "PROMO",
      "description": "The best of sushi and pad thai with fresh local ingredients.",
      "nuberReviews": 89,
      "spots": 80,
      "spotsA": 20,
      "tags": ["Vegan", "Healthy", "Dairy-Free"]
    },
    {
      "name": "Boccone Pizza",
      "image": "https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=1200",
      "rating": 4.4,
      "price": "$",
      "cuisine": "Italian",
      "time": "10-20 min",
      "distance": "0.2 km",
      "direction": "Carrera 58 # 130-20, Portoalegre",
      "lat": 4.7328,
      "long": -74.0722,
      "position": {
        "geohash": "d2g6vsg",
        "geopoint": new admin.firestore.GeoPoint(4.7328, -74.0722)
      },
      "badge": "ECONOMY",
      "badge2": "",
      "description": "Thin-crust artisan pizza ready for takeout or to enjoy on-site.",
      "nuberReviews": 156,
      "spots": 50,
      "spotsA": 15,
      "tags": ["Vegetarian", "Fast Food"]
    }
  ];

  for (const r of restaurants) {
    await db.collection("restaurants").add(r);
  }

  console.log("Data inserted into Firestore with directions");
}

seedRestaurants();