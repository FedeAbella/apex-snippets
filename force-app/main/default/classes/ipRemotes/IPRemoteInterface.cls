/**
 * @description Defines the contract for classes that perform logic called from Integration Procedure Remote Actions.
 * Implementing classes should provide concrete implementations of the run method with correspoding logic.
 */
public interface IPRemoteInterface {
    /**
     * @description Entry-point method for calling the class from IPRemoteSelector.
     * Should accept input, output, and options maps as coming from the Integration Procedure and implement
     * the correct logic based on them.
     * @param input the input map as received from the Integration Procedure
     * @param output the output map as received from the Integration Procedure.
     * Results passed to the IP should be added to this.
     * @param options the options map as received from the Integration Procedure.
     */
    void run(
        Map<String, Object> input,
        Map<String, Object> output,
        Map<String, Object> options
    );
}
