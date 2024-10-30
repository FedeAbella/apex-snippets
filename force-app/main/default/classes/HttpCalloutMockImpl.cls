/**
 * @description Virtual class that implements an Http mock able to return multiple different responses
 */
public virtual class HttpCalloutMockImpl implements HttpCalloutMock {
    @testVisible
    private static final String NO_RESPONSE_EXCEPTION = 'no response data to return';
    private List<HttpResponse> responses;

    /**
     * @description Set a list of HttpResponse objects to return on subsequent calls to the mock.
     * This overrides all preexisting responses
     * @param responses a list of HttpResponse objects
     * @return the same HttpCalloutMockImpl instance
     */
    public HttpCalloutMockImpl setResponses(List<HttpResponse> responses) {
        this.responses = responses;
        return this;
    }

    /**
     * @description Add a single HttpResponse object to return on subsequent calls to the mock.
     * This does not remove any preexisting responses
     * @param response an HttpResponse object to return
     * @return the same HttpCalloutMockImpl instance
     */
    public HttpCalloutMockImpl addResponse(HttpResponse response) {
        if (this.responses == null) {
            this.responses = new List<HttpResponse>();
        }

        this.responses.add(response);
        return this;
    }

    /**
     * @description The mock's respond to a callout
     * @param request the HttpRequest object sent in the callout
     * @return an HttpResponse object with the callout's response
     */
    public HttpResponse respond(HttpRequest request) {
        if (this.responses == null || this.responses.isEmpty()) {
            throw new HttpCalloutMockImplException(NO_RESPONSE_EXCEPTION);
        }

        processRequest(request);
        return this.responses.remove(0);
    }

    private virtual void processRequest(HttpRequest request) {
    }

    /**
     * @description Custom exception class
     */
    public class HttpCalloutMockImplException extends Exception {
    }
}