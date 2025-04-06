
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteOfficerAccount = functions.https.onCall(async (data, context) => {
    // Ensure the request is from an Admin
    const adminUid = context.auth?.uid;
    if (!adminUid) {
        throw new functions.https.HttpsError('unauthenticated', 'Only authenticated users can delete accounts.');
    }

    // Get admin's role from Firestore
    const adminDoc = await admin.firestore().collection('users').doc(adminUid).get();
    if (!adminDoc.exists || adminDoc.data().role !== "Admin") {
        throw new functions.https.HttpsError('permission-denied', 'Only admins can delete officers.');
    }

    const officerUid = data.uid;
    if (!officerUid) {
        throw new functions.https.HttpsError('invalid-argument', 'Officer UID is required.');
    }

    try {
        // Delete user from Authentication
        await admin.auth().deleteUser(officerUid);

        // Delete Firestore document
        await admin.firestore().collection('users').doc(officerUid).delete();

        return { success: true, message: "Officer account deleted successfully." };
    } catch (error) {
        throw new functions.https.HttpsError('internal', 'Failed to delete officer.', error);
    }
});

