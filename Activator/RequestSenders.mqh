// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                               RequestSenders.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

// Returns new activation status (true if activated; false otherwise)
bool EaNinjaLicenseManagerClient::RequestActivation(string licenseKey)
{
   string response;
   string url = "https://"+m_ea_ninja_domain+"/ea/v1/pd/"+EncodeSymbols(m_product_uid)+"/mt4/activate" +
                "?license_key=" + licenseKey +
                "&is_debug=" + (m_is_debug ? "1" : "0") +
                "&account_number=" + DoubleToStr(AccountNumber(), 0) +
                "&account_company=" + EncodeUtf8(AccountCompany()) + 
                "&account_type=" + (IsDemo() ? "demo" : "real") +
                "&account_name=" + EncodeSymbols(AccountName()) +
                "&account_currency=" + EncodeSymbols(AccountCurrency()) +
                "&account_balance=" + DoubleToStr(AccountBalance(), 4) +
                "&account_equity=" + DoubleToStr(AccountEquity(), 4);
   
   if(StringLen(m_product_version) > 0){
      url = url + "&version=" + EncodeSymbols(m_product_version);
   }
   
   if(m_is_debug){
      Print("Making a http request to ", url);
   }

   if(HttpGet(url, response) && response != ""){ // Normal response from the server
      return HandleActivationResponse(response);
      
   }else{ // Something went wrong with the server communication
      if(m_is_debug){
         Print("Failed to connect to the server in GetActivationToken");
      }
      // Make all activation attempts pass.
      SetIsActivated(true);
      return(true);
   }
}

