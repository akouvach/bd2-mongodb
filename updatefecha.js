db.ventas.find({}).forEach(function(doc) {
    if (typeof doc.fecha === "string") {
      var isoDate = new Date(doc.fecha); // Convert string to Date object
      db.ventas.updateOne(
        { _id: doc._id },
        { $set: { fecha: isoDate } }
      );
    }
  });
  