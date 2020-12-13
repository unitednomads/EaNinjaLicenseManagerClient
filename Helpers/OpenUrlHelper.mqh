// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                OpenUrlHelper.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

#import "shell32.dll"
int ShellExecuteW(int, const string, const string, const string, const string, int);
#import

bool EaNinjaLicenseManagerClient::OpenUrl(string url)
{
   if(!IsDllsAllowed()){
      return(false);
   }
   
   // Prepare a temporary file
   string fileName = WindowExpertName() + DoubleToStr(TimeLocal(),0) + ".URL";
   int fileHandler = FileOpen(fileName, FILE_CSV|FILE_WRITE, '~');
   
   FileWrite(fileHandler, "[InternetShortcut]");
   FileWrite(fileHandler, "URL="+url);
   FileClose(fileHandler);
   
   // Execute the shortcut
   string fileFullPath = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\" + fileName;
   int result = ShellExecuteW(0, "open", fileFullPath, NULL, NULL, 1);
   
   FileDelete(fileName);
   return (result > 32);
}