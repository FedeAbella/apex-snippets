/**
 * @description TestSObjectFactory implementation to create test accounts
 */
@isTest
public class TestAccountFactory extends TestSObjectFactory {
    private SObjectType getType() {
        return Account.getSObjectType();
    }

    private Map<SObjectField, Object> getDefaults() {
        return new Map<SObjectField, Object>{
            Account.Name => 'Test_Account',
            Account.Phone => '00000'
        };
    }
}