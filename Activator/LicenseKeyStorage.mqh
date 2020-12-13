// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                            LicenseKeyStorage.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

bool EaNinjaLicenseManagerClient::OpenLicenseKeyFile()
{
   int fileHandle;
   string fileName = m_product_uid + "\\" + "LicenseKey";
   int failedAttempts = 0;

   ResetLastError();
   fileHandle = FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV);
   
   if(fileHandle != INVALID_HANDLE){
      m_license_key_file_handler = fileHandle;
      return(true);
   }else{
      if(m_is_debug){
         Print("Failed to open license key file: ", GetLastError());
      }
      return(false);
   }
}

string EaNinjaLicenseManagerClient::ReadLicenseKey()
{
   string licenseKey;

   if(m_license_key_file_handler != INVALID_HANDLE){   
      while(!FileIsEnding(m_license_key_file_handler))
      {
         licenseKey = FileReadString(m_license_key_file_handler); 
      }
   }else{
      Print("Unable to read license key file");
   }
   return(licenseKey);
}

bool EaNinjaLicenseManagerClient::WriteLicenseKey(string licenseKey)
{
   if(m_license_key_file_handler != INVALID_HANDLE)
   {
      ResetLastError();
      FileWriteString(m_license_key_file_handler, licenseKey);
      if(GetLastError() > 0 && m_is_debug){
         Print("An error encountered in WriteLicenseKey(): ", GetLastError());
      }
      return(true);
   }else{
      Print("Unable to open a file");
      return(false);
   }
}

void EaNinjaLicenseManagerClient::CloseLicenseKeyFile()
{
   ResetLastError();
   FileClose(m_license_key_file_handler);
   if(GetLastError() > 0 && m_is_debug){
      Print("An error encountered in CloseLicenseKeyFile(): ", GetLastError());
   }
}

