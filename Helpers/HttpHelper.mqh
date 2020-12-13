// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                   HttpHelper.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

#import "wininet.dll"
int InternetOpenW(string, int, string, string, int);
int InternetConnectW(int, string, int, string, string, int, int, int);
int InternetOpenUrlW(int, string, string, uint, uint, uint);
int InternetReadFile(int, uchar& [], int, int& []);
int InternetCloseHandle(int);
#import

bool EaNinjaLicenseManagerClient::HttpGet(string url, string& responseBody)
{
   #define INTERNET_OPEN_TYPE_DIRECT       0
   #define INTERNET_FLAG_RELOAD            0x80000000
   #define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000
   #define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100
   #define USER_AGENT                      "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)"
   #define BYTES_TO_READ                   1024

   int hSession = InternetOpenW(USER_AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);
   int HttpConnect = InternetConnectW(hSession, "", 80, "", "", 3, 0, 1); 
   
   int hReq = InternetOpenUrlW(
      hSession, url, NULL, 0, 
      INTERNET_FLAG_NO_CACHE_WRITE|INTERNET_FLAG_PRAGMA_NOCACHE|INTERNET_FLAG_RELOAD, 0
   );

   // Request failed?
   if (hReq == 0) {
      return(false);
   }

   // Prepare variables
   int     lReturnBytes[]  = { 1 };
   string  sBuffer    = "";
   uchar   arrReceive[]; //characters received in this iteration
   uchar   arrResult[];
   ArrayResize(arrReceive, BYTES_TO_READ+2);
   
   while (true) {
      // Break the loop when pointer has reached the end
      if (InternetReadFile(hReq, arrReceive, BYTES_TO_READ, lReturnBytes) <= 0
            || lReturnBytes[0] == 0) { //lReturnBytes[0] = returned bytes
         break;
      }

      int lastArrayResultSize = ArraySize(arrResult);
      
      ArrayResize(arrResult, lastArrayResultSize + lReturnBytes[0]);
      for(int i=0; i < lReturnBytes[0]; i++){
         arrResult[i+lastArrayResultSize] = arrReceive[i];
      }
   }

   // Save in responseBody variable
   responseBody = CharArrayToString(arrResult, 0, lReturnBytes[0], CP_UTF8);
   
   // Free memory
   ArrayFree(arrResult);
   ArrayFree(arrReceive);
   InternetCloseHandle(hReq);
   InternetCloseHandle(hSession);
   
   if(m_is_debug){
      Print("String length: ", StringLen(responseBody));
      Print(responseBody);
   }
   return (true);
}
