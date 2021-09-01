@IsTest
private class FlowAction_ConvertDocumentsToFilesTest {
    private static Integer amountOfDocumentsToTestWith = 5;

    @IsTest
    private static void createFileTest() {
        // Create the test documents
        List<Document> testDocuments = createDocuments();

        // Create an instance of flow inputs
        FlowAction_ConvertDocumentsToFiles.FlowInput flowInput = new FlowAction_ConvertDocumentsToFiles.FlowInput();
        flowInput.documents = testDocuments;

        // Create the list of flow inputs to send to constructor
        List<FlowAction_ConvertDocumentsToFiles.FlowInput> flowInputs = new List<FlowAction_ConvertDocumentsToFiles.FlowInput>{};
        flowInputs.add(flowInput);

        Test.startTest();
        FlowAction_ConvertDocumentsToFiles.FlowOutput[] flowOutputs = FlowAction_ConvertDocumentsToFiles.convertDocumentsToFiles(
            flowInputs
        );
        Test.stopTest();

        System.assertEquals(1, flowOutputs.size(), 'Expected 1 set of flow results returned');
        System.assertEquals(
            amountOfDocumentsToTestWith,
            flowOutputs[0].ContentVersionIds.size(),
            'We did not get a content version id for each Document'
        );
        System.assertEquals(
            amountOfDocumentsToTestWith,
            flowOutputs[0].ContentDocumentIds.size(),
            'We did not get a content document id for each Document'
        );
    }

    private static List<Document> createDocuments() {
        List<Document> testDocuments = new List<Document>();
        for (Integer i = 0; i < amountOfDocumentsToTestWith; i++) {
            String documentNameAndBody = 'TestDocument' + String.valueOf(i);

            testDocuments.add(
                new Document(
                    Body = Blob.valueOf(documentNameAndBody),
                    ContentType = 'application/pdf',
                    Type = 'PDF',
                    DeveloperName = documentNameAndBody,
                    IsPublic = true,
                    Name = documentNameAndBody,
                    FolderId = UserInfo.getUserId()
                )
            );
        }
        insert testDocuments;
        return testDocuments;
    }
}