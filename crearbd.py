import mysql.connector
from faker import Faker
import random
from mysql.connector import Error

def generate_random_provincia():
    provincias = [
    "Buenos Aires", "Catamarca", "Chaco", "Chubut", "Córdoba",
    "Corrientes", "Entre Ríos", "Formosa", "Jujuy", "La Pampa",
    "La Rioja", "Mendoza", "Misiones", "Neuquén", "Río Negro",
    "Salta", "San Juan", "San Luis", "Santa Cruz", "Santa Fe",
    "Santiago del Estero", "Tierra del Fuego", "Tucumán"
]
    return random.choice(provincias)

def generate_random_tipo():
    tipos = ["A","B","C"]
    return random.choice(tipos)


# Configuración de conexión
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "root_password",
    "database": "mega"
}

# Conectar a la base de datos
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor()

# Crear tablas
TABLES = {
    "clientes": """
        CREATE TABLE IF NOT EXISTS clientes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nombre VARCHAR(100),
            provincia VARCHAR(50),
            tipo VARCHAR(10),
            email VARCHAR(100) UNIQUE
        )
    """,
    "productos": """
        CREATE TABLE IF NOT EXISTS productos (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nombre VARCHAR(100),
            precio DECIMAL(10,2)
        )
    """,
    "pedidos": """
        CREATE TABLE IF NOT EXISTS pedidos (
            id INT AUTO_INCREMENT PRIMARY KEY,
            cliente_id INT,
            fecha DATE
            
        )
    """,
    "detalles_pedido": """
        CREATE TABLE IF NOT EXISTS detalles_pedido (
            pedido_id INT,
            producto_id INT,
            cantidad INT,
            PRIMARY KEY (pedido_id, producto_id)
        )
    """
}

for table_name, table_sql in TABLES.items():
    cursor.execute(table_sql)
    print(f"Tabla {table_name} creada o ya existe.")


# Generar datos aleatorios
fake = Faker("es_ES")

# Insertar usuarios
NUM_CLIENTES = 500
for _ in range(NUM_CLIENTES):
    cursor.execute("INSERT INTO clientes (nombre, email, provincia, tipo) VALUES (%s, %s, %s, %s)", (fake.name(), fake.email(),generate_random_provincia(),generate_random_tipo()))
conn.commit()

# Insertar productos
NUM_PRODUCTOS = 100
for _ in range(NUM_PRODUCTOS):
    cursor.execute("INSERT INTO productos (nombre, precio) VALUES (%s, %s)", (fake.word(), round(random.uniform(1, 500), 2)))
conn.commit()

# Insertar pedidos
NUM_PEDIDOS = 90000
for _ in range(NUM_PEDIDOS):
    cursor.execute("INSERT INTO pedidos (cliente_id, fecha) VALUES (%s, %s)", (random.randint(1, NUM_CLIENTES), fake.date_this_decade()))
conn.commit()

# Insertar detalles de pedido
for nro_pedido in range(NUM_PEDIDOS):
    random_products = random.sample(range(1, NUM_PRODUCTOS), random.randint(5, 20))
    for nro_producto in random_products:
        try:
            cursor.execute("INSERT INTO detalles_pedido (pedido_id, producto_id, cantidad) VALUES (%s, %s, %s)",
                    (nro_pedido, nro_producto, random.randint(1, 50)))
        except Error as e:
            print(f"Error al insertar detalle de pedido: {e}")

# Confirmar cambios y cerrar conexión
conn.commit()
cursor.close()
conn.close()

print("Datos insertados exitosamente.")
