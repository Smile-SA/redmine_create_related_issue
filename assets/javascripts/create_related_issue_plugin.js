function createRelatedIssuePlugin_setPredecessorFieldsVisibility() {
    relationType = $('createRelatedIssuePlugin_relation_type');
    if (relationType && (relationType.value == "precedes" || relationType.value == "follows")) {
        Element.show('createRelatedIssuePlugin_predecessor_fields');
    } else {
        Element.hide('createRelatedIssuePlugin_predecessor_fields');
    }
}
