/**
 * @description Contains methods for performing data transformations using DataWeave scripts
 */
public with sharing class DataWeaveTransforms {
    /**
     * @description Transform an input csv formatted string to a JSON object
     * @param csvInput a csv formatted string, including headers, using " as escape character
     * @return a deserialized JSON object
     */
    public static List<Object> csvToJson(String csvInput) {
        DataWeave.Script script = new DataWeaveScriptResource.csvToJson();
        DataWeave.Result result = script.execute(
            new Map<String, Object>{ 'payload' => csvInput }
        );
        return (List<Object>) JSON.deserializeUntyped(
            (String) result.getValue()
        );
    }
}
