// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                             ResponseHandlers.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

// Returns true if activation is successful, false otherwise
bool EaNinjaLicenseManagerClient::HandleActivationResponse(string response)
{
   int rightPos, leftPos=0;
   string thisLine, result, userMessage, openUrl="";
   
   // Read the response
   for(int i=0; i<4; i++){
      rightPos = StringFind(response, "\n", leftPos);
      if(rightPos < 0){ //end of file reached
         thisLine = StringSubstr(response, leftPos);
      }else{
         thisLine = StringSubstr(response, leftPos, (rightPos-leftPos));
      }
      
      if(m_is_debug){
         Print("EaNinjaLicenseManagerClient::HandleActivationResponse Response Line", (i+1), ": ", thisLine);
      }
      
      switch(i){
         case 0: result = thisLine; break;
         case 1: userMessage = thisLine; break;
         case 2: openUrl = thisLine; break;
      }
      
      if(rightPos < 0) break; //no more to read
      leftPos = rightPos + 1;
   }
   
   // Set state
   if(result == "OK"){
      if(m_is_debug){
         Print("EaNinjaLicenseManagerClient::HandleActivationResponse Successful activation.");
      }
      SetIsActivated(true);
      if(m_activation_forced_success_message == ""){
         SetActivationUserMessage(userMessage);
      }else{
         SetActivationUserMessage(m_activation_forced_success_message);
      }
      if(m_input_license_key != "" && OpenLicenseKeyFile()){
         WriteLicenseKey(m_input_license_key);
         CloseLicenseKeyFile();
      }
   }else{
      if(m_is_debug){
         Print("EaNinjaLicenseManagerClient::HandleActivationResponse Activation failed.");
      }
      SetIsActivated(false);
      if(m_activation_forced_error_message == ""){
         SetActivationUserMessage(userMessage);
      }else{
         SetActivationUserMessage(m_activation_forced_error_message);
      }
   }
   
   if(openUrl != "" && m_is_open_url_enabled){
      OpenUrl(openUrl);
   }

   m_activation_did_perform = true;
   return(result == "OK");
}
