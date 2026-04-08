const { BigQuery } = require('@google-cloud/bigquery');
const admin = require('firebase-admin');

const serviceAccount = require("C:/Users/msant/Downloads/Floter/foodgram/lib/BaseDeDatos/llave.json");

// 1. Inicializa Firebase Admin (asegúrate de tener tus credenciales)
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'foodgram-d6ef7'
});

const bq = new BigQuery({
  keyFilename: "C:/Users/msant/Downloads/Floter/foodgram/lib/BaseDeDatos/llave.json",
  projectId: 'foodgram-d6ef7'
});

const db = admin.firestore();

async function generarRecomendaciones() {
  // Envolvemos tu query para agrupar los resultados por usuario
  const query = `
  WITH usuarios_limpios AS (
    SELECT 
      JSON_VALUE(data, "$.username") AS nombre_usuario, 
      JSON_VALUE(data, "$.email") AS email, 
      pref 
    FROM \`foodgram-d6ef7.firestore_export.user_raw_latest\`, 
    UNNEST(JSON_VALUE_ARRAY(data, "$.preferences")) AS pref
  ),
  restaurantes_limpios AS (
    SELECT 
      JSON_VALUE(data, "$.name") AS name, 
      JSON_VALUE(data, "$.rating") AS rating, 
      JSON_VALUE(data, "$.image") AS image, 
      tag 
    FROM \`foodgram-d6ef7.firestore_export.restaurants_raw_latest\`, 
    UNNEST(JSON_VALUE_ARRAY(data, "$.tags")) AS tag
  ),
  matches AS (
    -- Usamos SELECT DISTINCT aquí para eliminar duplicados de restaurante por usuario
    SELECT DISTINCT 
      u.nombre_usuario, 
      u.email,
      r.name, 
      r.rating, 
      r.image
      -- Eliminamos 'u.pref' de aquí para que no genere filas distintas si coinciden varios tags
    FROM usuarios_limpios u 
    JOIN restaurantes_limpios r ON u.pref = r.tag
  )
  -- Consulta final
  SELECT 
    nombre_usuario, 
    email,
    -- Ahora ARRAY_AGG solo tendrá restaurantes únicos
    ARRAY_AGG(STRUCT(name, rating, image)) AS sugerencias
  FROM matches
  GROUP BY nombre_usuario, email
`;

  try {
    const [rows] = await bq.query(query);
    const batch = db.batch();

    rows.forEach(row => {
      const docRef = db.collection('user_recommendations').doc(row.nombre_usuario, row.email);
      batch.set(docRef, {
        email: row.email,
        sugerencias: row.sugerencias,
        actualizado: admin.firestore.FieldValue.serverTimestamp()
      });
    });

    await batch.commit();
    console.log('✅ Recomendaciones enviadas a Firestore.');
  } catch (e) {
    console.error('❌ Error:', e);
  }
}

generarRecomendaciones();
