/**
 * @description Abstract TestDataFactory blueprint for creating TestDataFactory classes for specific SObjects.
 * Implementations must set their sObjectType, and field defaults
 */
public inherited sharing abstract class TestSObjectFactory {
    private static final String RECORD_TYPE_ID_FIELD_NAME = 'RecordTypeId';
    private static final String ID_FIELD_NAME = 'Id';

    private final SObjectType type = this.getType();
    private final Map<SObjectField, Object> defaults = this.getDefaults();
    private String recordTypeId;
    private Map<SObjectField, Object> fieldValues = new Map<SObjectField, Object>();
    private Map<SObjectField, Object> fieldsToPopulate;

    /**
     * @description Set a map of Field tokens to field values to be added to all records
     * @param fieldValues a map of field tokens to the value given to that field
     * @return the factory instance
     */
    public TestSObjectFactory withFieldValues(Map<SObjectField, Object> fieldValues) {
        this.fieldValues = fieldValues;
        return this;
    }

    /**
     * @description Set the record type of the created records
     * @param developerName the record type's developer name
     * @return the factory instance
     */
    public TestSObjectFactory withRecordType(String developerName) {
        this.recordTypeId = this.type.getDescribe(SObjectDescribeOptions.DEFERRED)
            .getRecordTypeInfosByDeveloperName()
            .get(developerName)
            ?.getRecordTypeId();
        return this;
    }

    /**
     * @description Disable setting default values on fields
     * @return the factory instance
     */
    public TestSObjectFactory withoutDefaults() {
        this.defaults.clear();
        return this;
    }

    /**
     * @description Create and insert test records
     * @param count the number of records to insert
     * @return a list of the inserted records
     */
    public List<SObject> create(Integer count) {
        List<SObject> records = this.buildRecords(count);
        Database.insert(records, true, AccessLevel.SYSTEM_MODE);
        return records;
    }

    /**
     * @description Create and insert a single test record
     * @return the inserted sObject
     */
    public SObject createSingle() {
        return create(1).get(0);
    }

    private List<SObject> buildRecords(Integer count) {
        this.setFieldsToPopulate();

        List<SObject> records = new List<SObject>();
        for (Integer i = 0; i < count; i++) {
            SObject sObj = this.type.newSObject();
            for (SObjectField field : this.fieldsToPopulate.keySet()) {
                sObj.put(field, getFieldValue(field, i));
            }
            if (this.recordTypeId != null) {
                sObj.put(RECORD_TYPE_ID_FIELD_NAME, this.recordTypeId);
            }
            records.add(sObj);
        }

        return records;
    }

    private void setFieldsToPopulate() {
        this.fieldsToPopulate = this.getDefaults().clone();
        this.fieldsToPopulate.putAll(this.fieldValues);
    }

    private Object getFieldValue(SObjectField field, Integer index) {
        Object mapValue = this.fieldsToPopulate.get(field);
        Object value;
        if (mapValue instanceof List<Object>) {
            value = ((List<Object>) mapValue).get(index);
        } else {
            value = mapValue;
        }

        if (value instanceof SObject) {
            value = ((SObject) value).get(ID_FIELD_NAME);
        }
        return value;
    }

    private abstract SObjectType getType();
    private abstract Map<SObjectField, Object> getDefaults();
}
