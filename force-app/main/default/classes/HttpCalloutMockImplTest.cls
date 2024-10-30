@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class HttpCalloutMockImplTest {
    @isTest
    static void throwsExceptionIfNoResponses() {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        try {
            new Http().send(new HttpRequest());
            Assert.fail(
                'mock should have thrown exception due to having no response data'
            );
        } catch (Exception e) {
            Assert.isInstanceOfType(
                e,
                HttpCalloutMockImpl.HttpCalloutMockImplException.class,
                'exception thrown should be of custom type'
            );
            Assert.areEqual(
                HttpCalloutMockImpl.NO_RESPONSE_EXCEPTION,
                e.getMessage(),
                'exception message should match class defined message'
            );
        }
    }

    @isTest
    static void respondsMultipleTimesWithDifferentResponses() {
        HttpResponse firstResponse = new HttpResponse();
        firstResponse.setStatusCode(200);
        firstResponse.setBody('success');
        HttpResponse secondResponse = new HttpResponse();
        secondResponse.setStatusCode(500);
        secondResponse.setBody('internal server error');
        HttpResponse thirdResponse = new HttpResponse();
        thirdResponse.setStatusCode(400);
        thirdResponse.setBody('wrong input');
        List<HttpResponse> responses = new List<HttpResponse>{
            firstResponse,
            secondResponse,
            thirdResponse
        };
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl()
            .setResponses(responses);

        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response1 = new Http().send(new HttpRequest());
        Assert.areEqual(
            firstResponse,
            response1,
            'first callout response should match first response in list'
        );

        HttpResponse response2 = new Http().send(new HttpRequest());
        Assert.areEqual(
            secondResponse,
            response2,
            'second callout response should match second response in list'
        );

        HttpResponse response3 = new Http().send(new HttpRequest());
        Assert.areEqual(
            thirdResponse,
            response3,
            'third callout response should match third response in list'
        );

        try {
            new Http().send(new HttpRequest());
            Assert.fail(
                'mock should have thrown exception after running out of responses'
            );
        } catch (Exception e) {
            Assert.isInstanceOfType(
                e,
                HttpCalloutMockImpl.HttpCalloutMockImplException.class,
                'exception thrown should be of custom type'
            );
            Assert.areEqual(
                HttpCalloutMockImpl.NO_RESPONSE_EXCEPTION,
                e.getMessage(),
                'exception message should match class defined message'
            );
        }
    }

    @isTest
    static void addsNewResponsesCorrectly() {
        HttpResponse firstResponse = new HttpResponse();
        firstResponse.setStatusCode(200);
        firstResponse.setBody('success');
        List<HttpResponse> responses = new List<HttpResponse>{ firstResponse };
        HttpCalloutMockImpl mock = new HttpCalloutMockImpl()
            .setResponses(responses);

        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response1 = new Http().send(new HttpRequest());
        Assert.areEqual(
            firstResponse,
            response1,
            'first callout response should match first response in list'
        );

        HttpResponse newResponse = new HttpResponse();
        newResponse.setStatusCode(400);
        mock.addResponse(newResponse);

        HttpResponse response2 = new Http().send(new HttpRequest());
        Assert.areEqual(
            newResponse,
            response2,
            'second callout response should match new added response'
        );
    }
}