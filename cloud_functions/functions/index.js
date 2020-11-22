"use strict";
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onInternApplicantSelectionStatusUpdated = functions.firestore.document("Internships/{internshipId}/Applicants/{ApplicantId}").onUpdate(async (change, context) => {
    let doc = change === null || change === void 0 ? void 0 : change.after.data();
    console.log(doc);

    if (doc) {
        const internshipId = context.params.internshipId;
        const ApplicantId = doc.resumeId;
        const isSelected = doc.isSelected;
        console.log(internshipId);
        console.log(ApplicantId);
        console.log(isSelected);
         
        if(isSelected===true){
            const internshipDoc = await admin.firestore().collection("Internships").doc(internshipId).get();
            const companyName = internshipDoc.data().CompanyName;
            const jobTitle = internshipDoc.data().jobTitle;
            const ApplicantDoc = await admin.firestore().collection("users").doc(ApplicantId).get();
            const deviceToken = ApplicantDoc.data().deviceToken;
            console.log(jobTitle);
            console.log(companyName);
            console.log(deviceToken);
            const not1 = {
                "notification": {
                    title: companyName,
                    body: 'You have been shorlisted for ' + jobTitle ,
                    },
                token: deviceToken,
                }
        return admin.messaging().send(not1);   
        }
}});

exports.onQuickFixApplicantSelectionStatusUpdated = functions.firestore.document("QuickFixes/{quickfixId}/Applicants/{ApplicantId}").onUpdate(async (change, context) => {
    let doc = change === null || change === void 0 ? void 0 : change.after.data();
    console.log(doc);

    if (doc) {
        const quickfixId = context.params.quickfixId;
        const ApplicantId = doc.resumeId;
        const isSelected = doc.isSelected;
        console.log(quickfixId);
        console.log(ApplicantId);
        console.log(isSelected);
         
        if(isSelected===true){
            const quickfixDoc = await admin.firestore().collection("QuickFixes").doc(quickfixId).get();
            const companyName = quickfixDoc.data().CompanyName;
            const jobTitle = quickfixDoc.data().jobTitle;
            const ApplicantDoc = await admin.firestore().collection("users").doc(ApplicantId).get();
            const deviceToken = ApplicantDoc.data().deviceToken;
            console.log(jobTitle);
            console.log(companyName);
            console.log(deviceToken);
            const not1 = {
                "notification": {
                    title: companyName,
                    body: 'You are selected for '+ jobTitle,
                    },
                token: deviceToken,
                }
        return admin.messaging().send(not1);   
        }
}});

exports.onProjectApplicantSelectionStatusUpdated = functions.firestore.document("Projects/{projectId}/Applicants/{ApplicantId}").onUpdate(async (change, context) => {
    let doc = change === null || change === void 0 ? void 0 : change.after.data();
    console.log(doc);

    if (doc) {
        const projectId = context.params.projectId;
        const ApplicantId = doc.resumeId;
        const isSelected = doc.isSelected;
        console.log(projectId);
        console.log(ApplicantId);
        console.log(isSelected);
         
        if(isSelected===true){
            const projectDoc = await admin.firestore().collection("Projects").doc(projectId).get();
            const projectTitle = projectDoc.data().projectTitle;
            const ApplicantDoc = await admin.firestore().collection("users").doc(ApplicantId).get();
            const deviceToken = ApplicantDoc.data().deviceToken;
            console.log(projectTitle);
            console.log(deviceToken);
            const not1 = {
                "notification": {
                    body: 'You have been selected for ' + projectTitle,
                    },
                token: deviceToken,
                }
        return admin.messaging().send(not1);   
        }
}});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
