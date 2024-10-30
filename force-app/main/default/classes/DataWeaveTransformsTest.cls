@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class DataWeaveTransformsTest {
    @isTest
    static void testTransformCsvToJson() {
        String csvInput = 'FirstColumn,SecondColumn,ThirdColumn\nValue_1,Value2,"Value3, with comma"\nRow2_Value1,"Row2_Value2 - ""Has quotes""",3';
        List<Object> resultingJson = DataWeaveTransforms.csvToJson(csvInput);

        Assert.isNotNull(resultingJson, 'return json should not be null');
        Assert.isFalse(
            resultingJson.isEmpty(),
            'return json should not be empty with data rows'
        );
        Assert.areEqual(
            2,
            resultingJson.size(),
            'return json should have 2 data rows'
        );

        Map<String, Object> row1 = (Map<String, Object>) resultingJson.get(0);
        Map<String, Object> row2 = (Map<String, Object>) resultingJson.get(1);
        Assert.isTrue(
            row1.containsKey('FirstColumn'),
            'row 1 should contain a value for the first column key'
        );
        Assert.isTrue(
            row2.containsKey('FirstColumn'),
            'row 2 should contain a value for the first column key'
        );
        Assert.isTrue(
            row1.containsKey('SecondColumn'),
            'row 1 should contain a value for the second column key'
        );
        Assert.isTrue(
            row2.containsKey('SecondColumn'),
            'row 2 should contain a value for the second column key'
        );
        Assert.isTrue(
            row1.containsKey('ThirdColumn'),
            'row 1 should contain a value for the third column key'
        );
        Assert.isTrue(
            row2.containsKey('ThirdColumn'),
            'row 2 should contain a value for the third column key'
        );

        Assert.areEqual(
            'Value_1',
            row1.get('FirstColumn'),
            'row 1\'s value for first column should match the csv'
        );
        Assert.areEqual(
            'Value2',
            row1.get('SecondColumn'),
            'row 1\'s value for second column should match the csv'
        );
        Assert.areEqual(
            'Value3, with comma',
            row1.get('ThirdColumn'),
            'row 1\'s value for third column should match the csv'
        );
        Assert.areEqual(
            'Row2_Value1',
            row2.get('FirstColumn'),
            'row 2\'s value for first column should match the csv'
        );
        Assert.areEqual(
            'Row2_Value2 - \"Has quotes\"',
            row2.get('SecondColumn'),
            'row 2\'s value for second column should match the csv'
        );
        Assert.areEqual(
            '3',
            row2.get('ThirdColumn'),
            'row 2\'s value for third column should match the csv'
        );
    }
}
