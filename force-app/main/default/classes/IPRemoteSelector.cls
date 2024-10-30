/**
 * @description Callable selector class for invoking different Apex actions from Integration Procedures.
 * Actions should implement IPRemoteInterface and have a corresponding IP_Remote_Implementation__mdt record.
 * Integration Procedures should use the IP_Remote_Implementation__mdt record DeveloperName as the action name.
 */
public with sharing class IPRemoteSelector implements Callable {
    /**
     * @description Receives an action name and arguments from Integration Procedure, instantiates the proper class
     * dependent on the metadata record, and calls its run method, passing the IP arguments
     * @param action the DeveloperName of the IP_Remote_Implementation__mdt record containing the class name
     * @param args the arguments object passed from the Integration Procedure, containint input, output, and options
     * @return null
     */
    public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get(
            IPRemoteConstants.INPUT_KEY
        );
        Map<String, Object> output = (Map<String, Object>) args.get(
            IPRemoteConstants.OUTPUT_KEY
        );
        Map<String, Object> options = (Map<String, Object>) args.get(
            IPRemoteConstants.OPTIONS_KEY
        );

        try {
            IPRemoteInterface implClass = getImplementationClass(action);
            implClass.run(input, output, options);
        } catch (Exception e) {
            output.put(IPRemoteConstants.SUCCESS_KEY, false);
            output.put(IPRemoteConstants.ERROR_KEY, e.getMessage());
        }
        return output;
    }

    private IPRemoteInterface getImplementationClass(String action) {
        IP_Remote_Implementation__mdt implMdt = getCmdtRecord(action);
        return Test.isRunningTest()
            ? (IPRemoteInterface) Test.createStub(
                  IPRemoteInterface.class,
                  new IPRemoteImplMock()
              )
            : (IPRemoteInterface) Type.forName(implMdt.Apex_Class_Name__c)
                  .newInstance();
    }

    private IP_Remote_Implementation__mdt getCmdtRecord(String developerName) {
        return Test.isRunningTest()
            ? new IP_Remote_Implementation__mdt()
            : [
                  SELECT Apex_Class_Name__c
                  FROM IP_Remote_Implementation__mdt
                  WHERE DeveloperName = :developerName
                  WITH SYSTEM_MODE
              ];
    }
}
