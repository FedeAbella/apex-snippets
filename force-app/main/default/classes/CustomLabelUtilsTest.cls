@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class CustomLabelUtilsTest {
    @isTest
    static void returnsTheSameLabelInTestClasses() {
        String labelDevName = 'Some_Custom_Label';
        Assert.areEqual(
            labelDevName,
            CustomLabelUtils.getCurrentUserTranslation(labelDevName),
            'in test, should return the same label name'
        );
    }
}