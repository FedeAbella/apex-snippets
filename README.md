# Apex Snippets

A collection of apex classes and useful pieces of code to simplify and/or
jumpstart my (and your) code.

## Custom Labels

Use `CustomLabelUtils` to get custom label translations to the running user's
language with 

```apex
CustomLabelUtils.getCurrentUserTranslation(labelName)
```

If the label is in a namespace, instead use 

```apex
CustomLabelUtils.getCurrentUserTranslation(labelName, namespace)
```

## Dataweave

`DataWeaveTransforms` contains static methods to transform data using the
scripts found in `force-app/main/default/dw`. e.g.: to transform a csv string
into a JSON encoded object, call

```apex
DataWeaveTransforms.csvToJson(csvString)
```

This returns an array of JSON objects which map to the csv rows.

## IP Remotes

Contains an interface to implement `Callable` classes to use in Omnistudio
Integration Procedures, by having a single entry point in `IPRemoteSelector` and
a custom metadata type to select the appropriate action.

## Mocks

Mocks to use while testing apex.

For example, `HttpCalloutMockImpl` is a virtual
class that allows to queue multiple responses for when a unit test performs
multiple callouts and different responses are needed. This can be implemented as

```apex
HttpResponse response_1 = new HttpResponse();
HttpResponse response_2 = new HttpResponse();

HttpCalloutMock mock = new HttpCalloutMockImpl()
.setResponses(
    new List<HttpResponse>{response_1, response_2}
);

Test.setMock(HttpCalloutMock.class, mock);
```

Also, a single new response can be added to the response queue by using

```apex
mock.addResponse(new HttpResponse());
```

If the mock needs to do anything with the received `HttpRequest`, an extending
class can override `processRequest(request)` to perform any additional actions.

## Test Factories

Provides an abstract class used to create test records during apex unit tests in
a reusable, clearer, and more verbose way, without the need to create huge `TestDataFactory`
classes that attempt to do too much. Classes can extend `TestSObjectFactory` and
just implement `getType` and `getDefaults` to set the `SObjectType` of records
to create, and some default field values. As an example `TestAccountFactory` can
be used to create test accounts such as

```apex
List<Account> testAccounts = (List<Account>) new TestAccountFactory().create(10);
```

Records can be created using a Record Type by passing the RT's `DeveloperName`
as

```apex
List<Account> testAccountsWithRT = (List<Account>) new TestAccountFactory()
.withRecordType('Some_Record_Type')
.create(5);
```

Field values (aside from default ones defined in the factory) can be set like

```apex
List<Account> testAccountsWithValues = (List<Account>) new TestAccountFactory()
.withFieldValues(
    new Map<SObjectField, Object>{
        Account.Industry => 'Engineering',
        Account.NumberOfEmployees => 150
    }
).create(3);
```

Default values can be bypassed by using `.withoutDefaults()`. A single record can
be created using `.createSingle()` instead of `.create(n)`, which also returns a
single `sObject`.

If multiple records need to be created with different values for a same field, a
list of values can be passed in the `.withFieldValues` map, like so

```apex
List<Account> differentFieldValues = (List<Account>) new TestAccountFactory()
.withFieldValues(
    new Map<SObjectField, Object>{
        Account.Website => new List<Object>{'https://www.github.com', 'https://www.salesforce.com'}
    }
).create(2);
```

Each passed list must contain at least as many values as records to create.

Finally, for any lookup fields, an `sObject` can be passed instead of having to
reference the `Id` field directly:

```apex
List<Account> accs = (List<Account>) new TestAccountFactory().create(10);
List<Contact> conts = (List<Contact>) new TestContactFactory().withFieldValues(
    new Map<SObjectField, Object> {
        Contact.AccountId => accs
    }
).create(10);
```

If using multiple `TestSObjectFactory` extensions, `TestFactorySelector` can be
used to provide a single entry point from which to instantiate all factories by
using an enum to reference them instead.
