const functions = require('firebase-functions');

exports.myFunction = functions.firestore
  .document('users/{uid}/level/{uid}')
  .onWrite((change, context) => { /* ... */ });
