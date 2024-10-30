@isTest
@SuppressWarnings('PMD.ExcessiveParameterList')
public class IPRemoteImplMock implements System.StubProvider {
    public static final String ERROR_MESSAGE = 'method call threw an error';

    public enum CallType {
        OK,
        ERROR
    }

    /**
     * @description Implementation of System.StubProvider contract for mocking calls to the stub
     * @param stubbedObject the stubbed object used by the Stub API
     * @param stubbedMethodName the name of the invoked method
     * @param returnType the return type of the invoked method
     * @param listOfParamTypes the list of parameter types passed to the invoked method
     * @param listOfParamNames the list of paramenter Names passed to the invoked method
     * @param listOfArgs the list of actual arguments passed to the invoked method
     * @return null
     */
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs
    ) {
        Map<String, Object> outputArg = (Map<String, Object>) listOfArgs.get(1);
        Map<String, Object> optionsArg = (Map<String, Object>) listOfArgs.get(
            2
        );
        CallType typeOfCall = (CallType) optionsArg.get('callType');
        switch on typeOfCall {
            when OK {
                outputArg.put(IPRemoteConstants.SUCCESS_KEY, true);
            }
            when ERROR {
                throw new IPRemoteImplMockException(ERROR_MESSAGE);
            }
        }
        return null;
    }

    /**
     * @description Custom Exception class for mocking when an IPRemoteInterface implementation throws an error
     */
    public class IPRemoteImplMockException extends Exception {
    }
}
