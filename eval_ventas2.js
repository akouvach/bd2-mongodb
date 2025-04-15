// Connect to the correct database
const db = db.getSiblingDB('ventas'); // <-- change this!
let total = 0;

db.ventas.aggregate([
  {
    $addFields: {
      docSize: { $bsonSize: "$$ROOT" }
    }
  },
  {
    $project: {
      _id: 1,
      docSize: 1
    }
  }
]).forEach(doc => {
    total += doc.docSize;
//   print(`ID: ${doc._id} - Size: ${doc.docSize} bytes`);
});

print(`Total size of all documents: ${total} bytes`);
print(`Total size of all documents: ${total / 1024 / 1024} MB`);

