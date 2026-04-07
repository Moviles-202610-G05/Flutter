const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedRestaurants() {
 const restaurants = [
    {
      "name": "La Pizzería Uniandes",
      "restaurantImage": "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200",
      "rating": 4.5,
      "price": "$$",
      "cuisine": "Italiana",
      "time": "10-15 min",
      "distance": "0.2 km",
      "lat": 4.6018, // Muy cerca de la entrada de la 18
      "long": -74.0665,
      "position": {
        "geohash": "d2g6qz3", // Geohash aproximado de la zona
        "geopoint": new admin.firestore.GeoPoint(4.6018, -74.0665)
      },
      "badge": "TOP RATED",
      "badge2": "FREE DELIVERY",
      "description": "Pizzas artesanales ideales para el almuerzo entre clases.",
      "nuberReviews": 10,
      "spots": 340,
      "spotsA": 230
    },
    {
      "name": "Sushi House Candelaria",
      "restaurantImage": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=1200",
      "rating": 4.7,
      "price": "$$$",
      "cuisine": "Japonesa",
      "time": "15-20 min",
      "distance": "0.5 km",
      "lat": 4.6005, // Cerca del eje ambiental
      "long": -74.0675,
      "position": {
        "geohash": "d2g6qz1",
        "geopoint": new admin.firestore.GeoPoint(4.6005, -74.0675)
      },
      "badge": "TOP RATED",
      "badge2": "",
      "description": "Rollos frescos y bento boxes para estudiantes y profesores.",
      "nuberReviews": 100,
      "spots": 100,
      "spotsA": 100
    },
    {
      "name": "Burger Palace CityU",
      "restaurantImage": "https://images.unsplash.com/photo-1544025162-d76694265947?w=1200",
      "rating": 4.3,
      "price": "$$",
      "cuisine": "Americana",
      "time": "5-10 min",
      "distance": "0.1 km",
      "lat": 4.6025, // Justo en la zona de las torres de CityU
      "long": -74.0655,
      "position": {
        "geohash": "d2g6qz6",
        "geopoint": new admin.firestore.GeoPoint(4.6025, -74.0655)
      },
      "badge": "GOOD",
      "badge2": "",
      "description": "Las mejores hamburguesas para después de un parcial pesado.",
      "nuberReviews": 234,
      "spots": 150,
      "spotsA": 10
    },
    {"name": "Suba Steak House",
      "restaurantImage": "https://images.unsplash.com/photo-1546241072-48010ad28c2c?w=1200",
      "rating": 4.6,
      "price": "$$$",
      "cuisine": "Parrilla",
      "time": "20-30 min",
      "distance": "0.3 km",
      "lat": 4.7315, 
      "long": -74.0725,
      "position": {
        "geohash": "d2g6vsh", 
        "geopoint": new admin.firestore.GeoPoint(4.7315, -74.0725)
      },
      "badge": "PREMIUM",
      "badge2": "FREE DELIVERY",
      "description": "Cortes madurados a la brasa en un ambiente familiar cerca de tu casa.",
      "nuberReviews": 45,
      "spots": 120,
      "spotsA": 45
    },
    {
      "name": "Wok & Roll Colina",
      "restaurantImage": "https://images.unsplash.com/photo-1553621042-f6e147245754?w=1200",
      "rating": 4.8,
      "price": "$$",
      "cuisine": "Asiática",
      "time": "15-25 min",
      "distance": "0.6 km",
      "lat": 4.7335,
      "long": -74.0705,
      "position": {
        "geohash": "d2g6vsk",
        "geopoint": new admin.firestore.GeoPoint(4.7335, -74.0705)
      },
      "badge": "TOP RATED",
      "badge2": "PROMO",
      "description": "Lo mejor del sushi y pad thai con ingredientes frescos locales.",
      "nuberReviews": 89,
      "spots": 80,
      "spotsA": 20
    },
    {
      "name": "Boccone Pizza",
      "restaurantImage": "https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=1200",
      "rating": 4.4,
      "price": "$",
      "cuisine": "Italiana",
      "time": "10-20 min",
      "distance": "0.2 km",
      "lat": 4.7328,
      "long": -74.0722,
      "position": {
        "geohash": "d2g6vsg",
        "geopoint": new admin.firestore.GeoPoint(4.7328, -74.0722)
      },
      "badge": "ECONOMY",
      "badge2": "",
      "description": "Pizza artesanal de masa delgada lista para llevar o disfrutar en el sitio.",
      "nuberReviews": 156,
      "spots": 50,
      "spotsA": 15
    }
  ];

  for (const r of restaurants) {
    await db.collection("restaurants").add(r);
  }

  console.log("Datos insertados en Firestore");
}





seedRestaurants();