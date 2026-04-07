const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedMenu() {
  const menuItems = [
    // La Pizzería
    {
      name: "Pizza Margherita",
      price: "12",
      description: "Clásica pizza italiana con salsa de tomate, mozzarella fresca y albahaca.",
      image: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Pizza Pepperoni",
      price: "14",
      description: "Pizza con abundante pepperoni y queso fundido.",
      image: "https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Pasta Bolognese",
      price: "15",
      description: "Pasta italiana con salsa de carne y tomate.",
      image: "https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Tiramisú",
      price: "8",
      description: "Postre clásico italiano con mascarpone y cacao.",
      image: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Bruschetta",
      price: "6",
      description: "Pan tostado con tomate fresco, ajo y albahaca.",
      image: "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=800",
      restaurant: "La Pizzería"
    },

    // Sushi House
    {
      name: "Sushi Platter",
      price: "20",
      description: "Variedad de rolls frescos con salmón, aguacate y pepino.",
      image: "https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Salmon Nigiri",
      price: "12",
      description: "Nigiri de salmón fresco sobre arroz avinagrado.",
      image: "https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Tempura de Camarón",
      price: "14",
      description: "Camarones rebozados y fritos al estilo japonés.",
      image: "https://images.unsplash.com/photo-1615361200141-f45040f367be?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Ramen Tradicional",
      price: "16",
      description: "Sopa japonesa con fideos, huevo y cerdo.",
      image: "https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Miso Soup",
      price: "6",
      description: "Sopa japonesa con tofu, algas y cebollín.",
      image: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800",
      restaurant: "Sushi House"
    },

    // Burger Palace
    {
      name: "Cheeseburger Clásica",
      price: "10",
      description: "Hamburguesa de res con queso cheddar y papas fritas.",
      image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Double Bacon Burger",
      price: "14",
      description: "Hamburguesa doble con tocino crujiente y queso.",
      image: "https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Chicken Sandwich",
      price: "12",
      description: "Sándwich de pollo frito con lechuga y salsa.",
      image: "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Milkshake",
      price: "6",
      description: "Batido cremoso con crema batida y cereza.",
      image: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Loaded Nachos",
      price: "9",
      description: "Nachos con queso fundido, carne y guacamole.",
      image: "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=800",
      restaurant: "Burger Palace"
    }
  ];

  for (const item of menuItems) {
    await db.collection("menu").add(item);
  }

  console.log("Menú insertado en Firestore");
}
async function seedMenu() {
  const menuItems = [
    // La Pizzería
    {
      name: "Pizza Margherita",
      price: "12",
      description: "Clásica pizza italiana con salsa de tomate, mozzarella fresca y albahaca.",
      image: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Pizza Pepperoni",
      price: "14",
      description: "Pizza con abundante pepperoni y queso fundido.",
      image: "https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Pasta Bolognese",
      price: "15",
      description: "Pasta italiana con salsa de carne y tomate.",
      image: "https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Tiramisú",
      price: "8",
      description: "Postre clásico italiano con mascarpone y cacao.",
      image: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800",
      restaurant: "La Pizzería"
    },
    {
      name: "Bruschetta",
      price: "6",
      description: "Pan tostado con tomate fresco, ajo y albahaca.",
      image: "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=800",
      restaurant: "La Pizzería"
    },

    // Sushi House
    {
      name: "Sushi Platter",
      price: "20",
      description: "Variedad de rolls frescos con salmón, aguacate y pepino.",
      image: "https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Salmon Nigiri",
      price: "12",
      description: "Nigiri de salmón fresco sobre arroz avinagrado.",
      image: "https://images.unsplash.com/photo-1559410545-0bdcd187e0a6?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Tempura de Camarón",
      price: "14",
      description: "Camarones rebozados y fritos al estilo japonés.",
      image: "https://images.unsplash.com/photo-1615361200141-f45040f367be?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Ramen Tradicional",
      price: "16",
      description: "Sopa japonesa con fideos, huevo y cerdo.",
      image: "https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=800",
      restaurant: "Sushi House"
    },
    {
      name: "Miso Soup",
      price: "6",
      description: "Sopa japonesa con tofu, algas y cebollín.",
      image: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800",
      restaurant: "Sushi House"
    },

    // Burger Palace
    {
      name: "Cheeseburger Clásica",
      price: "10",
      description: "Hamburguesa de res con queso cheddar y papas fritas.",
      image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Double Bacon Burger",
      price: "14",
      description: "Hamburguesa doble con tocino crujiente y queso.",
      image: "https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Chicken Sandwich",
      price: "12",
      description: "Sándwich de pollo frito con lechuga y salsa.",
      image: "https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Milkshake",
      price: "6",
      description: "Batido cremoso con crema batida y cereza.",
      image: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=800",
      restaurant: "Burger Palace"
    },
    {
      name: "Loaded Nachos",
      price: "9",
      description: "Nachos con queso fundido, carne y guacamole.",
      image: "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=800",
      restaurant: "Burger Palace"
    }
  ];

  for (const item of menuItems) {
    await db.collection("menu").add(item);
  }

  console.log("Menú insertado en Firestore");
}
async function seedReviews() {
  const reviews = [
    // La Pizzería
    {
      name: "Carlos Pérez",
      rating: 5,
      date: "2026-03-01",
      comment: "La mejor pizza que he probado, auténtico sabor italiano.",
      avatar: "CP",
      avatarColor: "#FF9800",
      restaurant: "La Pizzería"
    },
    {
      name: "María Gómez",
      rating: 4,
      date: "2026-03-02",
      comment: "Muy buena pasta, aunque el servicio fue un poco lento.",
      avatar: "MG",
      avatarColor: "#4CAF50",
      restaurant: "La Pizzería"
    },
    {
      name: "Andrés López",
      rating: 5,
      date: "2026-03-03",
      comment: "El tiramisú es espectacular, volveré sin duda.",
      avatar: "AL",
      avatarColor: "#2196F3",
      restaurant: "La Pizzería"
    },
    {
      name: "Lucía Torres",
      rating: 4,
      date: "2026-03-04",
      comment: "La pizza estaba deliciosa, pero el lugar estaba lleno.",
      avatar: "LT",
      avatarColor: "#9C27B0",
      restaurant: "La Pizzería"
    },
    {
      name: "Jorge Ramírez",
      rating: 5,
      date: "2026-03-05",
      comment: "Excelente atención y comida, recomendado.",
      avatar: "JR",
      avatarColor: "#F44336",
      restaurant: "La Pizzería"
    },

    // Sushi House
    {
      name: "Akira Tanaka",
      rating: 5,
      date: "2026-03-01",
      comment: "El sushi es fresco y delicioso, auténtico sabor japonés.",
      avatar: "AT",
      avatarColor: "#3F51B5",
      restaurant: "Sushi House"
    },
    {
      name: "Sofía Martínez",
      rating: 4,
      date: "2026-03-02",
      comment: "El ramen estaba muy bueno, aunque un poco salado.",
      avatar: "SM",
      avatarColor: "#009688",
      restaurant: "Sushi House"
    },
    {
      name: "Diego Fernández",
      rating: 5,
      date: "2026-03-03",
      comment: "El nigiri de salmón es espectacular.",
      avatar: "DF",
      avatarColor: "#795548",
      restaurant: "Sushi House"
    },
    {
      name: "Laura Castillo",
      rating: 4,
      date: "2026-03-04",
      comment: "La sopa miso estaba rica, pero pequeña la porción.",
      avatar: "LC",
      avatarColor: "#607D8B",
      restaurant: "Sushi House"
    },
    {
      name: "Mateo Ríos",
      rating: 5,
      date: "2026-03-05",
      comment: "Excelente experiencia, volveré pronto.",
      avatar: "MR",
      avatarColor: "#E91E63",
      restaurant: "Sushi House"
    },

    // Burger Palace
    {
      name: "Kevin Smith",
      rating: 5,
      date: "2026-03-01",
      comment: "La hamburguesa doble con bacon es increíble.",
      avatar: "KS",
      avatarColor: "#FF5722",
      restaurant: "Burger Palace"
    },
    {
      name: "Ana Rodríguez",
      rating: 4,
      date: "2026-03-02",
      comment: "Las papas fritas estaban crujientes, pero el batido muy dulce.",
      avatar: "AR",
      avatarColor: "#CDDC39",
      restaurant: "Burger Palace"
    },
    {
      name: "Luis Hernández",
      rating: 5,
      date: "2026-03-03",
      comment: "La cheeseburger clásica nunca falla.",
      avatar: "LH",
      avatarColor: "#FFC107",
      restaurant: "Burger Palace"
    },
    {
      name: "Paula Díaz",
      rating: 4,
      date: "2026-03-04",
      comment: "Los nachos estaban buenos, aunque un poco grasosos.",
      avatar: "PD",
      avatarColor: "#8BC34A",
      restaurant: "Burger Palace"
    },
    {
      name: "Tomás Vega",
      rating: 5,
      date: "2026-03-05",
      comment: "Excelente lugar para comer hamburguesas.",
      avatar: "TV",
      avatarColor: "#00BCD4",
      restaurant: "Burger Palace"
    }
  ];

  for (const review of reviews) {
    await db.collection("reviews").add(review);
  }

  console.log("Reviews insertados en Firestore");}




seedMenu();

seddReviws();
