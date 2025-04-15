let docs = [];

let tipos = ['venta', 'devolucion', 'cambio', 'mantenimiento', 'reparacion'];
let randomIndex = 0;

function randomString() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789';
    const minLength = 100;  // Minimum number of characters
    const maxLength = 1000; // Maximum number of characters
    const length = Math.floor(Math.random() * (maxLength - minLength + 1)) + minLength;
  
    let result = '';
    for (let i = 0; i < length; i++) {
      const randomChar = characters.charAt(Math.floor(Math.random() * characters.length));
      result += randomChar;
    }
    return result;
  }
  

print("Eliminando colección...");
db.ventas2.drop();

let inicio= new Date(Date.now());
let cant = 5 * 1000;

print(`Agregando ${cant} documentos al vector...`);
let inicio1= new Date(Date.now());
for (let i = 0; i < cant; i++) {
    let obs1 = randomString();
    randomIndex = Math.floor(Math.random() * tipos.length)
    let randomTipo = tipos[randomIndex];
    docs.push({
        cliente_id: (Math.floor(Math.random() * 10) + 1).toString(),
        fecha: new Date(2025, Math.floor(Math.random() * 12), Math.floor(Math.random() * 28) + 1),
        tipo: randomTipo,
        productos: Array.from({ length: Math.floor(Math.random() * 5) + 1 }, () => ({
            producto_id: (Math.floor(Math.random() * 4) + 1).toString(),
            cantidad: Math.floor(Math.random() * 10) + 1,
            observaciones: obs1,
        }))
    });
}
let fin1= new Date(Date.now());
print(`se agregaron ${cant} documentos al vector en ${fin1 - inicio1} ms.`);

print(`Agregando ${cant} documentos a la bd...`);
let inicio2= new Date(Date.now());

db.ventas2.insertMany(docs);

let fin2= new Date(Date.now());
print(`se agregaron ${cant} documentos a la colección en ${fin2 - inicio2} ms.`);

let fin = new Date(Date.now());
print(`En total tardó  ${fin-inicio} ms.`);

