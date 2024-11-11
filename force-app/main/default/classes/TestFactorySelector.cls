@isTest
public class TestFactorySelector {
    /**
     * @description enum used to choose which factory to create.
     * Using an enum instead of SObjectType allows for multiple factories per object (e.g.: different defaults)
     */
    public enum FactoryType {
        ACCOUNTS
    }

    private static final Map<FactoryType, Type> FACTORY_TYPE_MAP = new Map<FactoryType, Type>{
        FactoryType.ACCOUNTS => TestAccountFactory.class
    };

    /**
     * @description Instantiate a new test factory of a given object type
     * @param type the object type for which to instantiate a factory
     * @return a new instance of the corresponding TestSObjectFactory implementation
     */
    public static TestSObjectFactory getFactory(FactoryType type) {
        return (TestSObjectFactory) FACTORY_TYPE_MAP.get(type).newInstance();
    }
}
