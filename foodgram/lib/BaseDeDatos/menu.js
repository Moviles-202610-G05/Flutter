const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedMenu() {
  const menuItems = [
    // Uniandes Pizzeria
    {
      name: "Margherita Pizza",
      price: "12",
      description: "Classic Italian pizza with tomato sauce, fresh mozzarella, and basil.",
      image: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Pepperoni Pizza",
      price: "14",
      description: "Pizza with extra pepperoni and melted cheese.",
      image: "https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Pasta Bolognese",
      price: "15",
      description: "Italian pasta with meat and tomato sauce.",
      image: "https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=800",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Tiramisu",
      price: "8",
      description: "Classic Italian dessert with mascarpone and cocoa.",
      image: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Bruschetta",
      price: "6",
      description: "Toasted bread with fresh tomato, garlic, and basil.",
      image: "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=800",
      restaurant: "Uniandes Pizzeria"
    },

    // Candelaria Sushi House
    {
      name: "Sushi Platter",
      price: "20",
      description: "Variety of fresh rolls with salmon, avocado, and cucumber.",
      image: "https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Salmon Nigiri",
      price: "12",
      description: "Fresh salmon nigiri over seasoned rice.",
      image: "https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=800",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Shrimp Tempura",
      price: "14",
      description: "Japanese-style battered and fried shrimp.",
      image: "https://images.unsplash.com/photo-1615361200141-f45040f367be?w=800",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Traditional Ramen",
      price: "16",
      description: "Japanese noodle soup with egg and pork.",
      image: "https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Miso Soup",
      price: "6",
      description: "Japanese soup with tofu, seaweed, and green onion.",
      image: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800",
      restaurant: "Candelaria Sushi House"
    },

    // CityU Burger Palace
    {
      name: "Classic Cheeseburger",
      price: "10",
      description: "Beef burger with cheddar cheese and French fries.",
      image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Double Bacon Burger",
      price: "14",
      description: "Double patty burger with crispy bacon and cheese.",
      image: "https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Chicken Sandwich",
      price: "12",
      description: "Fried chicken sandwich with lettuce and sauce.",
      image: "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Milkshake",
      price: "6",
      description: "Creamy shake topped with whipped cream and a cherry.",
      image: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=800",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Loaded Nachos",
      price: "9",
      description: "Nachos with melted cheese, meat, and guacamole.",
      image: "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=800",
      restaurant: "CityU Burger Palace"
    }
  ];

  for (const item of menuItems) {
    await db.collection("menu").add(item);
  }

  console.log("Menu inserted into Firestore");
}

async function seedReviews() {
  const reviews = [
    // Uniandes Pizzeria
    {
      name: "Carlos Perez",
      rating: 5,
      date: "2026-03-01",
      comment: "The best pizza I've ever had, authentic Italian flavor.",
      avatar: "CP",
      avatarColor: "#FF9800",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Maria Gomez",
      rating: 4,
      date: "2026-03-02",
      comment: "Very good pasta, although the service was a bit slow.",
      avatar: "MG",
      avatarColor: "#4CAF50",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Andres Lopez",
      rating: 5,
      date: "2026-03-03",
      comment: "The tiramisu is spectacular, I will definitely come back.",
      avatar: "AL",
      avatarColor: "#2196F3",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Lucia Torres",
      rating: 4,
      date: "2026-03-04",
      comment: "The pizza was delicious, but the place was very crowded.",
      avatar: "LT",
      avatarColor: "#9C27B0",
      restaurant: "Uniandes Pizzeria"
    },
    {
      name: "Jorge Ramirez",
      rating: 5,
      date: "2026-03-05",
      comment: "Excellent service and food, highly recommended.",
      avatar: "JR",
      avatarColor: "#F44336",
      restaurant: "Uniandes Pizzeria"
    },

    // Candelaria Sushi House
    {
      name: "Akira Tanaka",
      rating: 5,
      date: "2026-03-01",
      comment: "The sushi is fresh and delicious, authentic Japanese taste.",
      avatar: "AT",
      avatarColor: "#3F51B5",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Sofia Martinez",
      rating: 4,
      date: "2026-03-02",
      comment: "The ramen was very good, although a bit salty.",
      avatar: "SM",
      avatarColor: "#009688",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Diego Fernandez",
      rating: 5,
      date: "2026-03-03",
      comment: "The salmon nigiri is spectacular.",
      avatar: "DF",
      avatarColor: "#795548",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Laura Castillo",
      rating: 4,
      date: "2026-03-04",
      comment: "The miso soup was tasty, but the portion was small.",
      avatar: "LC",
      avatarColor: "#607D8B",
      restaurant: "Candelaria Sushi House"
    },
    {
      name: "Mateo Rios",
      rating: 5,
      date: "2026-03-05",
      comment: "Excellent experience, I will be back soon.",
      avatar: "MR",
      avatarColor: "#E91E63",
      restaurant: "Candelaria Sushi House"
    },

    // CityU Burger Palace
    {
      name: "Kevin Smith",
      rating: 5,
      date: "2026-03-01",
      comment: "The double bacon burger is incredible.",
      avatar: "KS",
      avatarColor: "#FF5722",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Ana Rodriguez",
      rating: 4,
      date: "2026-03-02",
      comment: "The fries were crispy, but the milkshake was too sweet.",
      avatar: "AR",
      avatarColor: "#CDDC39",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Luis Hernandez",
      rating: 5,
      date: "2026-03-03",
      comment: "The classic cheeseburger never fails.",
      avatar: "LH",
      avatarColor: "#FFC107",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Paula Diaz",
      rating: 4,
      date: "2026-03-04",
      comment: "The nachos were good, although a bit greasy.",
      avatar: "PD",
      avatarColor: "#8BC34A",
      restaurant: "CityU Burger Palace"
    },
    {
      name: "Tomas Vega",
      rating: 5,
      date: "2026-03-05",
      comment: "Excellent place to eat burgers.",
      avatar: "TV",
      avatarColor: "#00BCD4",
      restaurant: "CityU Burger Palace"
    }
  ];

  for (const review of reviews) {
    await db.collection("reviews").add(review);
  }

  console.log("Reviews inserted into Firestore");
}

// Run functions
seedMenu();
seedReviews();