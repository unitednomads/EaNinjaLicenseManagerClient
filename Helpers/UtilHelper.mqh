// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                   UtilHelper.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

string EaNinjaLicenseManagerClient::EncodeSymbols(string text){
   StringReplace(text, "%", "%25"); // must come first to avoid encoding %

   StringReplace(text, " ", "%20");
   StringReplace(text, "!", "%21");
   StringReplace(text, "\"", "%22");
   StringReplace(text, "#", "%23");
   StringReplace(text, "$", "%24");
   StringReplace(text, "&", "%26");
   StringReplace(text, "'", "%27");
   StringReplace(text, "(", "%28");
   StringReplace(text, ")", "%29");
   StringReplace(text, "*", "%2A");
   StringReplace(text, "+", "%2B");
   StringReplace(text, ",", "%2C");
   StringReplace(text, "-", "%2D");
   StringReplace(text, ".", "%2E");
   StringReplace(text, "/", "%2F");
   StringReplace(text, ":", "%3A");
   StringReplace(text, ";", "%3B");
   StringReplace(text, "<", "%3C");
   StringReplace(text, "=", "%3D");
   StringReplace(text, ">", "%3E");
   StringReplace(text, "?", "%3F");
   StringReplace(text, "@", "%40");
   StringReplace(text, "[", "%5B");
   StringReplace(text, "\\", "%5C");
   StringReplace(text, "]", "%5D");
   StringReplace(text, "^", "%5E");
   StringReplace(text, "_", "%5F");
   StringReplace(text, "`", "%60");
   StringReplace(text, "{", "%7B");
   StringReplace(text, "|", "%7C");
   StringReplace(text, "}", "%7D");
   StringReplace(text, "~", "%7E");
   return(text);
}

int EaNinjaLicenseManagerClient::RandBetween(int min, int max){
   MathSrand(GetTickCount());
   double offset = (double) MathRand() / 32767.0 * ((double) max - min);
   return((int) MathRound(offset) + min);
}

string EaNinjaLicenseManagerClient::EncodeUtf8(string text){
   uchar chars[];
   int length = StringToCharArray(text, chars, 0, -1, CP_UTF8);

   string encodedString;
   for (int i=0; i<length-1; i++){
      encodedString += StringFormat("%%%02x", chars[i]);	
   }

   return encodedString;
}
