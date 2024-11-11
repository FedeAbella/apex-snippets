/**
 * @description Utility methods for working with custom labels
 */
public class CustomLabelUtils {
    /**
     * @description Takes in a Custom Label Developer Name and a Namespace, and returns the value for that Custom Label
     * in the current running user's language
     * @param label the Developer Name of the Custom Label
     * @param namespace the namespace of the Custom Label
     * @return the Custom Label translation in the running user's language
     */
    public static String getCurrentUserTranslation(
        String label,
        String namespace
    ) {
        return (Test.isRunningTest() || String.isBlank(label))
            ? label
            : System.Label.get(namespace, label, UserInfo.getLanguage());
    }

    /**
     * @description Takes in a Custom Label Developer Name, and returns the value for that Custom Label in the current
     * running user's language
     * @param label the Developer Name of the Custom Label
     * @return the Custom Label translation in the running user's language
     */
    public static String getCurrentUserTranslation(String label) {
        return getCurrentUserTranslation(label, '');
    }
}