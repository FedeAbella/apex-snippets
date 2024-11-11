@isTest
public class TestFactorySelector {
    /**
     * @description enum used to choose which factory to create.
     * Using an enum instead of SObjectType allows for multiple factories per object (e.g.: different defaults)
     */
    public enum ObjectType {
        ACCOUNTS
    }

    private static final Map<ObjectType, Type> FACTORY_TYPE_MAP = new Map<ObjectType, Type>{
        ObjectType.ACCOUNTS => TestAccountFactory.class
    };

    /**
     * @description Instantiate a new test factory of a given object type
     * @param type the object type for which to instantiate a factory
     * @return a new instance of the corresponding TestSObjectFactory implementation
     */
    public static TestSObjectFactory getFactory(ObjectType type) {
        return (TestSObjectFactory) FACTORY_TYPE_MAP.get(type).newInstance();
    }
}
