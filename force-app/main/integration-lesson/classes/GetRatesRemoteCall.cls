/**
 * Created by Dasha Mitina on 09.09.2019.
 */

public with sharing class GetRatesRemoteCall extends RemoteCall{
    public class GetRatesRemote{
        public String base;
        public Map<String, Decimal> rates;
    }

    public GetRatesRemoteCall(String currencyBase) {
        this.endPointURL = 'callout:GetRates' + '?base=' + currencyBase;
        this.httpMethod = METHOD_GET;
    }



    public override Type getType() {
        return GetRatesRemoteCall.class;
    }

    protected override String buildRequestBody() {
        return null;
    }

    protected override Object parseResponse(String responseBody) {
        GetRatesRemote response = (GetRatesRemote)JSON.deserialize(responseBody, GetRatesRemote.class);
        return response.rates;
    }
}