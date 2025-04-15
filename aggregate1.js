// let result1=db.ventas2.aggregate([
//   {$match: {tipo:"venta"}},
//   {$project: {
//     _id: 0,
//     cliente_id: 1,
//     fecha: 1,
//     tipo: 1,
//     productos: {
//       $filter: {
//         input: "$productos",
//         as: "producto",
//         cond: {$gt: ["$$producto.cantidad", 5]}
//       }
//     }
//   }},
//   {$sort: {fecha: -1}},
//   {$limit: 10}
// ]);


// let result2 = db.ventas2.aggregate([
//   {$match: {tipo:{$in: ["venta", "cambio","mantenimiento"]}}},
//   {$group: {_id: "$tipo", total: {$sum: 1}}},
//   {$project: {_id: 0, tipo: "$_id", total: 1}},
//   {$sort: {tipo: 1}}
// ]);

// let result3 = db.ventas2.aggregate([
//   {$match: {tipo:{$in: ["venta", "cambio","mantenimiento"]}}},
//   {$group: {_id: "$tipo", total: {$sum: 1}}},
//   {$count: "total"},
//   {$project: {_id: 0, total: 1}},
// ]);

// let result4 = db.ventas.aggregate([
//   {$match: {
//     $expr: {
//       $and: [
//         { $gt: [{ $size: "$productos" }, 2] }, // More than 2 elements
//         { $lt: [{ $size: "$productos" }, 6] } // Less than 6 elements
//       ]
//     },
//     cliente_id: { $exists: false },
//     fecha: {
//       $gte: "2025-01-01T00:00:00Z",
//       $lt: "2025-06-30T00:00:00Z"
//     }
//   }},

// ]);

// let result5 = db.ventas.aggregate([
//   {$match: {
//       fecha: {
//         $gte: ISODate("2025-01-01T00:00:00Z"),
//         $lte: ISODate("2025-01-05T00:00:00Z")
//       }
//   }},

// ]);

// let result6 = db.ventas.aggregate([
//   {$match: {
//       fecha: {
//         $gte: ISODate("2025-01-01T00:00:00Z"),
//         $lte: ISODate("2025-01-05T00:00:00Z")
//       }
//   }},
//   { $unwind: "$productos"},
//   { $group: {
//       _id: "$productos.producto_id",
//       totalCantidad: { $sum: "$productos.cantidad" },
//     }
//   }

// ]);

// console.log(result5);
// console.log(result6);

// let result7 = db.ventas2.aggregate([
//   {$match: {
//       fecha: {
//         $gte: ISODate("2025-01-01T00:00:00Z"),
//         $lte: ISODate("2025-01-05T00:00:00Z")
//       }
//   }},
//   { $sortByCount: "$tipo"},

// ]);

// console.log(result7)


let result8 = db.clientes.aggregate([
  {$match: {
    _id: {$in: ["1", "2"]}  // Filter by _id
  }},
  {
    $lookup: {
      from: "ventas",            // Collection to join
      localField: "_id",         // Field from clientes
      foreignField: "cliente_id",// Field from ventas
      as: "ventas"               // Name of the new array field
    }
  }

]);

console.log(result8)

