@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class IPRemoteSelectorTest {
    @isTest
    private static void testCorrectCall() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>{
            'callType' => IPRemoteImplMock.CallType.OK
        };
        IPRemoteSelector selector = new IPRemoteSelector();

        selector.call(
            'Implementation',
            new Map<String, Object>{
                IPRemoteConstants.INPUT_KEY => input,
                IPRemoteConstants.OUTPUT_KEY => output,
                IPRemoteConstants.OPTIONS_KEY => options
            }
        );

        Assert.istrue(
            output.containsKey(IPRemoteConstants.SUCCESS_KEY),
            'output should contain a success key added by call'
        );
        Assert.isTrue(
            (Boolean) output.get(IPRemoteConstants.SUCCESS_KEY),
            'output success key should map to true'
        );
    }

    @isTest
    private static void testErrorCall() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>{
            'callType' => IPRemoteImplMock.CallType.ERROR
        };
        IPRemoteSelector selector = new IPRemoteSelector();

        selector.call(
            'Implementation',
            new Map<String, Object>{
                IPRemoteConstants.INPUT_KEY => input,
                IPRemoteConstants.OUTPUT_KEY => output,
                IPRemoteConstants.OPTIONS_KEY => options
            }
        );

        Assert.istrue(
            output.containsKey(IPRemoteConstants.SUCCESS_KEY),
            'output should contain a success key added by call'
        );
        Assert.isFalse(
            (Boolean) output.get(IPRemoteConstants.SUCCESS_KEY),
            'output success key should map to false'
        );
        Assert.isTrue(
            output.containsKey(IPRemoteConstants.ERROR_KEY),
            'output should contain an error key added by Selector'
        );
        Assert.areEqual(
            IPRemoteImplMock.ERROR_MESSAGE,
            (String) output.get(IPRemoteConstants.ERROR_KEY),
            'output error key should map to message thrown by Exception'
        );
    }
}
