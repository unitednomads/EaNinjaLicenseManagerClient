// ✓ KEEP THIS LINE TO ENSURE THAT THIS FILE IS SAVED IN UNICODE ✓
//+------------------------------------------------------------------+
//|                                                EaNinjaLicenseManagerClient.mqh |
//|                                 Copyright 2019, United Nomads OU |
//|                                               https://eaninja.eu |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, United Nomads OU"
#property link      "https://eaninja.eu"
#property strict

class EaNinjaLicenseManagerClient{
private:
   string m_ea_ninja_domain;
   string m_product_uid;
   string m_product_version;
   bool m_activation_did_perform;
   bool m_is_activated;
   bool m_is_debug;
   string m_dll_error_message;
   datetime m_dll_alerted_at;
   bool m_is_follower;
   bool m_is_open_url_enabled;

   int m_text_window;
   int m_text_pos_x;
   int m_text_pos_y;
   int m_text_corner;
   int m_text_font_size;
   string m_text_font_name;

   // Activation
   string m_activation_token;
   string m_input_license_key;
   string m_activation_user_message;
   color m_activation_success_color;
   color m_activation_error_color;
   string m_activation_forced_success_message;
   string m_activation_forced_error_message;
   int m_license_key_file_handler;
   
public:
   // General setters
   string SetEaNinjaDomain(string domain);
   string SetProductUid(string product_uid);
   string SetProductVersion(string version);
   bool   SetActivationDidPerform(bool activationDidPerform);
   bool   SetIsDebug(bool isDebug);
   string SetDllErrorMessage(string message);
   bool   SetIsFollower(bool isFollower); // Read ActivationStatusGlobalVariableKey only global variable
   bool   SetIsOpenUrlEnabled(bool isOpenUrlEnabled);

   int    SetTextWindow(int window);
   int    SetTextPosX(int pos_x);
   int    SetTextPosY(int pos_y);
   int    SetTextCorner(int corner);
   int    SetTextFontSize(int fontSize);
   string SetTextFontName(string fontName);

   // Activation-related setters
   string SetInputLicenseKey(string licenseKey);
   color  SetActivationSuccessColor(color clrCode);
   color  SetActivationErrorColor(color clrCode);
   string SetActivationForcedSuccessMessage(string message);
   string SetActivationForcedErrorMessage(string message);

private:
   bool   HttpGet(string strUrl, string& strWebPage);
   bool   OpenUrl(string url);

   bool   SetIsActivated(bool isActivated);
   bool   RequestActivation(string licenseKey);
   bool   HandleActivationResponse(string response);
   string ActivationStatusGlobalVariableKey();
   string SetActivationUserMessage(string userMessage);
   void   RenderActivationUserMessage();

   bool   OpenLicenseKeyFile();
   string ReadLicenseKey();
   bool   WriteLicenseKey(string token);
   void   CloseLicenseKeyFile();

   void   RenderTextLabel(string label, string text, color clrCode);
   void   DeleteTextLabels();
   string TextLabelPrefix();

   string EncodeSymbols(string text);
   string EncodeUtf8(string text);
   int    RandBetween(int min, int max);

public:
   // Constructor
   EaNinjaLicenseManagerClient(string ea_ninja_domain=NULL, string product_uid="", string version=""){ 
      if(StringLen(ea_ninja_domain) > 0){
         SetEaNinjaDomain(ea_ninja_domain);
      }
      if(StringLen(product_uid) > 0){
         SetProductUid(product_uid);
      }
      if(StringLen(version) > 0){
         SetProductVersion(version);
      }
      m_is_activated = false;
      m_is_debug = false;
      m_activation_did_perform = false;
      m_dll_error_message = "Please allow DLL import";
      m_dll_alerted_at = 0;
      m_is_follower = false;
      m_is_open_url_enabled = false;

      m_activation_success_color = clrLime;
      m_activation_error_color = clrRed;
      m_activation_forced_success_message = "";
      m_activation_forced_error_message = "";
      
      m_text_window = 0;
      m_text_font_size = 10;
      m_text_pos_x = 15;
      m_text_pos_y = 15;
      m_text_corner = 0;
      m_text_font_name = "Meiryo UI";

      m_license_key_file_handler = 0;
   }
   
   // Public getter for utility
   bool IsActivated(){
      return(m_is_activated);
   }
   
   bool Activate() {
      string licenseKey;

      if(ActivationDidPerform()){
         return(IsActivated());
      }
      
      if(!IsDllsAllowed()){
         if(m_dll_alerted_at < TimeLocal() - 30){
            Alert("Please allow DLL import");
            m_dll_alerted_at = TimeLocal();
         }
         return(false);
      }

      if(m_input_license_key == ""){
         if(!OpenLicenseKeyFile()){
            Print("File system error. Failed to open activation token file too many times.");
            return(false);
         }else{
            licenseKey = ReadLicenseKey();
            CloseLicenseKeyFile();
         };
      }else{
         licenseKey = m_input_license_key;
      }

      RequestActivation(licenseKey);

      return(IsActivated());
   }

   bool ActivationDidPerform() {
      return(m_activation_did_perform);
   }
};

// Standard libraries
#include <stdlib.mqh>
#include <WinUser32.mqh>

// Now include helpers
#include "Helpers/HttpHelper.mqh"
#include "Helpers/OpenUrlHelper.mqh"
#include "Helpers/StateSetters.mqh"
#include "Helpers/LabelHelper.mqh"
#include "Helpers/UtilHelper.mqh"

#include "Activator/RequestSenders.mqh"
#include "Activator/ResponseHandlers.mqh"
#include "Activator/LicenseKeyStorage.mqh"
