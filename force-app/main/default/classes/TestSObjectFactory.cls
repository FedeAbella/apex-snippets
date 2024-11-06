/**
 * @description Abstract TestDataFactory blueprint for creating TestDataFactory classes for specific SObjects.
 * Implementations must set their sObjectType, and field defaults
 */
public inherited sharing abstract class TestSObjectFactory {
    private static final String RECORD_TYPE_ID_FIELD_NAME = 'RecordTypeId';
    private final SObjectType type = this.getType();
    private final Map<String, RecordTypeInfo> typeRecordTypes = this.type.getDescribe(
            SObjectDescribeOptions.DEFERRED
        )
        .getRecordTypeInfosByDeveloperName();
    private String recordTypeId;
    private List<SObject> records = new List<SObject>();
    private Map<SObjectField, Object> fieldValues = new Map<SObjectField, Object>();
    private Map<SObjectField, Object> fieldsToPopulate;

    /**
     * @description Set a map of Field tokens to field values to be added to all records
     * @param fieldValues a map of field tokens to the value given to that field
     * @return the factory instance
     */
    public TestSObjectFactory withFieldValues(
        Map<SObjectField, Object> fieldValues
    ) {
        this.fieldValues = fieldValues;
        return this;
    }

    /**
     * @description Set the record type of the created records
     * @param developerName the record type's developer name
     * @return the factory instance
     */
    public TestSObjectFactory withRecordType(String developerName) {
        if (!this.typeRecordTypes.containsKey(developerName)) {
            throw new TestSObjectFactoryException(
                'Invalid record type for SObjectType'
            );
        }

        this.recordTypeId = this.typeRecordTypes.get(developerName)
            .getRecordTypeId();
        return this;
    }

    /**
     * @description Create and insert test records
     * @param count the number of records to insert
     * @return a list of the inserted records
     */
    public List<SObject> put(Integer count) {
        this.createRecords(count);
        Database.insert(this.records, true, AccessLevel.SYSTEM_MODE);
        return this.records;
    }

    private Map<SObjectField, Object> getFieldsToPopulate() {
        Map<SObjectField, Object> fieldsToPopulate = this.getDefaults().clone();
        fieldsToPopulate.putAll(this.fieldValues);
        return fieldsToPopulate;
    }

    private void createRecords(Integer count) {
        this.setFieldsToPopulate();

        for (Integer i = 0; i < count; i++) {
            SObject sObj = this.type.newSObject();
            if (this.recordTypeId != null) {
                sObj.put(RECORD_TYPE_ID_FIELD_NAME, this.recordTypeId);
            }
            for (SObjectField field : this.fieldsToPopulate.keySet()) {
                sObj.put(field, getFieldValueToPopulate(field, i));
            }
            this.records.add(sObj);
        }
    }

    private void setFieldsToPopulate() {
        this.fieldsToPopulate = this.getDefaults().clone();
        this.fieldsToPopulate.putAll(this.fieldValues);
    }

    private Object getFieldValueToPopulate(SObjectField field, Integer index) {
        Object mapValue = this.fieldsToPopulate.get(field);
        if (mapValue instanceof List<Object>) {
            return ((List<Object>) mapValue).get(index);
        }
        return mapValue;
    }

    private abstract SObjectType getType();
    private abstract Map<SObjectField, Object> getDefaults();

    /**
     * @description Custom exception class
     */
    public class TestSObjectFactoryException extends Exception {
    }
}