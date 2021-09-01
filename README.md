# Flow Action - Convert Documents to Files

At the time of writing this, flows are not able to handle blob data types.

This means we need an invocable apex method to handle the conversion of documents to files within a flow.

## 📦 Install

**via sfdx-cli**
`sfdx force:package:install --package 0Ho5e00000000dyCAA -u your@org.user`

**via url**
login and navigate to [`/packaging/installPackage.apexp?p0=0Ho5e00000000dyCAA`](https://login.salesforce.com/packaging/installPackage.apexp?p0=0Ho5e00000000dyCAA). Choose `Install for: Admin Only`.

## 🔨 Usage

1. Create a flow
2. Query for the document records that need to be converted (ensure the Id is present)
3. Add an Action element and search for ``Convert Documents to Files``
4. Send the document records to the action
5. Iterate over the returned ContentVersionIds or ContentDocumentIds

## ✨Features

### Reusable

- Can be used from Flows, Processes, REST API

### Ordering

- The order of the returned ContentVersionIds and ContentDocumentIds are in the same order as the documents sent to the invocable method

** Powered by ** [Callaway Cloud Consulting](https://www.callawaycloud.com/)