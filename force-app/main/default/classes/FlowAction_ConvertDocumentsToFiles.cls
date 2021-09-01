public with sharing class FlowAction_ConvertDocumentsToFiles {
    /**
     * Flows cannot convert documents to files b/c they do not support blobs
     */
    @InvocableMethod(label='Convert Documents To Files')
    public static List<FlowOutput> convertDocumentsToFiles(List<FlowInput> flowInputs) {
        List<Document> documents = (List<Document>) flowInputs[0].documents;

        // Query the existing documents to be converted
        Map<Id, Document> documentIdToDocument = new Map<Id, Document>(
            [SELECT Id, Body, Type, Name FROM Document WHERE Id IN :documents]
        );

        // Convert the existing files to content versions
        Map<Id, ContentVersion> documentIdToContentVersion = new Map<Id, ContentVersion>();
        for (Document doc : documentIdToDocument.values()) {
            documentIdToContentVersion.put(
                doc.Id,
                new ContentVersion(
                    Title = doc.Name,
                    PathOnClient = doc.Name + '.' + doc.Type,
                    VersionData = doc.Body
                )
            );
        }
        insert documentIdToContentVersion.values();

        // Query the new content versions to also get the content document id
        Map<Id, ContentVersion> mapContentVersionIdToContentVersion = new Map<Id, ContentVersion>(
            [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :documentIdToContentVersion.values()]
        );

        // Create the flow outputs that match the ordering of the flow inputs
        FlowOutput output = new FlowOutput();
        for (Document doc : documents) {
            ContentVersion cv = mapContentVersionIdToContentVersion.get(documentIdToContentVersion.get(doc.Id).Id);

            output.contentVersionIds.add(cv.Id);
            output.contentDocumentIds.add(cv.ContentDocumentId);
        }
        return new List<FlowOutput>{ output };
    }

    public class FlowInput {
        @InvocableVariable(label='Document Records' required=true)
        public List<SObject> documents = new List<SObject>();
    }

    public class FlowOutput {
        @InvocableVariable(label='ContentVersion Ids')
        public List<Id> contentVersionIds = new List<Id>();

        @InvocableVariable(label='ContentDocument Ids')
        public List<Id> contentDocumentIds = new List<Id>();
    }
}